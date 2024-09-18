import boto3

ec2 = boto3.resource('ec2')

subnet_ids=['subnet-0802be74624a5865a', 'subnet-053751d0eaea90843']


for subnet_id in subnet_ids: 
    
   #  simple ec2 instance creation
  response = ec2.create_instances(
    ImageId='ami-0e53db6fd757e38c7',
    InstanceType='t2.micro',
    KeyName='KeyPair19jun',
    MaxCount= 1,
    MinCount= 1,
    SubnetId= subnet_id
  )


print(response)