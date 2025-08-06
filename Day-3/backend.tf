terraform {
  backend "s3" {
   bucket         = "ravinaratho123"
   key            = "terraform.tfstate"
  region         = "ap-south-1"

 }
}
