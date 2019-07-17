
module "vpc-us" {
  source     = "./vpc"
  aws_region = var.aws_regions.us
  vpc-cidr   = var.vpc_cidrs.us
}


module "eks-bastion-us" {
  source = "./bastion"
  aws_region = var.aws_regions.us
  aws_key_name = var.aws_key.us
  source_address = var.source_address
  vpc_id = module.vpc-us.vpc_id
  subnet_id_for_bastion = module.vpc-us.public_subnet_ids[0]


}


module "apache-server" {
  source = "./apache-server"
  aws_region = var.aws_regions.us
  aws_key_name = var.aws_key.us
  vpc_id = module.vpc-us.vpc_id
  subnet_id_for_apache_server = module.vpc-us.private_subnet_ids[0]
  bastion-sg=module.eks-bastion-us.bastion-sg
}


module "apache-lb" {
  source = "./apache-lb"
  apach_server_ip = module.apache-server.Apache_server_ip
  apache_instance_id = module.apache-server.Apache_server_id
  http_port = var.http_port
  lb-port = var.lb-port
  name_prefix = var.name_prefix
  public_subnets_in_vpc = module.vpc-us.public_subnet_ids
  vpc_id = module.vpc-us.vpc_id
}