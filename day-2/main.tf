resource "aws_instance" "testing" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
      Name = "terraformec2"
    }
  
}