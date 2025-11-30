# VPC
variable "vpc_cidr" {
    type = string
    default = ""  
}
variable "vpc_name" {
    type = string
    default = ""
  
}

### public Subnet
variable "pub_sub_1_cidr" {
  type = string
  default = ""
}
variable "pub_sub_1_name" {
  type = string
  default = ""
}

### public Subnet
variable "pvt_sub_1_cidr" {
  type = string
  default = ""  
}
variable "pvt_sub_1_name" {
  type = string
  default = ""
  
}

#IGW 
variable "igw_name" {
  type = string
  default = ""
  
}

# Creation of route table and edit routes 
variable "default_route" {
  type = string
  default = ""
}
variable "route_table_name" {
  type = string
  default = ""
  
}

#SG
variable "sg_name" {
  type = string
  default = ""
}

variable "sg_tags_name" {
  type = string
  default = ""
}

variable "sg_cidr_allow" {
  type = string
  default = ""
}

# server creation
variable "ami_id" {
  type = string
  default = ""
}
variable "instance_type" {
  type = string
  default = "" 
}
variable "instance_name" {
  type = string
  default = ""
}