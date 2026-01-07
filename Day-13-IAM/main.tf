# Create an IAM User
resource "aws_iam_user" "example_user" {
  name = "terraform-admin-user"
}

# Create an IAM Role with a Trust Policy
resource "aws_iam_role" "example_role" {
  name = "ec2_s3_access_role"

  # Trust policy: Allows the EC2 service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


# Attach a Read-Only S3 policy to the Role
resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.example_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Attaching a Role to an EC2 Instance

# Create the Instance Profile
resource "aws_iam_instance_profile" "example_profile" {
  name = "ec2_profile_for_s3"
  role = aws_iam_role.example_role.name
}

# Use the Profile in the EC2 Resource
resource "aws_instance" "web_server" {
  ami                  = "ami-0c55b159cbfafe1f0"
  instance_type        = "t2.micro"
  
  # Attach the profile here
  iam_instance_profile = aws_iam_instance_profile.example_profile.name

  tags = {
    Name = "IAM-Authorized-Instance"
  }
}

