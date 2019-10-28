/*
  Requires:
  - AWS Region
  - CIDR block with <= 28 bit prefix length

  Provisions:
  - VPC,
  - iGW,
  - public route table,
  - 2 subnets in different availability zones,
  - security group for the Viptela controllers
*/

/*
  Gather Availability Zone Information
*/
data "aws_availability_zones" "available" {
  state = "available"
}

/*
  VPC
*/
resource "aws_vpc" "viptela" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true

  tags = {
    Name = "Viptela Controllers"
  }
}

/*
  Internet Gateway
*/
resource "aws_internet_gateway" "viptela" {
  vpc_id = "${aws_vpc.viptela.id}"

  tags = {
    Name = "Viptela Controllers"
  }
}

/*
  Public Subnets
*/
resource "aws_subnet" "public_subnet_az_1" {
  vpc_id            = "${aws_vpc.viptela.id}"
  cidr_block        = cidrsubnet("${var.cidr_block}", 1, 0)
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "subnet_public_az_1"
    VPC  = "${data.aws_availability_zones.available.names[0]}_viptela"
  }
}

resource "aws_subnet" "public_subnet_az_2" {
  vpc_id            = "${aws_vpc.viptela.id}"
  cidr_block        = cidrsubnet("${var.cidr_block}", 1, 1)
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "subnet_public_az_2"
    VPC  = "${data.aws_availability_zones.available.names[1]}_viptela"
  }
}

/*
  Public Route Table
*/
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.viptela.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.viptela.id}"
  }

  tags = {
    Name = "Public Subnets"
    VPC  = "Viptela_Public_RT"
  }
}

/*
  Public Route Table Associations
*/
resource "aws_route_table_association" "subnet_p1_to_rt_public" {
  subnet_id      = "${aws_subnet.public_subnet_az_1.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "subnet_p2_to_rt_public" {
  subnet_id      = "${aws_subnet.public_subnet_az_2.id}"
  route_table_id = "${aws_route_table.public.id}"
}

/*
  Security Groups
*/
resource "aws_security_group" "Vipela_Control_Plane" {
  name        = "Vipela_Control_Plane"
  description = "Allow Viptela Control Plane and Management Traffic"

  ingress {
    from_port   = 23456
    to_port     = 24156
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 12346
    to_port     = 13046
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 830
    to_port     = 830
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.viptela.id}"

  tags = {
    Name = "Viptela Control and Management"
  }
}
