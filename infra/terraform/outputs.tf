output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.devops_lab_vpc.id
}

output "subnet_id" {
  description = "ID da Sub-rede criada"
  value       = aws_subnet.devops_lab_subnet.id
}

output "security_group_id" {
  description = "ID do Security Group criado"
  value       = aws_security_group.devops_lab_sg.id
}
