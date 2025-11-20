terraform {
  backend "s3" {
    bucket = "rajadhirajharikrushna"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
