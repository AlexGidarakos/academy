# Define student name to be used in constructing the prefix for resource names
variable "student" {
  default = "alexg"
}

# Define project name to be used in constructing the prefix for resource names
variable "project" {
  default = "tfexercise"
}

# Define separator character to be used in constructing the prefix for resource names
variable "separator" {
  default = "-"
}

# Define prefix for resource names
locals {
  prefix = join(var.separator, [var.student, var.project])
}

# Define region, can be used to override ~/.aws/config
variable "region" {
  default = "eu-west-1"
}

# Define VPC settings
variable "vpc_postfix" {
  default = "vpc"
}
locals {
  vpc_name = join(var.separator, [local.prefix, var.vpc_postfix])
}
variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

# Define public subnet A settings
variable "sn_pub_a_postfix" {
  default = "sn-pub-a"
}
locals {
  sn_pub_a_name = join(var.separator, [local.prefix, var.sn_pub_a_postfix])
}
variable "sn_pub_a_cidr" {
  default = "192.168.0.0/25"
}
variable "sn_pub_a_az_postfix" {
  default = "a"
}
locals {
  sn_pub_a_az = join("", [var.region, var.sn_pub_a_az_postfix])
}

# Define public subnet B settings
variable "sn_pub_b_postfix" {
  default = "sn-pub-b"
}
locals {
  sn_pub_b_name = join(var.separator, [local.prefix, var.sn_pub_b_postfix])
}
variable "sn_pub_b_cidr" {
  default = "192.168.0.128/25"
}
variable "sn_pub_b_az_postfix" {
  default = "b"
}
locals {
  sn_pub_b_az = join("", [var.region, var.sn_pub_b_az_postfix])
}

# Define private subnet A settings
variable "sn_priv_a_postfix" {
  default = "sn-priv-a"
}
locals {
  sn_priv_a_name = join(var.separator, [local.prefix, var.sn_priv_a_postfix])
}
variable "sn_priv_a_cidr" {
  default = "192.168.1.0/25"
}
variable "sn_priv_a_az_postfix" {
  default = "a"
}
locals {
  sn_priv_a_az = join("", [var.region, var.sn_priv_a_az_postfix])
}

# Define private subnet B settings
variable "sn_priv_b_postfix" {
  default = "sn-priv-b"
}
locals {
  sn_priv_b_name = join(var.separator, [local.prefix, var.sn_priv_b_postfix])
}
variable "sn_priv_b_cidr" {
  default = "192.168.1.128/25"
}
variable "sn_priv_b_az_postfix" {
  default = "b"
}
locals {
  sn_priv_b_az = join("", [var.region, var.sn_priv_b_az_postfix])
}

# Define Internet Gateway settings
variable "igw_postfix" {
  default = "igw"
}
locals {
  igw_name = join(var.separator, [local.prefix, var.igw_postfix])
}

# Define Elastic IP settings
variable "eip_postfix" {
  default = "eip"
}
locals {
  eip_name = join(var.separator, [local.prefix, var.eip_postfix])
}

# Define NAT Gateway settings
variable "nat_postfix" {
  default = "nat"
}
locals {
  nat_name = join(var.separator, [local.prefix, var.nat_postfix])
}

# Define public Route Table settings
variable "rtb_pub_postfix" {
  default = "rtb-pub"
}
locals {
  rtb_pub_name = join(var.separator, [local.prefix, var.rtb_pub_postfix])
}
variable "rtb_pub_route_cidr" {
  default = "0.0.0.0/0"
}

# Define private Route Table settings
variable "rtb_priv_postfix" {
  default = "rtb-priv"
}
locals {
  rtb_priv_name = join(var.separator, [local.prefix, var.rtb_priv_postfix])
}
variable "rtb_priv_route_cidr" {
  default = "0.0.0.0/0"
}

# Define DB Subnet Group settings
variable "db_sn_grp_postfix" {
  default = "db-sn-grp"
}
locals {
  db_sn_grp_name = join(var.separator, [local.prefix, var.db_sn_grp_postfix])
}

