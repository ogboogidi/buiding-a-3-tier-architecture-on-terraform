output "vpc_id" {
  value = aws_vpc.jupiter_main_vpc.id
}


output "public_subnet_ids" {
  value = {
   1 = aws_subnet.jupiter_public_subnet_01_az1a.id,
   2 = aws_subnet.jupiter_public_subnet_02_az1b.id
  }
}

output "availability_zones" {
  value = var.availability_zone
}