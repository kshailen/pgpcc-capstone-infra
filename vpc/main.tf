#
# VPC Resources

provider "aws" {
  region = var.aws_region
  profile =   var.profile
  version = "~> 2.19"
}
data "aws_availability_zones" "available" {}

resource "aws_vpc" "pgpcc-capston-infra" {
  cidr_block = var.vpc-cidr

  tags = {
    Name                                      = "${var.aws_region}-pgpcc-capston"
  }
}

resource "aws_subnet" "private_subnets" {
  count = var.private_subnet_count

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc-cidr, 8, count.index)
  vpc_id            = aws_vpc.pgpcc-capston-infra.id


  tags = {
    "Name"                                    = "subnet-${var.aws_region}-eks-${count.index}"
    "Type" = "Private for eks"
  }
}


resource "aws_subnet" "public_subnet" {
  count = var.public_subnet_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = cidrsubnet(var.vpc-cidr, 8, var.private_subnet_count+count.index)
  vpc_id = aws_vpc.pgpcc-capston-infra.id

  tags = {
    "Name"  = "subnet-${var.aws_region}-public-${count.index}",
    "Type" = "Public subnet"
  }

}



resource "aws_internet_gateway" "capston-igw" {
  vpc_id = aws_vpc.pgpcc-capston-infra.id

  tags = {
    Name = "${var.aws_region}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.pgpcc-capston-infra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.capston-igw.id
  }
}

# Public route table association
resource "aws_route_table_association" "public_route_table_association" {
  count = var.public_subnet_count

  subnet_id = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public.id

}

# Create an EIP for the natgateway
resource "aws_eip" "nat" {
  count = var.ng_count
  vpc      = true

  depends_on = [aws_internet_gateway.capston-igw]

  tags = {
    Name = "eip_for-nat_gateway-VPC-${var.vpc-cidr}"
  }
}


resource "aws_nat_gateway" "nat" {
  count = var.ng_count

  allocation_id = aws_eip.nat.*.id[count.index]
  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)

  depends_on = [aws_internet_gateway.capston-igw]
}

# Create the private route table
resource "aws_route_table" "private_route_table" {
  count = var.ng_count
  vpc_id = aws_vpc.pgpcc-capston-infra.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.*.id[count.index]

  }

  tags = {
    Name = "Private route table"
  }

  depends_on = [aws_nat_gateway.nat]
}


resource "aws_route_table_association" "eks_private" {
  count = var.private_subnet_count

  subnet_id      = aws_subnet.private_subnets.*.id[count.index]
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)

  depends_on = [aws_subnet.private_subnets]
}