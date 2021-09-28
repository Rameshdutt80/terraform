provider "aws" {
  access_key = "${var.accesskey}"
  secret_key = "${var.secretkey}"
  region     = "${var.region}"
}

# Create a web server
resource "aws_instance" "web" {
  ami             = "${var.imgid}"
  instance_type   = "${var.instancetype}"
  key_name        = "${var.keyname}"
  security_groups = "${var.securitygroups}"

  tags {
    Name = "Nginx-prac"
  }

  connection {
    user        = "ubuntu"
    private_key = "${file(var.privatekeypath)}"
  }

  provisioner "file" {
    inline = ["sudo yum install nginx -y", "sudo service nginx start"]
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpcid}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
