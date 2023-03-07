terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.57.1"
    }
  }

  required_version = ">= 1.3.9"
}

resource "aws_vpc" "lab02" {
  cidr_block       = "192.168.0.0/16"
#  instance_tenancy = "default"

  tags = {
    Name = "alexg-lab02-vpc"
  }
}

resource "aws_internet_gateway" "lab02" {
  vpc_id = aws_vpc.lab02.id

  tags = {
    Name = "alexg-lab02-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.lab02.id
  cidr_block = "192.168.100.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "alexg-lab02-subnet-public"
  }
}

resource "aws_route_table" "lab02" {
  vpc_id = aws_vpc.lab02.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab02.id
  }

  tags = {
    Name = "alexg-lab02-rtb-public"
  }
}

resource "aws_route_table_association" "lab02" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.lab02.id
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.lab02.id
  cidr_block = "192.168.200.0/24"

  tags = {
    Name = "alexg-lab02-subnet-private"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*amzn2-ami-kernel-5.10-hvm-2.0.20230221.0-x86_64-gp2*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ssh" {
  name = "alexg-lab02-sg-ssh-access"
  description = "Allow SSH incoming connections"
  vpc_id = aws_vpc.lab02.id

  ingress {
    description = "SSH incoming"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "alexg-lab02-sg-ssh-access"
  }
}

resource "tls_private_key" "pk1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp1" {
  key_name = "alexg-lab02-kp1"
  public_key = tls_private_key.pk1.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk1.private_key_pem}' > ~/.ssh/alexg-lab02-kp1.pem; chmod 600 ~/.ssh/alexg-lab02-kp1.pem"
  }
}

resource "tls_private_key" "pk2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp2" {
  key_name = "alexg-lab02-kp2"
  public_key = tls_private_key.pk2.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk2.private_key_pem}' > ~/.ssh/alexg-lab02-kp2.pem; chmod 600 ~/.ssh/alexg-lab02-kp2.pem"
  }
}

resource "aws_instance" "lab02-a" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh.id]
  key_name = "alexg-lab02-kp1"
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "alexg-lab02-ec2-a"
  }
}

resource "aws_instance" "lab02-b" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh.id]
  key_name = "alexg-lab02-kp2"
  subnet_id = aws_subnet.private.id

  tags = {
    Name = "alexg-lab02-ec2-b"
  }
}
