variable "aws_regions" {
  type = "map"
  default = {
    apac = "ap-northeast-1",
    emea = "eu-west-1",
    us = "us-east-1"
  }
}

variable "vpc_cidrs" {
  type = "map"
  default = {
    us = "10.0.0.0/16",
    emea = "10.1.0.0/16",
    apac =   "10.2.0.0/16"
  }
}

variable "source_address" {
  default = ["0.0.0.0/0"]
}


variable "aws_key" {
  type = "map"
  default = {
    apac = "pgpcc_capston-ap",
    emea = "pgpcc_capston-eu",
    us = "pgpcc_capston-us"
  }
}

variable "profile" {
  default = "lab-user"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "http_port" {
  default =   "80"
}


variable "lb-port" {
  default =   "80"
}

variable "name_prefix" {
  default = "pgpcc-capston"
}