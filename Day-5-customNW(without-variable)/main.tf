# Creation of VPC
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc" #✅ Capital N
  }
}

# Creation of subnets

   ### public subnet ###   (attach to IGW)
resource "aws_subnet" "dev-subnet1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "dev-subnet-1"
    }
}

    ### private subnet ### 

resource "aws_subnet" "dev-subnet2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24" 
    tags = {
      Name = "dev-subnet-2"
    }
}

# Creation IG and attach to vpc

resource "aws_internet_gateway" "dev-igw" {
    vpc_id = aws_vpc.name.id
    tags = {
        Name = "dev-igw"
    }
}

# Creation of route table and edit routes 
resource "aws_route_table" "dev-rt" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev-igw.id
    }
}

# Creation of subnet associations 
resource "aws_route_table_association" "dev_rt_assoc1" {
    subnet_id = aws_subnet.dev-subnet1.id
    route_table_id = aws_route_table.dev-rt.id
}

# Creation Security Group
resource "aws_security_group" "dev-sg" {
    name = "allow_tls" 
    vpc_id = aws_vpc.name.id
    tags = {
        Name = "dev-sg"
    }
    ingress {
        description = "HTTP"
        from_port = 80
        to_port   = 80
        protocol  = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
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
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.micro" 
    subnet_id = aws_subnet.dev-subnet1.id
    vpc_security_group_ids = [aws_security_group.dev-sg.id] 
    tags = {
      Name = "dev-server"
    }
}
