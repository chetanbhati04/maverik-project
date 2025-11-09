terraform {
required_version = ">= 1.6.0"
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 5.0"
}
}
}
provider "aws" {
region = "eu-west-1"
}
resource "aws_key_pair" "this" {
key_name = "maverik-key"
public_key = file("~/.ssh/id_ed25519.pub")
}
resource "aws_vpc" "this" {
cidr_block = "10.0.0.0/16"
enable_dns_support = true
enable_dns_hostnames = true
tags = {
Name = "MaverikVPC"
}
}
resource "aws_internet_gateway" "this" {
vpc_id = aws_vpc.this.id
tags = {
Name = "AlfredIGW"
}
}

resource "aws_subnet" "public" {
vpc_id = aws_vpc.this.id
cidr_block = "10.0.1.0/24"
availability_zone = "eu-west-1a"
map_public_ip_on_launch = true

tags = {
Name = "MaverikSubnet"
}
}
resource "aws_route_table" "public" {
vpc_id = aws_vpc.this.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.this.id
}
tags = {
Name = "MaverikRouteTable"
}
}
resource "aws_route_table_association" "public_assoc" {
subnet_id = aws_subnet.public.id
route_table_id = aws_route_table.public.id
}
resource "aws_security_group" "web" {
name = "Maverik-SG"
description = "Allow SSH and HTTP"
vpc_id = aws_vpc.this.id
ingress {
description = "Allow SSH"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
description = "Allow HTTP"
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
tags = {
Name = "MaverikSecurityGroup"
}
}
resource "aws_instance" "web" {
ami = "ami-06297e16b71156b52"
instance_type = "t3.micro"
key_name = aws_key_pair.this.key_name

subnet_id = aws_subnet.public.id
vpc_security_group_ids = [aws_security_group.web.id]
tags = {
Name = "MaverikWebServer"
}
user_data = <<-EOF
#!/bin/bash
set -eux
yum update -y
yum install -y docker
systemctl enable --now docker
usermod -aG docker ec2-user
EOF
}
output "vpc_id" {
value = aws_vpc.this.id
description = "VPC ID"
}

output "security_group_id" {
value = aws_security_group.web.id
description = "Security Group ID"
}
output "ec2_instance_id" {
value = aws_instance.web.id
description = "EC2 Instance ID"
}
output "ec2_public_ip" {
value = aws_instance.web.public_ip
description = "Public IPv4 address for the web instance"
}
