output "bastion-ip" {
  value = aws_eip.bastion-eip.public_ip
}

output "bastion-sg" {
  value = aws_security_group.bastion-sg.id
}

