resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    tags = {
      Name = "dev"
    }
  
}

#first need to create empty resouse, then run the terrofrom import commaand, and then add the details of that instance from state file

#terraform import aws_instance.name i-0bf01838bc9e3c993  chnage instance id that already exit 

# resource "aws_s3_bucket" "name" {
#     bucket = "testdevproddnareh"
  
# }
#terraform import aws_s3_bucket.name testdevproddnareh  here change bucket name that already exist

#iam user import
resource "aws_iam_user" "name" {
    name = "radha"
}
