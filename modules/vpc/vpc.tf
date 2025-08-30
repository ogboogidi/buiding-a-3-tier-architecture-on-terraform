resource "aws_vpc" "jupiter_main_vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"


  tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-main-vpc"
    }
    )
}

# configure the internet gateway and attach to the vpc

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.jupiter_main_vpc.id

    tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
    }
    )
}

# configure a public subnet for AZ1a

resource "aws_subnet" "jupiter_public_subnet_01_az1a" {
  cidr_block = var.public_subnet_cidr_block[0]
  vpc_id = aws_vpc.jupiter_main_vpc.id
  availability_zone = var.availability_zone[0]
  map_public_ip_on_launch = true

    tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-subnet-01-az1a"
    }
    )

}


#configure public subnet for AZ1b

resource "aws_subnet" "jupiter_public_subnet_02_az1b" {
  cidr_block = var.public_subnet_cidr_block[1]
  vpc_id = aws_vpc.jupiter_main_vpc.id
  availability_zone = var.availability_zone[1]
  map_public_ip_on_launch = true

    tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-subnet-02-az1b"
    }
    )

}

# configure the public route table and associate it to the two public subnets

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.jupiter_main_vpc.id

  route {
    cidr_block = var.public_rtb_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-rtb"
    }
    )
}

resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.jupiter_public_subnet_01_az1a.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "b" {
  subnet_id = aws_subnet.jupiter_public_subnet_02_az1b.id
  route_table_id = aws_route_table.public_rtb.id
}


#configure private subnet for AZ1a

resource "aws_subnet" "jupiter_private_subnet_03_az1a" {
  cidr_block = var.private_subnet_cidr_block[0]
  vpc_id = aws_vpc.jupiter_main_vpc.id
  availability_zone = var.availability_zone[0]
  map_public_ip_on_launch = false

    tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-subnet-03-az1a"
    }
    )

}


#configure db subnet for AZ1a

resource "aws_subnet" "db_private_subnet_04_az1a" {
  cidr_block = var.db_private_subnet_cidr_block[0]
  vpc_id = aws_vpc.jupiter_main_vpc.id
  availability_zone = var.availability_zone[0]
  map_public_ip_on_launch = false

    tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-private-subnet-04-az1a"
    }
    )

}

#configure elastic IP for NAT gateway for AZ1a
resource "aws_eip" "eip_AZ1a" {
  domain   = "vpc"

  tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip-AZ1a"
    }
    )
}



# configure NAT Gateway for AZ1a

resource "aws_nat_gateway" "nat_gw_AZ1a" {
  subnet_id = aws_subnet.jupiter_public_subnet_01_az1a.id
  allocation_id = aws_eip.eip_AZ1a.id

  tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-NAT-gw-az1a"
    }
    )

  depends_on = [aws_eip.eip_AZ1a, aws_subnet.jupiter_public_subnet_01_az1a]

}

# configure the private route table for AZ1a

resource "aws_route_table" "private_rtb_AZ1a" {
  vpc_id = aws_vpc.jupiter_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_AZ1a.id
  }

  tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rtb-AZ1a"
    }
    )
  
  depends_on = [aws_eip.eip_AZ1a, aws_nat_gateway.nat_gw_AZ1a]
}

resource "aws_route_table_association" "c" {
  subnet_id = aws_subnet.jupiter_private_subnet_03_az1a.id
  route_table_id = aws_route_table.private_rtb_AZ1a.id
}

resource "aws_route_table_association" "d" {
  subnet_id = aws_subnet.db_private_subnet_04_az1a.id
  route_table_id = aws_route_table.private_rtb_AZ1a.id
}



#configure private subnet for AZ1b

resource "aws_subnet" "jupiter_private_subnet_05_az1b" {
  cidr_block = var.private_subnet_cidr_block[1]
  vpc_id = aws_vpc.jupiter_main_vpc.id
  availability_zone = var.availability_zone[1]
  map_public_ip_on_launch = false

    tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-subnet-05-az1b"
    }
    )

}

#configure database subnet for AZ1b

resource "aws_subnet" "db_private_subnet_06_az1b" {
  cidr_block = var.db_private_subnet_cidr_block[1]
  vpc_id = aws_vpc.jupiter_main_vpc.id
  availability_zone = var.availability_zone[1]
  map_public_ip_on_launch = false

    tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-private-subnet-06-az1b"
    }
    )

}

#configure elastic IP for NAT gateway for AZ1b
resource "aws_eip" "eip_AZ1b" {
  domain   = "vpc"

  tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip-AZ1b"
    }
    )
}



# configure NAT Gateway for AZ1b

resource "aws_nat_gateway" "nat_gw_AZ1b" {
  subnet_id = aws_subnet.jupiter_public_subnet_02_az1b.id
  allocation_id = aws_eip.eip_AZ1b.id

  tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-NAT-gw-az1b"
    }
    )

  depends_on = [aws_eip.eip_AZ1b, aws_subnet.jupiter_public_subnet_02_az1b]

}

# configure the private route table for AZ1a

resource "aws_route_table" "private_rtb_AZ1b" {
  vpc_id = aws_vpc.jupiter_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_AZ1b.id
  }

  tags = merge(
    var.tags,
    {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rtb-AZ1b"
    }
    )
  
  depends_on = [aws_eip.eip_AZ1b, aws_nat_gateway.nat_gw_AZ1b]
}

resource "aws_route_table_association" "e" {
  subnet_id = aws_subnet.jupiter_private_subnet_05_az1b.id
  route_table_id = aws_route_table.private_rtb_AZ1b.id
}

resource "aws_route_table_association" "f" {
  subnet_id = aws_subnet.db_private_subnet_06_az1b.id
  route_table_id = aws_route_table.private_rtb_AZ1b.id
}