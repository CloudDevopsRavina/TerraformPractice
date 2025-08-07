terraform {
  backend "s3" {
   bucket         = "ravinarathod123"
   key            = "day-4/terraform.tfstate"
  region         = "ap-south-1"

 }
}
