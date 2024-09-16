# importing the boto3 module
import boto3

# importing the required exceptions
from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

# creating the client object for ec2 service 
client = boto3.client('ec2')

def list_ec2_instances():
     """
      Function to check the count of the EC2 Instances
     """
     try:
        #  calling the Describe Instance API
        response = client.describe_instances()  
        
        #  checking the reservation error
        if  len(response["Reservations"]) == 0:
            print("No Instances are in the console")
        else:
            print(f"Currently There are total of {response["Reservations"]["Instances"]}  EC2 Instances in the console")
     except NoCredentialsError :
         print("Error: No AWS Credentials found. please configure your credentials")
     except PartialCredentialsError:
         print("Error: unable to match the Credentials. check Accesskey and secret Accesskey")
     except ClientError as e :
        #  runs if any client faults
         print(f"Client Error: {e.response} ")
     except Exception as e : 
        #  runs if any exception
         print(f"An unexpected error occured: {str(e)} ")
     return 


# calling the function
list_ec2_instances()    

