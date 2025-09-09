variable "jupiter_db_subnet_group" {
  type = list(string)
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

variable "jupiter_bastion_host_sg" {
  type = string
}

variable "vpc_id" {
  type = string
}