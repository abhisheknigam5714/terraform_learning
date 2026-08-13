resource "aws_vpc" "prod" {
  tags = {
    Name = "dev-vpc"
  }
  cidr_block = "10.0.0.0/16"
}



//subnet creation---
resource "aws_subnet" "dev-subnet" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name = "dev-subnet"
  }
  cidr_block        = "10.0.0.0/25"
  availability_zone = "ap-south-1-zg-1"
}


//private subnet creation

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name = "private subnet"
  }
  cidr_block = "10.0.5.0/25"
}


//elastic ip
resource "aws_eip" "nat" {
  domain = aws_vpc.prod

  tags = {
    Name = "eip"
  }




}
//create internet gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name = "prod-ig"
  }
}

//create route table attach to ig  
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.prod.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}


resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.dev-subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.dev-subnet.id

  tags = { Name = "main-nat-gw" }

  # Ensure the Internet Gateway exists before creating the NAT Gateway
  depends_on = [aws_internet_gateway.ig]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = { Name = "private-rt" }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
