variable "access" {
  description = "access key"
  type        = string
}
variable "secret" {
  description = "secret key"
  type        = string
}

# vpc variables
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string 
}

variable "vpc_name" {
  description = "VPC name"
  type        = string 
}

# internet gateway
variable "InternetG_name" {
  description = "internet gateway GT"
  type        = string 
}

# Route table
variable "default_RT_cidr" {
  description = "default route table cidr block"
  type        = string
}

variable "ipv6_cidr_block" {
  description = "ipv6 cidr block"
  type        = string
}


# subnet
variable "public_subnet_cidr_block" {
  description = "Available cidr blocks for public subnets"
  type        = string
}
variable "available_zone" {
  description = "Available cidr blocks for public subnets"
  type        = string
}

variable "subnet_name1" {
  description = "subnet name"
  type        = string
}

variable "private_subnet_cidr_block" {
  description = "Available cidr blocks for private subnets"
  type        = string
}
variable "subnet_name2" {
  description = "subnet name2"
  type        = string
}

variable "private_ip" {
  description = "private ip add"
  type        = string
}

variable "my_ip_add" {
  description = "my ip add"
  type        = string
}

variable "instance_t" {
  description = "instances ec2"
  type        = string
}