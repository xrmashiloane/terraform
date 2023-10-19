import json
import requests
import boto3

def lambda_handler(event, context):
  
        results = []

        raw_text = event['Records'][0]['body']
        
        cities_list = raw_text.replace("\\n", ",")
        
        cities_list = cities_list.replace('\"', '')
        
        cities = cities_list.split(",")
            
        ssm_client = boto3.client('ssm')
    
        def get_parameter(name):
            parameter = ssm_client.get_parameter(
                Name=name,
                WithDecryption=True                           
                )
            return parameter['Parameter']['Value']
        
        

        def get_current_conditions(list):
                 for city in list:
                    print(city)
                    params = {
                        "access_key": get_parameter('api_access_key_value'),
                        "query": "{city}".format(city=city)
                    }
                    data = requests.get('http://api.weatherstack.com/current', params=params).json()

                           
                    return data
            
        get_current_conditions(cities)

        
                    

        
        