# Define DB Server Security Group settings
variable "sg_dbs_postfix" {
  default = "sg-dbs"
}
locals {
  sg_dbs_name = join(var.separator, [local.prefix, var.sg_dbs_postfix])
}

# Define DB Server settings
variable "dbs_postfix" {
  default = "dbs"
}
locals {
  dbs_name = join(var.separator, [local.prefix, var.dbs_postfix])
}
variable "dbs_engine" {
  default = "postgres"
}
variable "dbs_storage" {
  default = 20 # 20GiB is the minimum acceptable for the PostgreSQL engine
}
variable "dbs_instance_class" {
  default = "db.t3.micro"
}
variable "dbs_skip_final_snapshot" {
  default = true
}
variable "dbs_username" {
  default = "foo"
}
variable "dbs_password" {
  default = "foobarfoo"
}

# Define ECR Repository settings
variable "ecr_postfix" {
  default = "ecr"
}
locals {
  ecr_name = join(var.separator, [local.prefix, var.ecr_postfix])
}

# Define VPC Endpoints settings
variable "vpc_endp_ecr_dkr_postfix" {
  default = "vpc-endp-ecr-dkr"
}
locals {
  vpc_endp_ecr_dkr_name = join(var.separator, [local.prefix, var.vpc_endp_ecr_dkr_postfix])
}
variable "vpc_endp_ecr_api_postfix" {
  default = "vpc-endp-ecr-api"
}
locals {
  vpc_endp_ecr_api_name = join(var.separator, [local.prefix, var.vpc_endp_ecr_api_postfix])
}
variable "vpc_endp_ecr_s3_postfix" {
  default = "vpc-endp-ecr-s3"
}
locals {
  vpc_endp_ecr_s3_name = join(var.separator, [local.prefix, var.vpc_endp_ecr_s3_postfix])
}

# Define filters to look up the root Hosted Zone name
variable "zone_root_name" {
  # default = "d63a8c22cfb9.co.uk"
  default = "kpa2023.techniffic.com"
}
variable "zone_root_id" {
  # default = "Z04948702WAVIYHOMMI8T"
  default = "Z0126258EOB0TWJH4RFY"
}
locals {
  zone_private_name = local.prefix
}

# Define CNAME records settings
locals {
  cname_alb_name = local.prefix
}
variable "cname_alb_ttl" {
  default = 3600
}
locals {
  cname_dbs_name = "db"
}
variable "cname_dbs_ttl" {
  default = 3600 # Perhaps it should be much lower as it's in a private zone?
}

# Define Application Load Balancer Security Group settings
variable "sg_alb_postfix" {
  default = "sg-alb"
}
locals {
  sg_alb_name = join(var.separator, [local.prefix, var.sg_alb_postfix])
}

# Define Application Load Balancer settings
variable "alb_postfix" {
  default = "alb"
}
locals {
  alb_name = join(var.separator, [local.prefix, var.alb_postfix])
}

# Define Application Load Balancer Target Group settings
variable "alb_tg_postfix" {
  default = "alb-tg"
}
locals {
  alb_tg_name = join(var.separator, [local.prefix, var.alb_tg_postfix])
}
variable "alb_tg_port" {
  default = 8000
}
variable "alb_tg_proto" {
  default = "HTTP"
}

# Define ECS Cluster settings
variable "ecs_cluster_postfix" {
  default = "ecs"
}
locals {
  ecs_cluster_name = join(var.separator, [local.prefix, var.ecs_cluster_postfix])
}
variable "ecs_providers_list" {
  default = ["FARGATE"]
}

# Define ECS task definition settings
variable "ecs_task_postfix" {
  default = "ecs-task"
}
locals {
  ecs_task_family = join(var.separator, [local.prefix, var.ecs_task_postfix])
}
variable "ecs_task_memory" {
  default = 128
}

# Define ECS service settings
variable "ecs_service_postfix" {
  default = "ecs-service"
}
locals {
  ecs_service_name = join(var.separator, [local.prefix, var.ecs_service_postfix])
}
variable "ecs_service_container_port" {
  default = 8000
}

# Define SSL certificate settings
locals {
  cert_name = join(".", [local.cname_alb_name, var.zone_root_name])
}
