import json
import requests
import boto3

def lambda_handler(event, context):

    cities = requests.get('https://raw.githubusercontent.com/xrmashiloane/cities/main/cities.txt')
    
    cities_text = cities.content.decode()

    cities_list = cities_text.splitlines()

    ssm_client = boto3.client('ssm')

    def get_parameter(name):
        parameter = ssm_client.get_parameter(
            Name=name,
            WithDecryption=True                           
            )
        return parameter['Parameter']['Value']
    

    params = {
        "access_key": get_parameter('access_key'),
        "query": event.get('query')
    }
    request = requests.get('http://api.weatherstack.com/current', params=params).json()
    # Save results to dynamo db
    
    if request:
        location = request['location']['name']
        region = request['location']['region']
        country = request['location']['country']
        temperature = request['current']['temperature']
        feels = request['current']['feelslike']
        condition = request['current']['weather_descriptions'][0]
    else:
        return print("Error fetching data")

    return request
  