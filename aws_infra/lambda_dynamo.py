import boto3
import json

def lambda_handler(event, context):
    ssm_client = boto3.client('ssm')
    sqs_client = boto3.client('sqs')
    dynamodb = boto3.client('dynamodb')


    database_parameter = ssm_client.get_parameter(
                Name='dynamodb_table'                        
                )['Parameter']['Value']
    sqs_parameter = ssm_client.get_parameter(
                Name='sqs_queue_url'                        
                )['Parameter']['Value']

    dataset = dynamodb.scan(
        TableName=database_parameter,
        ProjectionExpression='city'
        )['Items']
    
    for loc in dataset:
        
        message_dict = {}
        query = "query"
        location = loc['city']['S']

        for variable in ["query", "location"]:
            message_dict[variable] = eval(variable)



        print(message_dict)

        message = json.dumps(message_dict)

        print(type(message))


        response = sqs_client.send_message(
            QueueUrl=sqs_parameter,
            MessageBody= message
            )
        print("Message sent ")
        
        print(response['MessageId'])

        print(loc['city']['S'])