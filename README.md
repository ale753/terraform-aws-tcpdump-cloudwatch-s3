# terraform-aws-tcpdump-cloudwatch-s3
A simple terraform implementation of a tcpdump listener that push logs on Cloudwatch



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

[Imgur](https://i.imgur.com/swFLN9c.png)