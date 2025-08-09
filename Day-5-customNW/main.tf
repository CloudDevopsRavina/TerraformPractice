#Creation of VPC
resource "aws_vpc" "custm_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
      Name = var.project_name
    }
  
}

#Creation of subnet for public

resource "aws_subnet" "cust_public_subnet" {
    vpc_id = aws_vpc.custm_vpc.id
    cidr_block = var.subnet_cidr
    map_public_ip_on_launch = true
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

#creation of subnet association 
resource "aws_route_table_association" "cust_RT_igw_subnet_assc" {
  
  subnet_id = aws_subnet.cust_public_subnet.id
  route_table_id = aws_route_table.cust_rt.id
}

#creation of SG
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  vpc_id      = aws_vpc.custm_vpc.id
  tags = {
    Name = var.project_name
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
}
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" #all protocols 
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
}

#creation of private subnet

resource "aws_subnet" "cust_private_subnet" {
    vpc_id = aws_vpc.custm_vpc.id
    cidr_block = var.subnet_cider_private
    #map_public_ip_on_launch = true
    tags = {
      Name = var.project_name
    }
  
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = var.project_name
  }
}

#Creation of nat gateway

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.cust_public_subnet.id
  tags = {
    Name = var.project_name
  }
}

# Private Route Table (using NAT Gateway)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.custm_vpc.id
  route {
    cidr_block     = var.Destination_NAT_RT
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = var.project_name
  }
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.cust_private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}






