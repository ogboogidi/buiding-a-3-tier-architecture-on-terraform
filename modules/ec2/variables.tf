variable "vpc_id" {
    type = string
}


variable "public_subnet_ids" {
  type = map(string)
}

variable "alb_sg" {
  type = string
}