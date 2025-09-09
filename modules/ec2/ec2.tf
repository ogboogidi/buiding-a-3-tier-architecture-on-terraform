resource "aws_security_group" "jupiter_server_sg" {
  name        = "jupiter_server_sg"
  description = "Allow http and ssh inbound traffic from the alb and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "jupiter_server_sg"
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
  key_name = var.key_name
  ami = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.jupiter_server_sg.id]
  associate_public_ip_address = true
  user_data_base64 = base64encode(file("scripts/jupiter_app.sh"))

  for_each  = var.public_subnet_ids

  subnet_id = each.value

  tags = {
    Name = "jupiter_servers"
  }
}


#create secuirty groups for bastion host server

resource "aws_security_group" "jupiter_bastion_host_sg" {
  name = "jupiter-bastion-host-sg"
  description = "allow SSH ingress from anywhere and allow all egress traffic"
  vpc_id = var.vpc_id

    tags = {
    Name = "jupiter_bastion_host_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH" {
  security_group_id = aws_security_group.jupiter_bastion_host_sg.id
  description = "Allow SSH traffic from anywhere"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.jupiter_bastion_host_sg.id
  description = "allow all outbound traffic"
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

#create secuity group for private servers

resource "aws_security_group" "jupiter_private_servers_sg" {
  name = "jupiter-private-servers-sg"
  description = "allow SSH ingress from any Bastion Host here and allow all egress traffic"
  vpc_id = var.vpc_id

  tags = {
    Name = "jupiter_private_servers_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_from_Bastion"{
  security_group_id = aws_security_group.jupiter_private_servers_sg.id
  description = "Allow SSH traffic from Bastion Host"
  referenced_security_group_id = aws_security_group.jupiter_bastion_host_sg.id
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic" {
  security_group_id = aws_security_group.jupiter_private_servers_sg.id
  description = "allow all outbound traffic"
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}





#create bastion host server

resource "aws_instance" "jupiter_bastion_host_server" {
  ami = var.ami_id
  instance_type = var.instance_type  
  key_name = var.key_name
  associate_public_ip_address = true
  subnet_id = var.public_subnet_ids.1
  security_groups = [aws_security_group.jupiter_bastion_host_sg.id]


  tags = {
    Name = "jupiter_bastion_host_server"
  }
}

#create private server for AZ1a and AZ1b

resource "aws_instance" "jupiter_private_servers" {
  ami = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.jupiter_private_servers_sg.id]
  associate_public_ip_address = false
  key_name = var.key_name
  for_each = var.private_server_subnets_id
  subnet_id = each.value

   tags = {
    Name = "jupiter_private_servers"
  }
}

