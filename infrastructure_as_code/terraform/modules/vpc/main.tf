resource "aws_vpc" "main_vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MainVPC"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "MainIGW"
  }
}

resource "aws_subnet" "prod_subnet_private_a" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "192.168.25.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ProductionSubnetPrivateA"
  }
}

resource "aws_subnet" "prod_subnet_private_b" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "192.168.50.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "ProductionSubnetPrivateB"
  }
}

resource "aws_subnet" "prod_subnet_public_a" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "192.168.75.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ProductionSubnetPublicA"
  }
}

resource "aws_subnet" "prod_subnet_public_b" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "192.168.100.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "ProductionSubnetPublicB"
  }
}

resource "aws_eip" "public_ip_nat" {
  vpc      = true
}

resource "aws_nat_gateway" "prod_nat" {
  allocation_id = aws_eip.public_ip_nat.id
  subnet_id     = aws_subnet.prod_subnet_public_a.id

  tags = {
    Name = "ProductionNAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gw]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "PublicProductionRouteTable"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.prod_nat.id
  }

  tags = {
    Name = "PrivateProductionRouteTable"
  }
}


resource "aws_route_table_association" "public_route_table_association_a" {
  subnet_id      = aws_subnet.prod_subnet_public_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_b" {
  subnet_id      = aws_subnet.prod_subnet_public_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_a" {
  subnet_id      = aws_subnet.prod_subnet_private_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_b" {
  subnet_id      = aws_subnet.prod_subnet_private_b.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "allow_incoming_http_https" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "HTTPS from ANY"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from ANY"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_incoming_http_https"
  }
}