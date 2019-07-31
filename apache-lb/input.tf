variable "name_prefix" {}
variable "vpc_id" {}
variable "lb-port" {}
variable "private_subnet_cidrs" {}
variable "public_subnets_in_vpc" {}
variable "http_port" {}
variable "apache_instance_ids" {
  type = list
}

variable "apache_server_count" {}