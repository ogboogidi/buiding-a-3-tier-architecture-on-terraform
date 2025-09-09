variable "vpc_cidr_block" {
  type = string
}

variable "availability_zone" {
  type = list(string)
}

variable "public_subnet_cidr_block" {
  type = list(string)
}

variable "public_rtb_cidr_block" {
  type = string
}

variable "private_subnet_cidr_block" {
  type = list(string)
}

variable "db_private_subnet_cidr_block" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "username" {
  type = string
}

variable "engine_version" {
  type = string
}