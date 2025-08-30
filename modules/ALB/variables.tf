variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "aws_instance_ids" {
  type = list(string)
}

