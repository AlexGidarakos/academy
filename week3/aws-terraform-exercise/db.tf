# Define a DB Subnet Group
resource "aws_db_subnet_group" "dbs" {
  name       = local.db_sn_grp_name
  subnet_ids = [aws_subnet.priv_a.id, aws_subnet.priv_b.id]

  tags = {
    Name = local.db_sn_grp_name
  }
}

# Define a Security Group for the DB instance
resource "aws_security_group" "dbs" {
  name   = local.sg_dbs_name
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.priv_a.cidr_block]
  }

  tags = {
    Name = local.sg_dbs_name
  }
}

# Define a DB instance
resource "aws_db_instance" "dbs" {
  db_subnet_group_name   = aws_db_subnet_group.dbs.name
  vpc_security_group_ids = [aws_security_group.dbs.id]
  allocated_storage      = var.dbs_storage
  engine                 = var.dbs_engine
  identifier             = local.dbs_name
  instance_class         = var.dbs_instance_class
  skip_final_snapshot    = var.dbs_skip_final_snapshot
  username               = var.dbs_username
  password               = var.dbs_password

  tags = {
    Name = local.dbs_name
  }
}
