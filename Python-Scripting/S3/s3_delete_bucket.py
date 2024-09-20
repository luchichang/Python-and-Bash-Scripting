import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

buckets_dict={}
buckets_name=[]

# function for creating the bucket list dict
def list_buckets():
    try:
        # creating the s3 object
        s3_client=boto3.client('s3')
        # calling the list bucket api
        bucket_list_response=s3_client.list_buckets(
            MaxBuckets=12
        )
        count=1
        for bucket in bucket_list_response['Buckets']:
            buckets_name.append(bucket['Name'])
            buckets_dict[count]=bucket['Name']
            count+=1
        buckets_dict[count]=buckets_name
    except NoCredentialsError:
        print(f'Error: Please provide Access Key and Secret Access Key inorder to fetch the request')
    except PartialCredentialsError:
        print(f'Error: Invalid Credentials. Access Key and Secret Access key doesn\'t match.')
    except ClientError as e:
        print(f"Client Error: {e.response['error']}")
    except Exception as e:
        print(f"An unexpected error occured: {str(e)}")


def user_prompt():
    buckets_count=len(buckets_dict)
    print("Enter the number corresponds to the Bucket name for Deleting the bucket ")
    print(f"\n \n for deleting all the bucket enter {buckets_count}")
    for key in buckets_dict:
        if key == buckets_count:
            break
        print(f'{key} : {buckets_dict[key]}')
    usr_choice=int(input('Bucket No:'))
    return usr_choice
    

    # print("user prompt")

# function for deleting the bucket
def delete_bucket(usr_choice):
    try:
        s3_client=boto3.client('s3')
        if usr_choice < len(buckets_dict):
            print(f"Deleteing the bucket {buckets_dict[usr_choice]}")
            # calling the delete bucket api
            s3_client.delete_bucket(
              Bucket=buckets_dict[usr_choice]
            )
            print(f"{buckets_dict[usr_choice]} bucket is deleted successfully.")
        else:
            print("Deleting all the Bucket.")
            # deleting all the buckets
            for b_name in buckets_name:
                s3_client.delete_bucket(
                    Bucket=b_name
                )
            print(f"ALL the Buckets are Deleted.")
    except NoCredentialsError:
        print(f"Error: No Credentials")
    except PartialCredentialsError:
        print(f"Error: Invalid Credentials. Access Key Secret Access Key not matched.")
    except ClientError as e:
        print(f"Client Error: {e.response['Error']['Message']}")
    except Exception as e:
        print(f"An unexpected error occured: {str(e)}")


def main():
    list_buckets()
    usr_choice=user_prompt()
    delete_bucket(usr_choice=usr_choice)

if __name__ == "__main__":
    main()

