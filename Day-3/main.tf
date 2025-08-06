resource "aws_instance" "test" {
    ami = "ami-0f918f7e67a3323f0"
    instance_type = "t2.micro"
    iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "EC2WithRole"
  }
     #lifecycle {
    #create_before_destroy = true
  #}
  
}


#Creating a iam role for EC2

resource "aws_iam_role" "ec2_role" {
  name = "my-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
#to attach a IAM role to EC2 need to Create an Instance Profile for the Role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}

#Creating s3 bucket as want to push the .tfstate file for the secure
resource "aws_s3_bucket" "tf_state" {
  bucket = "ravinaratho123" # Must be globally unique
  force_destroy = true

  tags = {
    Name = "TerraformState"
    Environment = "Dev"
  }
}



