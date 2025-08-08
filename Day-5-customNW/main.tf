#Creation of VPC
resource "aws_vpc" "custm_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
      Name = var.project_name
    }
  
}

#Creation of subnet

resource "aws_subnet" "cust_subnet" {
    vpc_id = aws_vpc.custm_vpc.id
    cidr_block = var.subnet_cidr
    tags = {
      Name = var.project_name
    }
  
}

#creation of IGW and attach it to VPC
resource "aws_internet_gateway" "cust_igw" {
    vpc_id = aws_vpc.custm_vpc.id
    tags = {
      Name = var.project_name
    }
  
}

#creation of Route tables and edit route and add IGW
resource "aws_route_table" "cust_rt" {
    vpc_id = aws_vpc.custm_vpc.id
    tags = {
      Name = var.project_name
    }
    route  {
        cidr_block = var.Destination_IGW_RT
        gateway_id = aws_internet_gateway.cust_igw.id
    }
  
}






