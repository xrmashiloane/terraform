import boto3
import json

def lambda_handler(event, context):
    ssm_client = boto3.client('ssm')
    sqs_client = boto3.client('sqs')
    dynamodb = boto3.client('dynamodb')


    database_parameter = ssm_client.get_parameter(
                Name='dynamodb_table'                        
                )
    sqs_parameter = ssm_client.get_parameter(
                Name='sqs_queue_url'                        
                )

    dataset = dynamodb.scan(
        TableName=database_parameter['Parameter']['Value'],
        ProjectionExpression='city'
        )['Items']
    
    for loc in dataset:
        message = [ "query" , loc['location']['S'] ]
        message = json.loads(str(message))

        response = sqs_client.send_message(
            QueueUrl=sqs_parameter,
            MessageBody=message
            )
        print("Messahe sent ")
        print(response['MessageId'])

        print(loc['location']['S'])