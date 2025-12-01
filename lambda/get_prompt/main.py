import os
import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["PROMPTS_TABLE_NAME"])


def handler(event, context):
    """
    Expected ways to get PromptId:

    1) From contact attributes:
       event["Details"]["ContactData"]["Attributes"]["PromptId"]

    2) From function input parameters in the flow:
       event["Details"]["Parameters"]["PromptId"]
    """
    print("Event:", json.dumps(event))

    details = event.get("Details", {})
    contact_data = details.get("ContactData", {})
    attributes = contact_data.get("Attributes", {})
    params = details.get("Parameters", {})

    prompt_id = (
        params.get("PromptId")
        or attributes.get("PromptId")
        or attributes.get("prompt_id")
    )

    if not prompt_id:
        # Return a safe default
        return {
            "promptText": "We are unable to retrieve the requested prompt at this time. Please hold while we connect your call."
        }

    try:
        resp = table.get_item(Key={"PromptId": prompt_id})
        item = resp.get("Item")

        if not item:
            return {
                "promptText": f"Prompt {prompt_id} is not configured. Please contact support."
            }

        prompt_text = item.get("PromptText") or "Prompt text not found."

        # Must return simple JSON key/values so Connect can use $.External.promptText
        return {
            "promptText": prompt_text,
            "promptId": prompt_id,
            "category": item.get("Category", ""),
            "language": item.get("Language", "")
        }

    except Exception as e:
        print("Error fetching prompt:", e)
        return {
            "promptText": "We are experiencing technical difficulties. Please hold while we connect your call."
        }
