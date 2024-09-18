# importing the boto3 package
import boto3

#  creating object for ec2 resource 
client = boto3.client('ec2')


# calling describe_instances API
response = client.describe_instances()

# print(response)

if len(response['Reservations']) == 0 :
    print("no instances are in the console")
else :
     # Displaying the instances length 
    print(f"Total no of Instances: {len(response['Reservations'][0]['Instances'])} are in {response.get('Reservations')[0]['Instances'][0]['State']['Name']}")

