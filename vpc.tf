resource "aws_vpc" "main_vpc" {
    assign_generated_ipv6_cidr_block = "false"
    cidr_block = "172.31.0.0/16"
    enable_classiclink = "false"
    enable_classiclink_dns_support = "false"
    enable_dns_hostnames = "true"
    enable_dns_support = "true"
    instance_tenancy = "default"
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main_vpc.id
    tags = {
      "Name" = var.environment
    }
}

resource "aws_route" "r" {
    route_table_id = aws_vpc.main_vpc.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  
}