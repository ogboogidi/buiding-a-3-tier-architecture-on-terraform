variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = map(string)
}

variable "jupiter_instance" {
  type = map(string)
}


