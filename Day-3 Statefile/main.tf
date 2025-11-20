resource "aws_instance" "dev" {
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t3.medium"
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    tags = {
      Name = "HARi"
    }

  
}