resource "aws_db_subnet_group" "jupiter_db_subnet_group" {
  name = "jupiter-db-subnet-group"
  subnet_ids = var.jupiter_db_subnet_group[*]
}

#create security group for Database

resource "aws_security_group" "jupiter_db_sg" {
  name = "jupiter-db-sg"
  vpc_id = var.vpc_id
  description = "Allow SQL traffic over tcp on port 3306 from the bastion Host and allow all outboun traffic"

  tags = {
    Name = "jupiter-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_from_the_Bastion_Host"{
  security_group_id = aws_security_group.jupiter_db_sg.id
  description = "Allow sql traffic from Bastion Host"
  referenced_security_group_id = var.jupiter_bastion_host_sg
  from_port = 3306
  ip_protocol = "tcp"
  to_port = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_sql_traffic" {
  security_group_id = aws_security_group.jupiter_db_sg.id
  description = "allow all outbound traffic"
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}


data "aws_secretsmanager_secret" "jupiter_db_password" {
  name = "jupiter/database/password"
}

data "aws_secretsmanager_secret_version" "jupiter_db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.jupiter_db_password.id
}

resource "aws_db_instance" "jupiter_db" {
  db_name = "jupiterdb"
  allocated_storage = 10
  engine = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class
  username = var.username
  password = jsondecode(data.aws_secretsmanager_secret_version.jupiter_db_secret_version.secret_string)["dbpassword"]
  db_subnet_group_name = aws_db_subnet_group.jupiter_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.jupiter_db_sg.id]
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = true

  tags = {
    Name = "jupiter-db"
  }

}

