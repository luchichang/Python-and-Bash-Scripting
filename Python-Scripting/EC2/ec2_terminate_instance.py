import boto3

# terminates all the instance

# creating the client object for boto3 sdk module
client = boto3.client('ec2')


response= client.describe_instances()

reservations= response['Reservations']

instances_ids=[]
# for all reservations
for reservation in reservations:
    # for all instances in reservation
    instances= reservation['Instances']
    for instance in instances:
        instances_ids.append(instance['InstanceId'])

# calling the terminate instance api method
termination_response=client.terminate_instances(
    InstanceIds= instances_ids
)
print(termination_response) 