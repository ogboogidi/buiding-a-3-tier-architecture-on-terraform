resource "aws_security_group" "jupiter_server_sg" {
  name        = "jupiter_server_sg"
  description = "Allow http and ssh inbound traffic from the alb and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.jupiter_server_sg.id
  referenced_security_group_id = var.alb_sg
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.jupiter_server_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.jupiter_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# data "aws_ami" "amazon_linux" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["amazon"] # Amazon-owned AMIs
# }

resource "aws_instance" "jupiter_server" {
  
  ami = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.jupiter_server_sg.id]
  associate_public_ip_address = true
  user_data_base64 = base64encode(file("scripts/jupiter_app.sh"))

  for_each  = var.public_subnet_ids

  subnet_id = each.value

}

# aws_instance.jupiter_server