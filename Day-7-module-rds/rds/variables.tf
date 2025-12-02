variable "env" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the DB goes"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets for the DB"
  type        = list(string)
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Instance size"
  type        = string
  default     = "db.t3.micro"
}