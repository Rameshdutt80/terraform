access = "AKIA4HJ5PAJGGGKACXB3"
secret = "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"

#VPC 
vpc_cidr_block     = "10.0.0.0/16"
vpc_name = "VT-VPC"

#internet gateway
InternetG_name = "VT-IGW"

#Route Table
default_RT_cidr = "0.0.0.0/0"
ipv6_cidr_block = "::/0"

# subnet1
public_subnet_cidr_block= "10.0.1.0/24"
available_zone     = "us-east-2a"
subnet_name1 = "VT-Web-Subnet"
private_subnet_cidr_block = "10.0.2.0/24"
subnet_name2 = "VT-Db-Subnet"

private_ip = "10.0.1.50"

my_ip_add = "117.195.90.49/32" 

instance_t = "t2.micro"