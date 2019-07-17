variable "aws_region" {}
variable "aws_key_name" {}
variable "vpc_id" {}
variable "subnet_id_for_apache_server" {}
variable "bastion-sg" {}

variable "profile" {
  default = "lab-user"
}