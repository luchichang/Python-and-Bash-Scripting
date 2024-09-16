# importing the boto3 package
import boto3

#  creating object for ec2 resource 
client = boto3.client('ec2')


response = client.describe_instances()

# Displaying the instances length 
print(f"Total no of Instances: {len(response["Reservations"][0]["Instances"])}")

