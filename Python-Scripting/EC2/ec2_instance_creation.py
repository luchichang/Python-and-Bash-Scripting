import boto3

ec2 = boto3.resource('ec2')

#  simple ec2 instance creation
response = ec2.create_instances(
  ImageId='ami-0e53db6fd757e38c7',
  InstanceType='t2.micro',
  KeyName='KeyPair19jun',
  MaxCount= 1,
  MinCount= 1
)


print(response)