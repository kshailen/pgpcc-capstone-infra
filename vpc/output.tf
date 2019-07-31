output "vpc_id" {
  value = aws_vpc.pgpcc-capston-infra.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet_cidrs" {
  value = aws_subnet.private_subnets.*.cidr_block
}