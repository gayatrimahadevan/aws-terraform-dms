# Internet VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = format("%s", var.name)
  }
}

# Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  vpc_id                  = element(concat(aws_vpc.this.*.id, [""]), 0)
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = format("%s-public", var.name)
    Type = "Public"
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  vpc_id                  = element(concat(aws_vpc.this.*.id, [""]), 0)
  cidr_block              = var.private_subnets[count.index]
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = format("%s-private", var.name)
    Type = "Private"
  }
}
# Internet GW
resource "aws_internet_gateway" "this" {
  vpc_id = element(concat(aws_vpc.this.*.id, [""]), 0)
  tags = {
    Name = format("%s-igw", var.name)
  }
}

# route tables
resource "aws_route_table" "public" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = element(concat(aws_vpc.this.*.id, [""]), 0)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = format("%s-public-rt", var.name)
  }
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets) > 0 ? 1 : 0
  vpc_id = element(concat(aws_vpc.this.*.id, [""]), 0)

  tags = {
    Name = format("%s-private-rt", var.name)
  }
}

# route associations public
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

# route associations private
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
