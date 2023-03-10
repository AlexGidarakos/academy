# Define the main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = local.vpc_name
  }
}

# Define public subnet A
resource "aws_subnet" "pub_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.sn_pub_a_cidr
  map_public_ip_on_launch = true
  availability_zone       = local.sn_pub_a_az

  tags = {
    Name = local.sn_pub_a_name
  }
}

# Define public subnet B
resource "aws_subnet" "pub_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.sn_pub_b_cidr
  map_public_ip_on_launch = true
  availability_zone       = local.sn_pub_b_az

  tags = {
    Name = local.sn_pub_b_name
  }
}

# Define private subnet A
resource "aws_subnet" "priv_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.sn_priv_a_cidr
  availability_zone = local.sn_priv_a_az

  tags = {
    Name = local.sn_priv_a_name
  }
}

# Define private subnet B
resource "aws_subnet" "priv_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.sn_priv_b_cidr
  availability_zone = local.sn_priv_b_az

  tags = {
    Name = local.sn_priv_b_name
  }
}

# Define an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = local.igw_name
  }
}

# Define an Elastic IP to be used for the NAT Gateway
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = local.eip_name
  }
}

# Define a NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub_b.id

  tags = {
    Name = local.nat_name
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# Define a route table for the public subnets
resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.rtb_pub_route_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = local.rtb_pub_name
  }
}

# Define a route table for the private subnets
resource "aws_route_table" "priv" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = var.rtb_priv_route_cidr
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = local.rtb_priv_name
  }
}

# Define assocations between route tables and subnets
resource "aws_route_table_association" "rtb_assoc_pub_pub_a" {
  route_table_id = aws_route_table.pub.id
  subnet_id      = aws_subnet.pub_a.id
}
resource "aws_route_table_association" "rtb_assoc_pub_pub_b" {
  route_table_id = aws_route_table.pub.id
  subnet_id      = aws_subnet.pub_b.id
}
resource "aws_route_table_association" "rtb_assoc_priv_priv_a" {
  route_table_id = aws_route_table.priv.id
  subnet_id      = aws_subnet.priv_a.id
}
resource "aws_route_table_association" "rtb_assoc_priv_priv_b" {
  route_table_id = aws_route_table.priv.id
  subnet_id      = aws_subnet.priv_b.id
}

# Define VPC Endpoints for ECR
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  tags = {
    Name = local.vpc_endp_ecr_dkr_name
  }
}
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"

  tags = {
    Name = local.vpc_endp_ecr_api_name
  }
}
resource "aws_vpc_endpoint" "ecr_s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"

  tags = {
    Name = local.vpc_endp_ecr_s3_name
  }
}
