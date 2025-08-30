resource "aws_security_group" "jupiter_server_sg" {
  name        = "jupiter_server_sg"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.jupiter_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.jupiter_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Amazon-owned AMIs
}

resource "aws_instance" "jupiter_server" {
  
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.jupiter_server_sg.id]
  user_data = var.user_data


  for_each  = toset(

    var.public_subnet_ids[*]
  )

  subnet_id = each.value

}