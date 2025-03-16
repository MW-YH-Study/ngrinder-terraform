resource "aws_vpc" "ngrinder" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-ngrinder-vpc"
  }
}

resource "aws_internet_gateway" "ngrinder" {
  vpc_id = aws_vpc.ngrinder.id

  tags = {
    Name = "${var.project_name}-ngrinder-igw"
  }
}

resource "aws_subnet" "ngrinder_public" {
  count = length(var.public_subnet_cidrs)

  vpc_id            = aws_vpc.ngrinder.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-ngrinder-pub-sub-${count.index}"
  }
}

resource "aws_eip" "ngrinder_nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-ngrinder-nat-eip"
  }
}

resource "aws_route_table" "ngrinder_public" {
  vpc_id = aws_vpc.ngrinder.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ngrinder.id
  }

  tags = {
    Name = "${var.project_name}-ngrinder-pub-rt"
  }
}

resource "aws_route_table_association" "ngrinder_public" {
  count = length(aws_subnet.ngrinder_public)

  subnet_id      = aws_subnet.ngrinder_public[count.index].id
  route_table_id = aws_route_table.ngrinder_public.id
}
