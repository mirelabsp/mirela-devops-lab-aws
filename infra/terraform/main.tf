resource "aws_vpc" "devops_lab_vpc" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "DevOpsLabVPC"
  }
}

resource "aws_subnet" "devops_lab_subnet" {
  vpc_id            = aws_vpc.devops_lab_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "DevOpsLabSubnet"
  }
}

resource "aws_security_group" "devops_lab_sg" {
  name        = "DevOpsLabSG"
  description = "SG para API DevOps Lab"
  vpc_id      = aws_vpc.devops_lab_vpc.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
