variable "aws_region" {}
variable "aws_key_name" {}
variable "vpc_id" {}
variable "subnet_id_for_apache_server" {
  type = list
}
variable "bastion-sg" {}
variable "apache_server_count" {
}
variable "profile" {
  default = "lab-user"
}