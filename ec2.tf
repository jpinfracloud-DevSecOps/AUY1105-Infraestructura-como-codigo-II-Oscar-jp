# Grupo de Seguridad (SG)
resource "aws_security_group" "AUY1105-tiendatech-sg" {
  name        = "AUY1105-tiendatech-sg"
  description = "SG para MVP - SSH Restringido"
  vpc_id      = aws_vpc.AUY1105-tiendatech-vpc.id

  ingress {
    description = "SSH restringido a la red interna (Requisito OPA)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    description = "Permitir salida para instalacion de paquetes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "AUY1105-tiendatech-sg" }
}

# Data para AMI de Ubuntu
data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# Instancia EC2
resource "aws_instance" "AUY1105-tiendatech-ec2" {
  ami                    = data.aws_ami.ubuntu_2404.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.AUY1105-tiendatech-subnet-pub-1.id
  vpc_security_group_ids = [aws_security_group.AUY1105-tiendatech-sg.id]

  # EJECUCIÓN DEL SCRIPT
  user_data = file("install.sh")

  # Seguridad EBS (Checkov)
  root_block_device {
    encrypted = true
  }

  # Seguridad Metadatos (IMDSv2 - Checkov)
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = { Name = "AUY1105-tiendatech-ec2" }
}