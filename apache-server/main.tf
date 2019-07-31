#
# VPC Resources

provider "aws" {
  region = var.aws_region
  profile =   var.profile
  version = "~> 2.19"
}
data "aws_availability_zones" "available" {}

//obtain the ami
data "aws_ami" "centos7_ami" {
  most_recent = true
  filter {
    name = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
  filter {
    name = "creation-date"
    values = ["2019-01-30*"]
  }
  owners = ["aws-marketplace"]
  // https://wiki.centos.org/Cloud/+AWS
}

# Get the AWS Ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "apache-server" {
  count = var.apache_server_count
  ami                         =  data.aws_ami.centos7_ami.id
  key_name                    =  var.aws_key_name
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.apache-server-sg.id]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  subnet_id = element(var.subnet_id_for_apache_server, count.index)
  tags = {
    Name = "apache-pgpcc-capston-infra-${var.aws_region}"
    Region = var.aws_region
    Stack = "PGPCC CAPSTON"
  }

  user_data = "${file("apache-server/install-apache.sh")}"
}

resource "aws_security_group" "apache-server-sg" {
  vpc_id = var.vpc_id
  name   = "apache-server-sg"

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ssh_from_bastion" {
  from_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.apache-server-sg.id
  source_security_group_id = var.bastion-sg
  to_port = 22
  type = "ingress"
}

resource "aws_security_group_rule" "accesswebserver_open_to_all" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.apache-server-sg.id
  to_port = 80
  type = "ingress"
}