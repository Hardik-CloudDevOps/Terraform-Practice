module "git_lala" {
    source = "github.com/Hardik-CloudDevOps/Terraform-Practice/Day-7-modules-source"
    ami-id = "ami-08a6efd148b1f7504"
    instance-type = "t2.micro"
  
}