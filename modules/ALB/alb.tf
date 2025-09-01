resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# configure ALB

resource "aws_lb" "jupiter_alb" {
  name = "jupiter-alb"
  load_balancer_type = "application"
  subnets = [var.public_subnet_ids.1, var.public_subnet_ids.2]
  
  internal = false
  security_groups = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false
}

# configure the target groups

resource "aws_lb_target_group" "jupiter_tg" {
  name = "jupiter-tg"
  target_type = "instance"
  vpc_id = var.vpc_id
  port = "80"
  protocol = "HTTP"

    health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301,302"
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}



#configure lsiteners
resource "aws_lb_listener" "alb_lb_listener" {
  load_balancer_arn = aws_lb.jupiter_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.jupiter_tg.arn
  }

}

resource "aws_lb_target_group_attachment" "tg_register" {
for_each = var.jupiter_instance

target_group_arn = aws_lb_target_group.jupiter_tg.arn
target_id = each.value
}