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

resource "aws_instance" "bastion-pgpcc-capston-infra" {
  ami                         =  data.aws_ami.centos7_ami.id
  key_name                    =  var.aws_key_name
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.bastion-sg.id]
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_id = var.subnet_id_for_bastion
  tags = {
    Name = "bastion-pgpcc-capston-infra-${var.aws_region}"
    Region = var.aws_region
    Stack = "PGPCC CAPSTON"
  }
}

resource "aws_security_group" "bastion-sg" {
  vpc_id = var.vpc_id
  name   = "bastion-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.source_address
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_eip" "bastion-eip" {
  instance = aws_instance.bastion-pgpcc-capston-infra.id
  vpc      = true
}