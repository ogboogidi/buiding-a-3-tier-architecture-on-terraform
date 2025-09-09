variable "vpc_id" {
    type = string
}


variable "public_subnet_ids" {
  type = map(string)
}

variable "alb_sg" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "private_server_subnets_id" {
  type = map(string)
}

variable "key_name" {
  type = string
}