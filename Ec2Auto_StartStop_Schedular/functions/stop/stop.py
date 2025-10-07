import os
import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    sns = boto3.client('sns')
    instance_ids = os.environ['INSTANCE_IDS'].split(',')
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']
    
    try:
        ec2.stop_instances(InstanceIds=instance_ids)
        print(f'Successfully stopped instances: {instance_ids}')
        sns.publish(
            TopicArn=sns_topic_arn,
            Message=f'Successfully stopped instances: {instance_ids}',
            Subject='EC2 Instances Stopped'
        )
    except Exception as e:
        print(f'Error stopping instances: {e}')
        sns.publish(
            TopicArn=sns_topic_arn,
            Message=f'Error stopping instances: {e}',
            Subject='EC2 Instances Stopping Error'
        )
