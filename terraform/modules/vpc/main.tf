# VPC Resource
resource "aws_vpc" "triaina_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Triaina VPC"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.triaina_vpc.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true # Allow access to the internet in public subnets

  tags = {
    Name = "${element(var.availability_zones, count.index)}-public-subnet"
  }
}

# Public Subnets
resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.triaina_vpc.id
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false # Internet access not allowed

  tags = {
    Name = "${element(var.availability_zones, count.index)}-private-subnet"
  }
}

# Internet Gateway (Allow public subnets to access the internet)
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.triaina_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "NAT EIP"
  }
}

# NAT Gateway (Allow instances in private subnets to initiate outbound traffic but prevent inbound public traffic)
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public_subnets.*.id, 0)

  tags = {
    Name = "NAT Gateway"
  }
}

# Route tables allow to route traffic to the internet
# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.triaina_vpc.id

  tags = {
    Name = "Public Route Table"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.triaina_vpc.id

  tags = {
    Name = "Private Route Table"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# Route for NAT Gateway
resource "aws_route" "private_internet_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# Route table associations for both Public subnet and Private subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
