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
  #key_name = "testkeypair"
  availability_zone = aws_subnet.main_subnet.availability_zone

  iam_instance_profile = aws_iam_instance_profile.ec2-cloudwatch-instance-profile.name
  tags = {
    Name = var.WebServerTagName
    Environment = var.environment
  }

  subnet_id = aws_subnet.main_subnet.id
  tenancy = "default"
  vpc_security_group_ids = [aws_security_group.ec2_sec_group.id]

}


//terraform apply -var-file="development.tfvars"
