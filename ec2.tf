provider "aws" {
  region     = var.region
}

data "template_file" "init" {
  template = "${file("all_in_one_script.sh")}"
  vars = {
    instance_identifier = var.WebServerTagName
  }
}
//https://stackoverflow.com/questions/50835636/accessing-terraform-variables-within-user-data-provider-template-file
resource "aws_instance" "web_server" {
  ami             = var.AmiLinux
  instance_type   = "t2.micro"
  user_data = "${data.template_file.init.rendered}"
  key_name = "testkeypair"
  iam_instance_profile = aws_iam_instance_profile.ec2-cloudwatch-instance-profile.name
  tags = {
    Name = var.WebServerTagName
    Environment = var.environment
  }
}

//https://cloudanddevopstech.com/2020/11/01/terraform-aws-ec2-with-ssm-agent-installed/



//terraform apply -var-file="development.tfvars"
