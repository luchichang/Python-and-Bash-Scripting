# importing the boto3 sdk module
import boto3

# importing the necessary exceptions
from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

# creating an Client object for S3 Resource
client = boto3.client('ec2')


# setting the global variable of dict datatype for state
instance_states={1:'pending',2:'running',3:'shutting-down',4:'terminated',5:'stopping',6:'stopped'}

def list_instances_statewise(instance_state):
     """
       Gets the necessary state as a parameter and lists the necessary instances.
    
     """
     
     try:
        #  calling the boto3 api
        response = client.describe_instances(
             Filters=[
                 {
                     'Name': 'instance-state-name',
                     'Values': [
                          instance_state
                     ]
                 }
               ]
          )
     except NoCredentialsError:
         print("Error: No Credentials found.")
     except PartialCredentialsError:
         print("Error: invalid Access key or Secret Access Key.")
     except ClientError as e:
         print(f"Client Error: {e.response['error']}")
     except Exception as e:
         print(f"An unexpected error occured: {str(e)}")    

     # if no running instance
     if len(response['Reservations']) == 0:
         print(f"Currently No Instances are in the {instance_state} state. " )   
     else:
         instances= response['Reservations'][0]['Instances']
         print(f"There are currently {len(instances)} in {instance_state} in the console ")
         print(f"Instance Id              Instance Type") 
     #     looping through the instances
         for instance in instances:
             print(f"{instance['InstanceId']}         {instance['InstanceType']}")
     # print(response)
     return


def user_input_prompt():
     """
      makes the user understand the expected value and validates it and pass it to the AWS api call
     """
     print(f"Enter the number corresponds to the displayed instance state ")
#    looping through the dict datatype
     for state_key in instance_states:
     #     using the f-strin (format string)
          print(f" {state_key}: {instance_states[state_key]}")
     try:
           # getting the user value
          # note: by default input will be in string have to convert it into integer 
          usr_dsrd_state_key = int(input('Enter the no corresponding to your desired state: '))    
          if usr_dsrd_state_key <=0 or usr_dsrd_state_key > len(instance_states) :
               print("Error: out of value range. value should be only from (1-6)")
               return -1
          else :
            print(f"please wait... fetching the no of Instances in the {instance_states[usr_dsrd_state_key]} state.")
             #   calling the list instance function
            list_instances_statewise(instance_state=instance_states[usr_dsrd_state_key])     
     except ValueError:
          #  if unable or wrong data is entered in usr prompt value error will be raised
          print(f"Error: Invalid input. please enter a number")
     return


def main():

    user_input_prompt()
 
    return


# calling the only if the file is run directly instead of importing
if __name__ == "__main__":
     main() 