# Provider Configuration
#
provider "http" {
  version = "~> 1.1"
}

provider "aws" {
  profile =   var.profile
  region =  var.aws_region
  version = "~> 2.19"
}