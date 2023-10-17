import json


def lambda_handler(event, context):

    for record in event['Records']:     
        #pull the body out & json load it
        body_rec = record['body']
        body_rec = json.loads(body_rec)
        
        message = body_rec['Records'][0]['body']
        print(message)
        return message
        
