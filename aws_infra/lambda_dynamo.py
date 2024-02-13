import boto3
import json

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
        print(dataset)
        for loc in dataset:
            location = loc['city']['S']
            sqs_messages.append(
                QueueUrl=sqs_parameter,
                MessageBody=location
            )
        return sqs_messages
    #Send Message
    response = boto3.client('sqs').send_message_batch(create_sqs_list(dataset))

    print(response)
