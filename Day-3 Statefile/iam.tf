resource "aws_iam_role" "ec2_role" {
  name = "ec2-full-s3-access-role"

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

# Attach AmazonS3FullAccess
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Instance profile (needed for EC2)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-fullaccess-profile"
  role = aws_iam_role.ec2_role.name
}
