output "Apache_server_ip" {
  value = aws_instance.apache-server.private_ip
}

output "Apache_server_id" {
  value = aws_instance.apache-server.id
}