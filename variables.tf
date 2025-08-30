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