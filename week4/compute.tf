
resource "tls_private_key" "TeamA-bastion-pk" { 
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "TeamA-bastion-key-pair-public" { 
    key_name = "TeamA-bastion-key-pair-public"
    public_key = tls_private_key.TeamA-bastion-pk.public_key_openssh 
    provisioner "local-exec" {
        command = "echo '${tls_private_key.TeamA-bastion-pk.private_key_pem}' > ~/.ssh/TeamA-bastion-key-pair-public.pem; chmod 400 ~/.ssh/TeamA-bastion-key-pair-public.pem" 
    }
}

resource "aws_security_group" "TeamA" {
  name   = "TeamA-bastion-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


variable "servers" {
    type = list(object({
        name = string,
        ami = string,
        instance_type = string,
        subnet_id = string,
        associate_public_ip_address = bool,
        key_name = string
        vpc_security_group_ids = list(string),
    }))
}

resource "aws_instance" "server" {
    //for_each = var.servers

    count = length(var.servers)
   
    ami             =  var.servers[count.index].ami
    instance_type   =  var.servers[count.index].instance_type
    associate_public_ip_address    =  var.servers[count.index].associate_public_ip_address
    key_name        =  var.servers[count.index].key_name
    subnet_id       =  module.vpc.public_subnets[count.index]
    vpc_security_group_ids =  [aws_security_group.TeamA.id]
    tags = {Name = var.servers[count.index].name}
}

output "bastion_ips" {
  value = aws_instance.server[*].public_ip
}

#Creates Private EC2 keys
resource "tls_private_key" "TeamA-privateEc2-pk" { 
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "TeamA-privateEc2-key-pair-public" { 
    key_name = "TeamA-privateEc2-key-pair-public"
    public_key = tls_private_key.TeamA-privateEc2-pk.public_key_openssh 
    provisioner "local-exec" {
        command = "echo '${tls_private_key.TeamA-privateEc2-pk.private_key_pem}' > ~/.ssh/TeamA-privateEc2-key-pair-public.pem; chmod 400 ~/.ssh/TeamA-privateEc2-key-pair-public.pem" 
    }
}

resource "aws_security_group" "TeamA-privateEc2" {
  name   = "TeamA-privateEc2-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    //cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.TeamA.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "servers-privateEc2" {
    type = list(object({
        name = string,
        ami = string,
        instance_type = string,
        subnet_id = string,
        associate_public_ip_address = bool,
        key_name = string
        vpc_security_group_ids = list(string),
    }))
}

resource "aws_instance" "server-privateEc2" {
    //for_each = var.servers

    count = length(var.servers-privateEc2)
   
    ami             =  var.servers-privateEc2[count.index].ami
    instance_type   =  var.servers-privateEc2[count.index].instance_type
    associate_public_ip_address    =  var.servers-privateEc2[count.index].associate_public_ip_address
    key_name        =  var.servers-privateEc2[count.index].key_name
    subnet_id       =  module.vpc.private_subnets[count.index]
    vpc_security_group_ids =  [aws_security_group.TeamA-privateEc2.id]
    tags = {Name = var.servers-privateEc2[count.index].name}
}