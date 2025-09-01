output "aws_instance_ids" {
value = {for idx, instance in aws_instance.jupiter_server: idx => instance.id}
}

output "jupiter_instance" {
  value = {for idx, instance in aws_instance.jupiter_server: idx => instance.id}
}



# value = [for instance in aws_instance.jupiter_server : instance.id]