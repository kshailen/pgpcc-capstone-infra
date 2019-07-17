variable "aws_region" {}
variable "aws_key_name" {}
variable "source_address" {}
variable "vpc_id" {}
variable "subnet_id_for_bastion" {}

variable "profile" {
  default = "lab-user"
}