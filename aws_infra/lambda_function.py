import json
import requests
import boto3

def lambda_handler(event, context):

    client = boto3()

        # Define constants
    SSM_DYNAMODB_TABLE_PARAMETER = 'dynamodb_table'
    API_ACCESS_KEY_PARAMETER = 'api_access_key_value'
    
    # Get parameters from SSM
    def get_parameters_from_ssm():
      client = client('ssm')
  
      database_parameter = client.get_parameter(
        Name=SSM_DYNAMODB_TABLE_PARAMETER  
      )['Parameter']['Value']

      access_key = client.get_parameter(  
        Name=API_ACCESS_KEY_PARAMETER
      )['Parameter']['Value']
 
      return database_parameter, access_key
    
    database_parameter, access_key = get_parameters_from_ssm()

    
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
    
        #Prepare variables for dynamodb
        city = weather_data['location']['name']
        region = weather_data['location']['region']
        country = weather_data['location']['country']
        temperature = weather_data['current']['temperature']
        feels = weather_data['current']['feelslike']
        condition = weather_data['current']['weather_descriptions'][0]

        item = {
        'city': city,
        'region': region,
        'country': country,
        'temperature': temperature,
        'feels': feels,
        'condition': condition,
        }

        client('dynamodb').put_item(
           TableName=database_parameter,
           item=item
        )
    #Add item to db
    call_weather_api(access_key, location_query)