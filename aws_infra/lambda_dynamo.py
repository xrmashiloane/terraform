import boto3
import json

def lambda_handler(event, context):
    '''Initialise required boto3 clients'''
    ssm_client = boto3.client('ssm')
    sqs_client = boto3.client('sqs')
    dynamodb = boto3.client('dynamodb')

    #Get DynamoDB table name from SSM Parameter store
    database_parameter = ssm_client.get_parameter(
                Name='dynamodb_table'                        
                )['Parameter']['Value']
    #Get SQS Queue URL
    sqs_parameter = ssm_client.get_parameter(
                Name='sqs_queue_url'                        
                )['Parameter']['Value']
    #Scan DynamoDB table for Town Names
    dataset = dynamodb.scan(
        TableName=database_parameter,
        ProjectionExpression='city'
        )['Items']
    
    #For each city name Send name of city to SQS
    for loc in dataset:
        
        location = loc['location']['S']

        response = sqs_client.send_message(
            QueueUrl=sqs_parameter,
            MessageBody= location
            )
        print("Message sent ")
        print(response['MessageId'])
        print(loc['location']['S'])