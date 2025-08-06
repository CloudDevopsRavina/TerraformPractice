#output "instance_details_of_my_ec2" {
 # value = {
  #  instance_id = aws_instance.my_ec2.id
   # private_ip  = aws_instance.my_ec2.private_ip
   # public_ip = aws_instance.my_ec2.public_ip
  #}
    
#}

output "instance_details_of_test" {
  value = {
    instance_id = aws_instance.test.id
    private_ip  = aws_instance.test.private_ip
    public_ip = aws_instance.test.public_ip
  }
    
}

