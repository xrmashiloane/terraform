import json
import boto3

def lambda_handler(event, context):

    dynamodb = boto3.client('dynamodb')

    table = dynamodb.list_tables(
    )

    print(table['TableNames'][0])

    response = dynamodb.query(
        TableName=table['TableNames'][0],
        )

    print(response)
