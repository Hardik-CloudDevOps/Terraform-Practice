terraform {
  backend "s3" {
    bucket = "rajadhirajharikrushna"
    key    = "day-4/terraform.tfstate" # so here im using same day-4 statefile path for day-5 so in this case system can delete day-4 resources and created day-5 folder insdie resources so this is not recomnded user different psthd fpr diff statefiles
    region = "us-east-1"
    use_lockfile = true #s3 supports this feature but teraaform version > 1.10, latest version >=1.10
    #dynamodb_table = "nareshit"  #any version 
    encrypt = true
  }
}