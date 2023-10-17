import json


def lambda_handler(event, context):
    
    print(event)

    print(event.get("body"))

    print("---------")

    print(context)