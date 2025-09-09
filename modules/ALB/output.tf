output "alb_dns_name" {
  value = aws_lb.jupiter_alb.dns_name
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "alb_zone_id" {
  value = aws_lb.jupiter_alb.zone_id
}