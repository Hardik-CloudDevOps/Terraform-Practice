resource "aws_instance" "backend" {
  ami = "ami-0cae6d6fe6048ca2c"
  instance_type = "t2.medium"
  tags = {
    Name = "backend"
  }
}

resource "aws_instance" "frontend" {
    ami = "ami-0cae6d6fe6048ca2c"
    instance_type = "t2.medium"
    tags = {
        Name = "frontend"
    }  
}

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "myvpc"
    }
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "subnet1"
    }
  
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "subnet2"
  }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.name.id
    tags = {
        Name = "IGW"
    }
  
}
resource "aws_route_table" "pubrt" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
}


resource "aws_route_table_association" "name1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.pubrt.id
  
}

resource "aws_route_table_association" "name2" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_route_table.pubrt.id
  
}

resource "aws_security_group" "sg" {
    vpc_id = aws_vpc.name.id
    tags = {
        Name = "sg"
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

resource "aws_db_instance" "name1" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "devdb"
  username               = "admin"
  password               = "StrongPassw0rd!"
  skip_final_snapshot    = true
  publicly_accessible    = true
  backup_retention_period = 7  # Keep backups for 1 day (Minimum required for Replicas)
  apply_immediately       = true

  


  tags = {
    Name = "dev-rds"
  }
}