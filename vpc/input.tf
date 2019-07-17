variable "aws_region" {}
variable "vpc-cidr" {}
variable "ng_count" {
  default = "2"
}
variable "private_subnet_count" {
  default = "3"
}

variable "public_subnet_count" {
  default = "2"
}

variable "profile" {
  default = "lab-user"
}