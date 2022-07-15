provider "aws" {
  region     = var.region
}
data "template_file" "init" {
  template = "${file("all_in_one_script.sh")}"
  vars = {
    instance_identifier = var.WebServerTagName
  }
}
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


//terraform apply -var-file="development.tfvars"
