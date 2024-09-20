import boto3
from botocore.exceptions import PartialCredentialsError, NoCredentialsError, ClientError
import logging


s3_client = boto3.client('s3')

# bucket_name='s3-webhosting-8y98765'

def create_bucket(bucket_name):
    # creating the s3 client Resource Object
    location = {'LocationConstraint': 'ap-south-1'}
    response= s3_client.create_bucket(
        # ACL='public-read',
        Bucket=bucket_name,
        CreateBucketConfiguration=location,
        # GrantFullControl='rtfc',
        ObjectOwnership='BucketOwnerPreferred',
    )
    # granting the public access to the bucket
    publicaccessresponse=grant_public_access(bucket_name=bucket_name)
    print(response)
    print("--------------------------------------------")
    print(publicaccessresponse)

def grant_public_access(bucket_name):
    response =s3_client.put_public_access_block(Bucket=bucket_name, PublicAccessBlockConfiguration={
    'BlockPublicAcls':False,
    'IgnorePublicAcls':False,
    'BlockPublicPolicy':False,
    'RestrictPublicBuckets':False
    })
    return response





# function for block public access

def main():
    print('Type the Name of the bucket')
    print('note: the name of the bucket should only be in small letter[a-z], numbers[0-9], hyphens - ')
    bucket_name=str(input('Name:'))
    create_bucket(bucket_name=bucket_name)

# create_bucket()
if __name__=="__main__":
    main()
   
     