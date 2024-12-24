resource "aws_vpc" "demo_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "subnets" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.0/20"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.demo_vpc.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "docker_vpc_rtb"
  }
}

resource "aws_main_route_table_association" "rtbasc"{
  vpc_id         = aws_vpc.demo_vpc.id
  route_table_id = aws_route_table.example.id
}

resource "aws_security_group" "docker_host_sg" {
  vpc_id = aws_vpc.demo_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "ssh_rule" {
  security_group_id = aws_security_group.docker_host_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "https_rule"{
  security_group_id = aws_security_group.docker_host_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "http_rule"{
  security_group_id = aws_security_group.docker_host_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}



