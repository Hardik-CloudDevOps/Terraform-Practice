resource "aws_instance" "name" {
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.nano"
    availability_zone = "us-east-1b"
    tags = {
        Name = "dev"
    }

lifecycle {
    #prevent_destroy = true
    #create_before_destroy = true
    ignore_changes = [ tags,]

}
}