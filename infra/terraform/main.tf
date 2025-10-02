# ==============================================================================
# 1. VPC Base
# ==============================================================================
resource "aws_vpc" "devops_lab_vpc" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_hostnames  = true
  tags = {
    Name = "DevOpsLabVPC"
  }
}

# ------------------------------------------------------------------------------
# 2. Subnet e Acesso Público
# ------------------------------------------------------------------------------

# Internet Gateway (Permite comunicação da VPC com a internet)
resource "aws_internet_gateway" "devops_lab_igw" {
  vpc_id = aws_vpc.devops_lab_vpc.id
  tags = {
    Name = "DevOpsLabIGW"
  }
}

# Sub-rede Pública (Com mapeamento de IP Público ativado)
resource "aws_subnet" "devops_lab_subnet" {
  vpc_id                  = aws_vpc.devops_lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true  # Torna a sub-rede pública
  tags = {
    Name = "DevOpsLabSubnet"
  }
}

# Tabela de Rotas
resource "aws_route_table" "devops_lab_route_table" {
  vpc_id = aws_vpc.devops_lab_vpc.id
  tags = {
    Name = "DevOpsLabRouteTable"
  }

  # Rota para a Internet (0.0.0.0/0 via Internet Gateway)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_lab_igw.id
  }
}

# Associação da Tabela de Rotas à Sub-rede
resource "aws_route_table_association" "devops_lab_subnet_association" {
  subnet_id      = aws_subnet.devops_lab_subnet.id
  route_table_id = aws_route_table.devops_lab_route_table.id
}

# ------------------------------------------------------------------------------
# 3. Security Group (SG)
# ------------------------------------------------------------------------------
resource "aws_security_group" "devops_lab_sg" {
  name        = "DevOpsLabSG"
  description = "SG para API DevOps Lab (Portas 22 e 5000)"
  vpc_id      = aws_vpc.devops_lab_vpc.id

  # Regra 1: Libera a porta da aplicação (5000)
  ingress {
    description = "Acesso a API HTTP - Porta 5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regra 2: Libera SSH (22)
  ingress {
    description = "Acesso SSH" 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite todo o tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOpsLabSG"
  }
}


# ------------------------------------------------------------------------------
# 4. Instância EC2 (Host para o Docker)
# ------------------------------------------------------------------------------
resource "aws_instance" "devops_lab_ec2" {
  # AMI ID: ami-052064a798f08f0d3 (Amazon Linux 2023 - us-east-1)
  ami             = "ami-052064a798f08f0d3" 
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.devops_lab_subnet.id
  vpc_security_group_ids = [aws_security_group.devops_lab_sg.id]
  key_name        = "DevOpsLabKey" 

  # Script que instala Docker e roda a API no boot
  user_data = <<-USER_DATA
    #!/bin/bash
    yum update -y
    # CORREÇÃO PARA AMAZON LINUX 2023: Instala o Docker
    yum install docker -y 
    systemctl start docker
    systemctl enable docker
    # Sua imagem publicada no Dia 5
    docker run -d -p 5000:5000 --name devops_api mirelasantana/devops-lab-api:latest
  USER_DATA

  tags = {
    Name = "DevOpsLabEC2"
  }
}