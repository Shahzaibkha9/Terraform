resource "aws_vpc" "test-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Test-VPC"
  }
}

resource "aws_subnet" "Public-1" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "Public-subnet"
  }
}

resource "aws_subnet" "Public-2" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Public-subnet-2"
  }
}

resource "aws_subnet" "Private-1" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "Private-subnet"
  }
}
resource "aws_subnet" "Private-2" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "Private-subnet-2"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "test-gateway"
  }
}
resource "aws_eip" "Nat-ip" {
  domain   = "vpc"
}
resource "aws_eip" "Nat-ip-2" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "test" {
  allocation_id                  = aws_eip.Nat-ip.id
  subnet_id                      = aws_subnet.Public-1.id
}

resource "aws_nat_gateway" "test-2" {
  allocation_id                  = aws_eip.Nat-ip-2.id
  subnet_id                      = aws_subnet.Public-2.id
}


resource "aws_route_table" "test-pub" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table" "test-pri" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table" "test-pri2" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test-2.id
  }

  tags = {
    Name = "example"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Public-1.id
  route_table_id = aws_route_table.test-pub.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.Public-2.id
  route_table_id = aws_route_table.test-pub.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.Private-1.id
  route_table_id = aws_route_table.test-pri.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.Private-2.id
  route_table_id = aws_route_table.test-pri2.id
}