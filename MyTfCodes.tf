# -----> Terraform Assignment 4 & 5 <-----

# Providers Block ----------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Resource Block ----------
# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = "20.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "My_VPC"
  }
}
# Create Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "20.0.1.0/24"    # Sub-CIDR of VPC
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public"
  }
}
resource "aws_subnet" "private_subnet" {
 vpc_id         = aws_vpc.my_vpc.id
 cidr_block     = "20.0.2.0/24"
 availability_zone = "us-east-1b"
 #map_public_ip_on_launch = false
 tags = {
  Name = "Private"
 }
}
# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My_Internet_Gateway"
  }
}
# Create Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.my_igw.id # Attaching Internet Gateway
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "Public_Route_Table"
  }
}
# Subnet & Route table association
resource "aws_route_table_association" "a" {
  subnet_id         = aws_subnet.public_subnet.id
  route_table_id    = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "b" {
  subnet_id         = aws_subnet.private_subnet.id
  route_table_id    = aws_route_table.public_rt.id
}
# Create Security Group - Web Traffic
resource "aws_security_group" "new-vpc-sg" {
  name        = "new-vpc-sg"
  description = "new SG in new VPC"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all IP and Ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
  Name = "New_VPC_SG"
 }
}
# Create an EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0440d3b780d96b29d"  # Amazon Linux 2 (or choose your preferred AMI)
  instance_type = "t2.micro"  # Change to your desired instance type
  key_name      = "us-east1"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.new-vpc-sg.id]  # Use security group ID instead of name
#  vpc_id        = aws_vpc.my_vpc.id
  associate_public_ip_address     = true
  tags = {
  Name = "My_Instance"
 }
  # User data script to install Apache and start it
  user_data = "${file("install_apache2.sh")}"
}

output "IPv4" {
        value = aws_instance.my_instance.public_ip
}



sudo nano install_apache2.sh
#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd
sudo su
echo "Hi, Welcome to my EC2 Instance. This is customised apache2 web page." > /var/www/html/index.html









