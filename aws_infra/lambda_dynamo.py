import boto3
import json
import uuid
from typing import List

def lambda_handler(event, context):
    '''Initialise required boto3 clients'''
    # Define constants
    SSM_DYNAMODB_TABLE_PARAMETER = 'dynamodb_table'
    SSM_SQS_QUEUE_URL_PARAMETER = 'sqs_queue_url'
    
    # Get parameters from SSM
    def get_parameters_from_ssm():
      client = boto3.client('ssm')
  
      database_parameter = client.get_parameter(
        Name=SSM_DYNAMODB_TABLE_PARAMETER  
      )['Parameter']['Value']

      sqs_parameter = client.get_parameter(  
        Name=SSM_SQS_QUEUE_URL_PARAMETER
      )['Parameter']['Value']
 
      return database_parameter, sqs_parameter
    
    database_parameter, sqs_parameter = get_parameters_from_ssm()

    # Get dataset from DynamoDB
    def get_dataset_from_dynamodb(database_parameter):
        '''Get dataset from DynamoDB table'''
        dataset = boto3.client('dynamodb').scan(
            TableName=database_parameter
            )['Items']
        return dataset
    
    dataset = get_dataset_from_dynamodb(database_parameter)
 
    #Create message list for sqs batch
    def create_sqs_list(dataset):
        '''Create list of messages to send to SQS'''
        sqs_messages = []
        for item in dataset:
            sqs_messages.append(item['city']['S'])
        return sqs_messages
    
    def send_sqs_messages(sqs_messages, sqs_parameter):
        '''Send messages to SQS'''
        response = boto3.client('sqs').send_message_batch(
            QueueUrl=sqs_parameter,
            Entries=sqs_messages
        )
        return response

    sqs_messages = create_sqs_list(dataset)
    print(sqs_messages)

    send_sqs_messages(sqs_messages, sqs_parameter)


