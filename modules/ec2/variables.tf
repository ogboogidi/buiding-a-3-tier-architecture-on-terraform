variable "vpc_id" {
    type = string
}

variable "user_data" {
  type = string
}



variable "public_subnet_ids" {
  type = list(string)
}