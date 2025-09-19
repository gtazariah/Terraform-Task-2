output "india-region" {
  value=aws_instance.india.public_ip
  description = "India Region nginx server public ip"
}

output "america-region" {
    value = aws_instance.america.public_ip
    description = "America region nginx server public ip"
}