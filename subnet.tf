resource "aws_subnet" "main_subnet" {
    assign_ipv6_address_on_creation = "false"
    cidr_block = "172.31.32.0/20"
    enable_dns64 = "false"
    enable_resource_name_dns_a_record_on_launch = "false"
    enable_resource_name_dns_aaaa_record_on_launch = "false"
    ipv6_native = "false"
    map_public_ip_on_launch = "true"
    private_dns_hostname_type_on_launch = "ip-name"
    vpc_id = aws_vpc.main_vpc.id
}