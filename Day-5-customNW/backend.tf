terraform {
  backend "s3" {
    bucket = "ravinarathod123"
    key = "day-5-sta/terraform.tfstatefile"
    region = "ap-south-1"
    
  }
}