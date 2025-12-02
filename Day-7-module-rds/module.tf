provider "aws" {
  region = "us-east-1" # ⚠️ Change if you are in ap-south-1 (Mumbai)
}

# --- 1. GET NETWORK INFO AUTOMATICALLY ---
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# --- 2. CALL THE MODULE ---
module "my_rds_module" {
  source = "./rds"

  # Pass Inputs
  env            = "practice-db"
  db_password    = "SuperSecret123!"
  
  # Pass Network Data Found Above
  vpc_id         = data.aws_vpc.default.id
  subnet_ids     = data.aws_subnets.default.ids
}

# --- 3. SHOW RESULT ---
output "connect_here" {
  value = module.my_rds_module.db_endpoint
}