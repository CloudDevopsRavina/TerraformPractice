variable "vpc_cidr" {
    description = "providing a cidr value to VPC"
    type = string
    default = ""
  
}

variable "subnet_cidr" {
     description = "providing a cidr value to subnet"
    type = string
    default = ""

}

variable "project_name" {
    description = "want to give tag for this project"
    type = string
    default = ""
  
}

variable "Destination_IGW_RT" {

    description = "destination traffic allow all 0.0.0.0/0"
    type = string
    default = ""

}