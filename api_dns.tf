/**
 * This file sets up all resources necessary to route incoming
 * HTTPS requests to the Load Balancer defined in api_ssl_endpoint.
 *
 * It assumes that the AWS account has a Route 53 hosted zone
 * and then provisions a sub-domain that will be used to point
 * to the load balancer
 */


data "aws_route53_zone" "dblab_zone" {
  name = var.aws_deploy_dns_zone_name
}

###
# FIXME: Understand when this is and is not needed
# This record was created manually within the Postgres.ai hosted zone
# due to issues when attempting to validate the AWS issue certificate.
# If this is necessary in all circumstances, then this Terraform
# resource should be close to correct.
#
#resource "aws_route53_record" "dblab_api_subdomain_caa" {
#  name = var.aws_deploy_dns_zone_name
#  type = "CAA"
#
#  records = [
#    "0 issue \"amazon.com\"",
#    "0 issue \"amazontrust.com\"",
#    "0 issue \"awstrust.com\"",
#    "0 issue \"amazonaws.com\""
#  ]
#
#  zone_id = data.aws_route53_zone.dblab_zone.zone_id
#  ttl     = "60"
#}

resource "aws_route53_record" "dblab_api_subdomain" {
  name = var.aws_deploy_dns_api_subdomain
  type = "CNAME"

  records = [
    aws_lb.dle_api_lb.dns_name,
  ]

  zone_id = data.aws_route53_zone.dblab_zone.zone_id
  ttl     = "60"
}

resource "aws_acm_certificate" "dblab_api_subdomain_cert" {
  domain_name       = "${var.aws_deploy_dns_api_subdomain}.${var.aws_deploy_dns_zone_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "dblab_api_subdomain_cert_validation" {
  certificate_arn         = aws_acm_certificate.dblab_api_subdomain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.web_cert_validation : record.fqdn]

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    create = "10m"
  }
}

# This is responsible for creating the DNS records that validate the sub-domain ownership
# for the Certificate Authority
resource "aws_route53_record" "web_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.dblab_api_subdomain_cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.dblab_zone.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id

  lifecycle {
    create_before_destroy = true
  }
}
