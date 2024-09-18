import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

# terminates all the instance
def terminate_ec2_instance():
    # creating the client object for boto3 sdk module
    client = boto3.client('ec2')


    try:
       # calling the describe_instances API Method
       response= client.describe_instances()
       if len(response['Reservations']) == 0:
          print("Error: No Instances to be Terminated")
          return 
       instances_ids=[]
       # for all reservations
       for reservation in response['Reservations']:
        # for all instances in reservation
        instances= reservation['Instances']
        for instance in instances:
          if instance['State']['Name'] != 'terminated':
            instances_ids.append(instance['InstanceId'])

       if len(instances_ids) != 0:
           # calling the terminate instance api method
           termination_response=client.terminate_instances(
            InstanceIds= instances_ids
           )
    except NoCredentialsError:
        print("Error: AWS is not Configured")
    except PartialCredentialsError:
        print("Error: Invalid Access Key or Secret Access key ")
    except ClientError as e:
        print(f"Client Error: Invalid Client Request {e.response["Error"]} ")
    except Exception as e:
        print(f"Error: Unexpected error occured {str(e)} ")

   
def main():
   terminate_ec2_instance()
   

if __name__ == "__main__":
   main()
