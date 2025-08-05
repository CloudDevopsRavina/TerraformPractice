output "private_ip" {
    value = aws_instance.testing.private_ip
  
}
output "public_ip" {
    value = aws_instance.testing.public_ip
  
}
output "instance_id" {
  value = aws_instance.testing.subnet_id
}