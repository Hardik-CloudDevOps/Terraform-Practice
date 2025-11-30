# Creation of VPC
resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name #✅ Capital N
  }
}

# Creation of subnets

   ### public subnet ###   (attach to IGW)
resource "aws_subnet" "dev-subnet1" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.pub_sub_1_cidr
    tags = {
      Name = var.pub_sub_1_name
    }
}

    ### private subnet ### 

resource "aws_subnet" "dev-subnet2" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.pvt_sub_1_cidr
    tags = {
      Name = var.pvt_sub_1_name
    }
}

# Creation IG and attach to vpc

resource "aws_internet_gateway" "dev-igw" {
    vpc_id = aws_vpc.name.id
    tags = {
        Name = "dev-igw"
    }
}
#Creation of NAT gateway and attach to Private subnet
resource "aws_eip" "nat-eip" {
  tags = {
    Name = "nat-eip"
  }
}
resource "aws_nat_gateway" "dev-nat" {
    subnet_id = aws_subnet.dev-subnet2.id
    allocation_id = aws_eip.nat-eip.id
    tags = {
      Name = "dev-nat"
    }

}
# Creation of private route table and edit routes 
resource "aws_route_table" "dev-pvt-rt" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = var.default_route
        nat_gateway_id = aws_nat_gateway.dev-nat.id
    }
    tags = {
        Name = "dev-pvt-rt"
    }    
}

# Creation of subnet associations  for public rt
resource "aws_route_table_association" "dev_rt_assoc2" {
    subnet_id = aws_subnet.dev-subnet2.id
    route_table_id = aws_route_table.dev-pvt-rt.id
  
}

# Creation of public route table and edit routes 
resource "aws_route_table" "dev-rt" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = var.default_route
        gateway_id = aws_internet_gateway.dev-igw.id
    }
        tags = {
        Name = var.route_table_name
    }
}

# Creation of subnet associations  for public rt
resource "aws_route_table_association" "dev_rt_assoc1" {
    subnet_id = aws_subnet.dev-subnet1.id
    route_table_id = aws_route_table.dev-rt.id
    
}

# Creation Security Group
resource "aws_security_group" "dev-sg" {
    name = var.sg_name
    vpc_id = aws_vpc.name.id
    tags = {
        Name = var.sg_tags_name
    }
    ingress {
        description = "HTTP"
        from_port = 80
        to_port   = 80
        protocol  = "TCP"
        cidr_blocks = [var.sg_cidr_allow]
    }
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol = "TCP"
        cidr_blocks = [var.sg_cidr_allow]
    }
    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = [var.sg_cidr_allow]
    }
    egress {
        from_port = 0
        to_port   = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Creation of server
resource "aws_instance" "dev-server" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.dev-subnet1.id
    vpc_security_group_ids = [aws_security_group.dev-sg.id] 
    tags = {
      Name = var.instance_name
    }
}
