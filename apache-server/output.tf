output "Apache_server_ips" {
  value = aws_instance.apache-server.*.private_ip
}

output "Apache_server_ids" {
  value = aws_instance.apache-server.*.id
}