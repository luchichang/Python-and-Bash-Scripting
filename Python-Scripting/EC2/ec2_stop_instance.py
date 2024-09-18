
# importing the boto3 module

import boto3

# creating the object for low level client for ec2 service
ec2_Client = boto3.client('ec2')

response = ec2_Client.stop_instances(
    
)