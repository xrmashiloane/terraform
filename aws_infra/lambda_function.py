import json
import requests
import boto3

def lambda_handler(event, context):

        
        message = event['Records'][0]['body']

        query = json.loads(message)

        ssm_client = boto3.client('ssm')
    
        def get_parameter(name):
            parameter = ssm_client.get_parameter(
                Name=name,
                WithDecryption=True                           
                )
            return parameter['Parameter']['Value']
    

        params = {
            "access_key": get_parameter('api_access_key_value'),
            "query": query["query"]
        }

        data = requests.get('http://api.weatherstack.com/current', params=params).json()
        # Save results to dynamo db
    
        if data:
            location = data['location']['name']
            region = data['location']['region']
            country = data['location']['country']
            temperature = data['current']['temperature']
            feels = data['current']['feelslike']
            condition = data['current']['weather_descriptions'][0]
        else:
            return print("Error fetching data")

        return data
        