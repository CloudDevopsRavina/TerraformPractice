provider "aws" {
  
}

resource "aws_instance" "name" {
    ami = "ami-0f918f7e67a3323f0"
    instance_type = "t2.micro"
    tags = {
      Name = "day-a"
    }
  
}
#ami-0f918f7e67a3323f0  , ami-0d54604676873b4ec
