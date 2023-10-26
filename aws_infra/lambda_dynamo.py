import json
import boto3

def lambda_handler(event, context):
    ssm_client = boto3.client('ssm')

    dynamodb = boto3.client('dynamodb')

    def get_db_name(name):

        parameter = ssm_client.get_parameter(
                Name=name                        
                )
        return parameter['Parameter']['Value']


    print(get_db_name('dynamodb_table'))

    response = dynamodb.query(
        TableName=get_db_name('dynamodb_table')
        )

    print(response)
