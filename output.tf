output "bastion_ip_us" {
  value = module.eks-bastion-us.bastion-ip
}

output "Apache_server_ip" {
  value = module.apache-server.Apache_server_ips
}

output "public_subnets" {
  value = module.vpc-us.public_subnet_ids
}

output "private_subnets" {
  value = module.vpc-us.private_subnet_ids
}

output "LB_DNS_NAME" {
  value = module.apache-lb.apache-elb
}