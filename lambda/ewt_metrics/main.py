import os
import json
import boto3

connect = boto3.client("connect")

INSTANCE_ID = os.environ["CONNECT_INSTANCE_ID"]


def handler(event, context):
    """
    Expected input:
      - queueId from:
          event["Details"]["Parameters"]["QueueId"]
        or event["Details"]["ContactData"]["Queue"]["Id"]

    Output:
      - estimatedWaitSeconds
      - overThreshold (string "true"/"false")
    """
    print("Event:", json.dumps(event))

    details = event.get("Details", {})
    contact_data = details.get("ContactData", {})
    params = details.get("Parameters", {})

    queue_info = contact_data.get("Queue", {})
    queue_id = params.get("QueueId") or queue_info.get("Id")

    if not queue_id:
        # Fail safe: no queue info
        return {
            "estimatedWaitSeconds": 0,
            "overThreshold": "false"
        }

    # Very simplified example. See the AWS EWT sample repo for a more robust approach.
    try:
        resp = connect.get_current_metric_data(
            InstanceId=INSTANCE_ID,
            Filters={
                "Queues": [queue_id],
                "Channels": ["VOICE"],
            },
            CurrentMetrics=[
                {"Name": "AGENTS_AVAILABLE", "Unit": "COUNT"},
                {"Name": "CONTACTS_IN_QUEUE", "Unit": "COUNT"},
                {"Name": "HANDLE_TIME", "Unit": "SECONDS"},
            ]
        )
        metrics = resp.get("MetricResults", [])
        agents_available = 0
        contacts_in_queue = 0
        avg_handle_time = 120  # default 2 minutes

        if metrics:
            collections = metrics[0].get("Collections", [])
            for c in collections:
                name = c.get("Metric", {}).get("Name")
                value = c.get("Value", 0)
                if name == "AGENTS_AVAILABLE":
                    agents_available = int(value)
                elif name == "CONTACTS_IN_QUEUE":
                    contacts_in_queue = int(value)
                elif name == "HANDLE_TIME":
                    avg_handle_time = max(int(value), 60)

        # Very naive EWT formula
        if agents_available <= 0:
            estimated_wait_seconds = contacts_in_queue * avg_handle_time
        else:
            estimated_wait_seconds = int(
                (contacts_in_queue * avg_handle_time) / max(1, agents_available)
            )

        over_threshold = "true" if estimated_wait_seconds > 120 else "false"

        return {
            "estimatedWaitSeconds": estimated_wait_seconds,
            "overThreshold": over_threshold
        }

    except Exception as e:
        print("Error getting metrics:", e)
        return {
            "estimatedWaitSeconds": 0,
            "overThreshold": "false"
        }
