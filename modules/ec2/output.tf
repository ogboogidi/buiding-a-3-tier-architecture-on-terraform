output "aws_instance_ids" {
value = [for instance in aws_instance.jupiter_server : instance.id]
}

output "jupiter_instance" {
  value = aws_instance.jupiter_server[*]
}



# value = [for instance in aws_instance.jupiter_server : instance.id]