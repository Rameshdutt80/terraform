provider "aws" {
  region = "us-east-2"
  access_key = var.access
  secret_key = var.secret
}

# Create VPC
resource "aws_vpc" "VT-VPC" {
  cidr_block       = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

#Create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.VT-VPC.id

  tags = {
    Name = var.InternetG_name
  }
}

# Create Route tables
resource "aws_route_table" "VT-PublicRT" {
  vpc_id = aws_vpc.VT-VPC.id

  route {
    cidr_block = var.default_RT_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block  = var.ipv6_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "VT-Web-RT"
  }
}

resource "aws_route_table" "VT-DBRoute" {
 vpc_id = aws_vpc.VT-VPC.id

 route {
   cidr_block = var.default_RT_cidr
   # nat_gateway_id = var.natgw_id
 }

  tags = {
   Name = "VT-DB-RT"
 }
}

# Create subnet 
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.VT-VPC.id
  cidr_block = var.public_subnet_cidr_block
  availability_zone = var.available_zone
  map_public_ip_on_launch = true
  

  tags = {
    Name = var.subnet_name1
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.VT-VPC.id
  cidr_block = var.private_subnet_cidr_block
  availability_zone = var.available_zone
  map_public_ip_on_launch = false
  

  tags = {
    Name = var.subnet_name2
  }
}
#route table association

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.VT-PublicRT.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.VT-DBRoute.id
}

# Declaring security group

resource "aws_security_group" "allow_web" {
  name        = "allow_web_trafic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.VT-VPC.id

  ingress {
    description      = "htttps"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    #rule_no          = 100
    #action           = "allow"
    cidr_blocks      = [var.default_RT_cidr]
  }

  ingress {
    description      = "htttp"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    #rule_no          = 200
    #action           = "allow"
    cidr_blocks      = [var.default_RT_cidr]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    # rule_no          = 300
    # action           = "allow"
    cidr_blocks      = [var.my_ip_add]
  }

  egress {
    description      = "htttps"
    protocol         = "tcp"
    # rule_no          = 100
    # action           = "allow"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = [var.default_RT_cidr]
  }
  
  egress {
    description      = "htttp"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    # rule_no          = 200
    # action           = "allow"
    cidr_blocks      = [var.default_RT_cidr]
  }

  egress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    # rule_no          = 300
    # action           = "allow"
    cidr_blocks      = [var.my_ip_add]
  }

  tags = {
    Name = "allow_Web"
  }
}

# # create Network interface

resource "aws_network_interface" "VT-NWI" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = [var.private_ip]
  security_groups = [aws_security_group.allow_web.id]
}

#  resource "aws_eip" "ProdEIP" {
#   vpc                       = true
#   network_interface         = aws_network_interface.ProdNWWeb.id
#   associate_with_private_ip = "10.0.1.50"
#   depends_on                = [aws_internet_gateway.gw]
# }

# output "server_ip_address" {
#   value = aws_eip.ProdEIP.public_ip
# }


resource "aws_instance" "webServer" {
  ami           = "ami-00399ec92321828f5"
  instance_type = var.instance_t
  availability_zone = "us-east-2a"
  key_name      = "getthejob"
  network_interface {
    network_interface_id = aws_network_interface.VT-NWI.id
    device_index         = 0
  }
  
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your very first web server > /var/www/html/index.html'
              EOF
  tags = {
    Name = "VT-WebServer"
  }
}

