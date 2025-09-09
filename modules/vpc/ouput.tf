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

output "private_server_subnets_id" {
  value = {
    1 = aws_subnet.jupiter_private_subnet_03_az1a.id, 
    2 = aws_subnet.jupiter_private_subnet_05_az1b.id
  }
}

output "jupiter_db_subnet_group" {
  value = [
  aws_subnet.db_private_subnet_04_az1a.id,
  aws_subnet.db_private_subnet_06_az1b.id
  ]
}