# 1. Create Subnet Group
resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "${var.env}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = { Name = "${var.env}-subnet-group" }
}

# 2. Create Security Group
resource "aws_security_group" "my_sg" {
  name   = "${var.env}-rds-sg"
  vpc_id = var.vpc_id

  # Allow MySQL Port 3306
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ Open to world (Good for practice)
  }

  tags = { Name = "${var.env}-rds-sg" }
}

# 3. Create RDS Instance
resource "aws_db_instance" "my_db" {
  identifier        = "${var.env}-db"
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.instance_class
  username          = "admin"
  password          = var.db_password
  
  # ✅ LINKING INTERNAL RESOURCES
  db_subnet_group_name   = aws_db_subnet_group.my_subnet_group.name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  skip_final_snapshot = true
  publicly_accessible = true
}