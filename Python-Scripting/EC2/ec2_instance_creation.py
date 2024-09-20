import boto3

ec2 = boto3.resource('ec2')

subnet_ids=['subnet-0802be74624a5865a', 'subnet-053751d0eaea90843']

amazon_image_id={ 'ubuntu':'ami-0522ab6e1ddcc7055','amazon-linux':'ami-0e53db6fd757e38c7'}

for subnet_id in subnet_ids: 
    
   #  simple ec2 instance creation
  response = ec2.create_instances(
    ImageId= amazon_image_id['ubuntu'],
    InstanceType='t2.micro',
    KeyName='KeyPair19jun',
    MaxCount= 1,
    MinCount= 1,
    SubnetId= subnet_id,
    LaunchTemplate={
      'LaunchTemplateId':'lt-0e2c358b49f502e2b',
      # 'Version':'4'
    },
  )


print(response)