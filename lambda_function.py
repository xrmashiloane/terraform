import json


def lambda_handler(event, context):
        
        message = event['Records'][0]['body']
        print(message)
        return message
        
