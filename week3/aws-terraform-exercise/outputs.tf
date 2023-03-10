# Define region output
output "region" {
  value = var.region
}

# Define Elastic IP output
output "eip_nat_public_ip" {
  value = aws_eip.nat.public_ip
}

# Define private Hosted Zone output
output "zone_private_name" {
  value = local.zone_private_name
}

# Define public ALB CNAME output
output "cname_alb_full" {
  value = join(".", [local.cname_alb_name, var.zone_root_name])
}

# Define private DB CNAME output
output "cname_dbs_full" {
  value = join(".", [local.cname_dbs_name, aws_route53_zone.private.name])
}
