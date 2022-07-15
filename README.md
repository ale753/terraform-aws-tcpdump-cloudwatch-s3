# terraform-aws-tcpdump-cloudwatch-s3
A simple terraform implementation of a tcpdump listener that push logs on Cloudwatch
This Terraform project will create:
- 1 VPC
- 1 Subnet
- 1 EC2 Ubuntu 22.4 Server Instance with security group
- S3 Bucket with correct policy defintions
- IAM policies and instance profiles for EC2

The user-data script installs Cloudwatch Agent, tcpdump daemon and react application. Note that it is reccomended that you create a custom image with the application installed rather than installing it every time (especially if you need to autoscale and often stop and reboot instances )


## Diagram of the simple architecture

[![Screenshot-from-2020-11-01-20-44-17.png](https://i.imgur.com/swFLN9c.png)](https://imgur.com/swFLN9c)




## Run
Create a file called development.tfvars and assign the correct values to the variables.

Example:

environment = "dev"
bucket_name = "instanceloggingbucket"
region = "eu-west-1"
AmiLinux= "ami-0d75513e7706cf2d9"
WebServerTagName="test-react-webserver"

The ami-id "ami-0d75513e7706cf2d9" is the aws managed ami for Ubuntu 22.04 Server AMD64


Launch:

terraform init
terraform apply -var-file="development.tfvars"


