import json
import boto3
import os

def lambda_handler(event, context):
    # TODO implement

    templateName = event['component']+'LaunchTemplate'

    lt = boto3.client('ec2')

    lt_details = lt.describe_launch_templates(LaunchTemplateNames= [ templateName ],)

    lt_source_version = str(lt_details['LaunchTemplates'][0]['LatestVersionNumber'])

    try:
        lt_status = lt.create_launch_template_version(
            LaunchTemplateName= templateName,
            LaunchTemplateData= {},
            SourceVersion= lt_source_version ,
            VersionDescription= 'Version :'+ lt_source_version,
        )
    except:
        print (f"ERROR: refer LOG GROUP:{os.environ['AWS_LAMBDA_LOG_GROUP_NAME']}, LOG STREAM:{os.environ['AWS_LAMBDA_LOG_STREAM_NAME']}")
        return
    
    print ("SUCCESSFULLY CREATED NEW TEMPLATE VERSION")

    asg = boto3.client('autoscaling')

    try:
        status = asg.start_instance_refresh(
            AutoScalingGroupName= event['component']+'ASG',
            DesiredConfiguration={
                'LaunchTemplate':{
                    'LaunchTemplateName': event['component']+'LaunchTemplate',
                    'Version': '$Latest',
                },
            },
            Preferences= {
                'MinHealthyPercentage': 1,
                'InstanceWarmup': 30,
            },
        )
    except:
        print (f"ERROR: refer LOG GROUP:{os.environ['AWS_LAMBDA_LOG_GROUP_NAME']}, LOG STREAM:{os.environ['AWS_LAMBDA_LOG_STREAM_NAME']}")
        return
    
    print ("SUCCESSFULLY PERFORMED INSTANCE REFRESH")
    
    return 
        
