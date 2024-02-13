import json
import requests
import boto3

def lambda_handler(event, context):

    client = boto3()
    
    def get_access_key(name):
        parameter = client('ssm').get_parameter(
            Name=name,
            WithDecryption=True                           
        )
        return parameter['Parameter']['Value']

    access_key = get_access_key('api_access_key_value')
    location_query = event['Records'][0]['body']
    
    def call_weather_api(access_key, location_query):
        params = {"access_key": access_key, "query": location_query}
        #Check response
        try:
          weather_data = requests.get('http://api.weatherstack.com/current', params=params).json()
        except ValueError:
          return {"error": "Invalid response from API"}

        if not weather_data:
          return {"error": "No data returned from API"}
    

        location = weather_data['location']['name']
        region = weather_data['location']['region']
        country = weather_data['location']['country']
        temperature = weather_data['current']['temperature']
        feels = weather_data['current']['feelslike']
        condition = weather_data['current']['weather_descriptions'][0]

        #Prepare variables for dynamodb
        item = {
             'location': location,
              'region': region, 
              'country': country,
             'temperature': temperature,
              'feels': feels,
             'condition': condition
        }

        client('dynamodb').put_item(
           TableName='weather_data',
           item=item
        )
    #Add item to db
    call_weather_api(access_key, location_query)