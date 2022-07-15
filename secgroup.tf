resource "aws_security_group" "ec2_sec_group" {
    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "0"
        protocol = "-1"
        self = "false"
        to_port = "0"
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "3000"
        protocol = "tcp"
        self = "false"
        to_port = "3000"
    }
    name = "tcp300secgroup"
    vpc_id = aws_vpc.main_vpc.id

}