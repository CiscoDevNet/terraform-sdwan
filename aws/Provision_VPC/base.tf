/*
  Requires:
  - AWS Region
  - CIDR block with <= 27 bit prefix length

  Provisions:
  - VPC,
  - iGW,
  - public route table,
  - 4 subnets in 2 different availability zones,
  - security group for the SD-WAN controllers
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
resource "aws_vpc" "sdwan_cp" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      Name = "SD-WAN CP"
    }
  )
}

/*
  Internet Gateway
*/
resource "aws_internet_gateway" "sdwan_cp" {
  vpc_id = "${aws_vpc.sdwan_cp.id}"

  tags = merge(
    var.common_tags,
    {
      Name = "SD-WAN CP"
    }
  )
}

/*
  Public Subnets
*/
resource "aws_subnet" "mgmt_subnet_az_1" {
  vpc_id            = "${aws_vpc.sdwan_cp.id}"
  cidr_block        = cidrsubnet("${var.cidr_block}", 2, 0)
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = merge(
    var.common_tags,
    {
      Name = "subnet_mgmt_az_1"
      VPC  = "SD-WAN CP"
    }
  )
}

resource "aws_subnet" "mgmt_subnet_az_2" {
  vpc_id            = "${aws_vpc.sdwan_cp.id}"
  cidr_block        = cidrsubnet("${var.cidr_block}", 2, 2)
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = merge(
    var.common_tags,
    {
      Name = "subnet_mgmt_az_2"
      VPC  = "SD-WAN CP"
    }
  )
}

resource "aws_subnet" "public_subnet_az_1" {
  vpc_id            = "${aws_vpc.sdwan_cp.id}"
  cidr_block        = cidrsubnet("${var.cidr_block}", 2, 1)
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = merge(
    var.common_tags,
    {
      Name = "subnet_public_az_1"
      VPC  = "SD-WAN CP"
    }
  )
}

resource "aws_subnet" "public_subnet_az_2" {
  vpc_id            = "${aws_vpc.sdwan_cp.id}"
  cidr_block        = cidrsubnet("${var.cidr_block}", 2, 3)
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = merge(
    var.common_tags,
    {
      Name = "subnet_public_az_2"
      VPC  = "SD-WAN CP"
    }
  )
}

/*
  Route Tables
*/
resource "aws_route_table" "mgmt" {
  vpc_id = "${aws_vpc.sdwan_cp.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.sdwan_cp.id}"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "SD-WAN CP (mgmt)"
      VPC  = "SD-WAN CP"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.sdwan_cp.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.sdwan_cp.id}"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "SD-WAN CP"
      VPC  = "SD-WAN CP"
    }
  )
}

/*
  Route Table Associations
*/
resource "aws_route_table_association" "subnet_m1_to_rt_public" {
  subnet_id      = "${aws_subnet.mgmt_subnet_az_1.id}"
  route_table_id = "${aws_route_table.mgmt.id}"
}

resource "aws_route_table_association" "subnet_m2_to_rt_public" {
  subnet_id      = "${aws_subnet.mgmt_subnet_az_2.id}"
  route_table_id = "${aws_route_table.mgmt.id}"
}

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
resource "aws_security_group" "sdwan_cp" {
  name        = "SD-WAN CP"
  description = "Allow SD-WAN CP and Management Traffic"

  ingress {
    from_port        = 23456
    to_port          = 24156
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 12346
    to_port          = 13046
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = "${var.acl_cidr_blocks}"
    ipv6_cidr_blocks = "${var.acl6_cidr_blocks}"
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = "${var.acl_cidr_blocks}"
    ipv6_cidr_blocks = "${var.acl6_cidr_blocks}"
  }

  ingress {
    from_port        = 8443
    to_port          = 8443
    protocol         = "tcp"
    cidr_blocks      = "${var.acl_cidr_blocks}"
    ipv6_cidr_blocks = "${var.acl6_cidr_blocks}"
  }

  ingress {
    from_port        = 830
    to_port          = 830
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  vpc_id = "${aws_vpc.sdwan_cp.id}"

  tags = merge(
    var.common_tags,
    {
      Name = "SD-WAN CP"
    }
  )
}

/*
  vBond Elastic IP
*/
resource "aws_eip" "vbond_public" {
  vpc               = true
  tags = merge(
    var.common_tags,
    {
      Name  = "eip_vbond"
    }
  )
}
