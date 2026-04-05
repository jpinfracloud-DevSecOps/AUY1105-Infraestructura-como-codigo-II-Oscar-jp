# VPC Principal
resource "aws_vpc" "AUY1105-tiendatech-vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "AUY1105-tiendatech-vpc" }
}

# Internet Gateway para salida a internet
resource "aws_internet_gateway" "AUY1105-tiendatech-igw" {
  vpc_id = aws_vpc.AUY1105-tiendatech-vpc.id
  tags   = { Name = "AUY1105-tiendatech-igw" }
}

# Subred Pública (Donde irá la EC2)
resource "aws_subnet" "AUY1105-tiendatech-subnet-pub-1" {
  vpc_id                  = aws_vpc.AUY1105-tiendatech-vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "AUY1105-tiendatech-subnet-pub-1" }
}

# Subred Privada (Solo estructura por ahora)
resource "aws_subnet" "AUY1105-tiendatech-subnet-priv-1" {
  vpc_id            = aws_vpc.AUY1105-tiendatech-vpc.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "AUY1105-tiendatech-subnet-priv-1" }
}

# Tabla de ruteo pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.AUY1105-tiendatech-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AUY1105-tiendatech-igw.id
  }
  tags = { Name = "AUY1105-public-rt" }
}

# Asociación de subred pública
resource "aws_route_table_association" "pub_assoc" {
  subnet_id      = aws_subnet.AUY1105-tiendatech-subnet-pub-1.id
  route_table_id = aws_route_table.public_rt.id
}