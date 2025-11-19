terraform {
  required_version = "~> 1.12.2"  #this allows if terrafrom version in local 1.12.2 only 
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "<= 4.0"  #if you want to upgrade the version change it here and run terraform init -upgrade so that lock will release allow to download specific version 
    }
  }
}


provider "aws" {
  # Configuration options
}