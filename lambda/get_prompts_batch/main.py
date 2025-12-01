import os
import json
import boto3
from decimal import Decimal
from boto3.dynamodb.conditions import Attr

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["PROMPTS_TABLE_NAME"])


def _dynamo_to_regular(obj):
    """
    Convert DynamoDB Decimal to native Python types for JSON serialization.
    """
    if isinstance(obj, list):
        return [_dynamo_to_regular(x) for x in obj]
    if isinstance(obj, dict):
        return {k: _dynamo_to_regular(v) for k, v in obj.items()}
    if isinstance(obj, Decimal):
        # Convert to int if it is integral, else float
        if obj % 1 == 0:
            return int(obj)
        return float(obj)
    return obj


def _parse_prompt_ids(raw):
    """
    Accepts:
      - JSON list string: '["landing:greeting:en","queue:offer_callback_voicemail:en"]'
      - Comma-separated string: "landing:greeting:en,queue:offer_callback_voicemail:en"
      - Already a list (if invoked from tests).
    Returns a list of strings or [].
    """
    if not raw:
        return []

    if isinstance(raw, list):
        return [str(x).strip() for x in raw if x]

    if isinstance(raw, str):
        raw = raw.strip()
        if not raw:
            return []
        # Try JSON list first
        try:
            data = json.loads(raw)
            if isinstance(data, list):
                return [str(x).strip() for x in data if x]
        except json.JSONDecodeError:
            pass
        # Fallback to comma-separated
        return [part.strip() for part in raw.split(",") if part.strip()]

    # Fallback: unknown type
    return []


def handler(event, context):
    """
    Event structure from Amazon Connect:

    event["Details"]["ContactData"]["Attributes"]   -> user-defined attributes
    event["Details"]["Parameters"]                  -> Lambda block parameters

    Supported inputs:

    1) Explicit PromptIds:
       - Details.Parameters.PromptIds
       - or Details.ContactData.Attributes.PromptIds
       Example formats:
         "landing:greeting:en,queue:offer_callback_voicemail:en"
         '["landing:greeting:en","queue:offer_callback_voicemail:en"]'

    2) Filter-based:
       If PromptIds not provided, we attempt a filtered scan using:
       - Category  (Parameters.Category or Attributes.PromptCategory)
       - Department (Parameters.Department or Attributes.LineOfBusiness)
       - Language  (Parameters.Language or Attributes.CallerLanguage)

       This is fine for small configuration tables like prompts.
    """
    print("Event:", json.dumps(event))

    details = event.get("Details", {})
    contact_data = details.get("ContactData", {})
    attributes = contact_data.get("Attributes", {}) or {}
    params = details.get("Parameters", {}) or {}

    # 1) Gather PromptIds if provided
    raw_prompt_ids = (
        params.get("PromptIds")
        or attributes.get("PromptIds")
    )
    prompt_ids = _parse_prompt_ids(raw_prompt_ids)

    items = []

    # -------------------------------
    # Mode 1: BatchGetItem by PromptIds
    # -------------------------------
    if prompt_ids:
        keys = [{"PromptId": pid} for pid in prompt_ids]
        print("Fetching prompts by PromptIds:", prompt_ids)

        # DynamoDB BatchGetItem can return unprocessed keys; keep it simple for now
        client = boto3.client("dynamodb")
        resp = client.batch_get_item(
            RequestItems={
                table.name: {
                    "Keys": [{"PromptId": {"S": pid}} for pid in prompt_ids]
                }
            }
        )

        raw_items = resp.get("Responses", {}).get(table.name, [])
        for raw in raw_items:
            # raw is in AttributeValue form; use the Table resource to normalize or convert manually
            item = {
                k: list(v.values())[0]
                for k, v in raw.items()
            }
            items.append(item)

    # -------------------------------
    # Mode 2: Filtered Scan (small tables)
    # -------------------------------
    else:
        category = params.get("Category") or attributes.get("PromptCategory")
        department = params.get("Department") or attributes.get("LineOfBusiness")
        language = params.get("Language") or attributes.get("CallerLanguage")

        # Build a filter expression for the scan
        filter_expr = None

        if category:
            expr = Attr("Category").eq(category)
            filter_expr = expr if filter_expr is None else filter_expr & expr

        if department:
            expr = Attr("Department").eq(department)
            filter_expr = expr if filter_expr is None else filter_expr & expr

        if language:
            expr = Attr("Language").eq(language)
            filter_expr = expr if filter_expr is None else filter_expr & expr

        scan_kwargs = {}
        if filter_expr is not None:
            scan_kwargs["FilterExpression"] = filter_expr

        print("Scanning table", table.name, "with filters:", {
            "category": category,
            "department": department,
            "language": language
        })

        try:
            resp = table.scan(**scan_kwargs)
            items.extend(resp.get("Items", []))

            # Simple pagination handling if there are more pages
            while "LastEvaluatedKey" in resp:
                resp = table.scan(
                    ExclusiveStartKey=resp["LastEvaluatedKey"],
                    **scan_kwargs
                )
                items.extend(resp.get("Items", []))

        except Exception as e:
            print("Error scanning DynamoDB:", e)
            # Return empty result but don't hard fail the call
            return {
                "prompts": {},
                "items": []
            }

    # Normalize for JSON
    items = [_dynamo_to_regular(it) for it in items]

    # Build a simple PromptId -> PromptText map
    prompts_by_id = {}
    for it in items:
        pid = it.get("PromptId")
        text = it.get("PromptText")
        if pid and text:
            prompts_by_id[pid] = text

    # Build PromptType-based keys for easy use in Connect
    queue_greeting_prompt = None
    queue_high_wait_intro_prompt = None
    queue_callback_menu_prompt = None
    queue_hold_message_prompt = None

    for it in items:
        ptype = it.get("PromptType")
        text = it.get("PromptText")
        if not ptype or not text:
            continue

        if ptype == "queue_greeting":
            queue_greeting_prompt = text
        elif ptype == "queue_high_wait_intro":
            queue_high_wait_intro_prompt = text
        elif ptype == "queue_callback_menu":
            queue_callback_menu_prompt = text
        elif ptype == "queue_hold_message":
            queue_hold_message_prompt = text

    result = {
        # Full raw data
        "items": items,
        "promptsById": prompts_by_id,

        # Easy-to-use top-level keys for Amazon Connect
        "queueGreetingPrompt": queue_greeting_prompt,
        "queueHighWaitIntroPrompt": queue_high_wait_intro_prompt,
        "queueCallbackMenuPrompt": queue_callback_menu_prompt,
        "queueHoldMessagePrompt": queue_hold_message_prompt,
    }

    print("Result:", json.dumps(result))
    return result



    # Normalize for JSON
    # items = [_dynamo_to_regular(it) for it in items]

    # # Build a simple PromptId -> PromptText map
    # prompts_map = {}
    # for it in items:
    #     pid = it.get("PromptId")
    #     text = it.get("PromptText")
    #     if pid and text:
    #         prompts_map[pid] = text

    # result = {
    #     "prompts": prompts_map,
    #     "items": items,
    # }

    # print("Result:", json.dumps(result))
    # return result
