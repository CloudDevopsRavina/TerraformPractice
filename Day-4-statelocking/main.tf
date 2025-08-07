resource "aws_instance" "name" {
    ami = "ami-0f918f7e67a3323f0"
    instance_type = "t2.nano"
    tags = {
      Name = "lokingtrying"
    }
  
}