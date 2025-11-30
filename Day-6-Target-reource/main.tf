provider "aws" {
  
}
resource "aws_instance" "name" {
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.micro"  
    tags = {
        Name = "dev-test"
    }
}
resource "aws_s3_bucket" "name" {
    bucket = "radhagopinathbucket"

}
