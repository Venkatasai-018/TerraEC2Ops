# TerraEC2Ops
TerraEC2Ops



# Ec2 Auto Stop and Start Schedular

Automatically start Ec2 in the morning and stops in night to save the cost

Implementation

-> Terraform Provisions EC2+IAM role
-> Cloud watch Event Rule Triggers Lambda
-> Lambda to start/Stop the instance based on Schedule
-> Sending Email Notification when instance stop/starts

Terraform,EC2,Lambda,cloudWatch,SNS


# EC2 Auto Shutdown for Idle Instances

Detect the idle EC2(low CPU/network) and automatically stop them.

Implementation

-> Cloud Watch monitor CPU/network Metrics
-> Lambda checks Thersholds -> triggers EC2 to Stop
-> Optional auto-start during peak hours

Terraform, CloudWatch Metrics,Lambda,EC2


# 