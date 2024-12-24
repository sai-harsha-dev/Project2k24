output "subnet_id" {
  value = aws_subnet.subnets.id
}

output "docker_host_sg_id" {
  value = aws_security_group.docker_host_sg.id
}