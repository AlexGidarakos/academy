# Lookup the root Hosted Zone to reference when adding a CNAME record later on
data "aws_route53_zone" "zone_root" {
  name = var.zone_root_name
  # zone_id = var.zone_root_id
}

# Define a private Hosted Zone for the DB records 
resource "aws_route53_zone" "private" {
  name = local.zone_private_name

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = {
    Name = local.zone_private_name
  }
}

# Define a CNAME record for the ALB
resource "aws_route53_record" "cname_alb" {
  zone_id = data.aws_route53_zone.zone_root.id
  type    = "CNAME"
  name    = "alexg-tfexercise" # local.cname_alb_name
  ttl     = var.cname_alb_ttl
  records = [aws_lb.alb.dns_name]
}

# Define a CNAME record for the DB instance
resource "aws_route53_record" "cname_dbs" {
  zone_id = aws_route53_zone.private.id
  type    = "CNAME"
  name    = local.cname_dbs_name
  ttl     = var.cname_dbs_ttl
  records = [aws_db_instance.dbs.address]
}

# Define an SSL certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = local.cert_name
  validation_method = "DNS"

  tags = {
    Name = local.cert_name
  }
}

# Define helper DNS records to use in SSL certificate validation
resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.zone_root.id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

# Define an SSL certificate validation
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}
