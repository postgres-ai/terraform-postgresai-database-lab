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
#resource "aws_route53_record" "dblab_subdomain_caa" {
#  name = var.aws_deploy_dns_zone_name
#  type = "CAA"
#
#  records = [
#    "0 issue \"amazon.com\"",
#    "0 issue \"amazontrust.com\"",
#    "0 issue \"awstrust.com\"",
#    "0 issue \"amazonaws.com\"",
#    "0 issue \"letsencrypt.org\""
#  ]
#
#  zone_id = data.aws_route53_zone.dblab_zone.zone_id
#  ttl     = "60"
#}

resource "aws_route53_record" "dblab_subdomain" {
  name = var.aws_deploy_dns_api_subdomain
  type = "CNAME"

  # TODO -- Allocate an Elastic IP address for the instance rather than using the
  #         default assigned public DNS which can rotate
  records = [
    aws_instance.aws_ec2.public_dns
  ]

  zone_id = data.aws_route53_zone.dblab_zone.zone_id
  ttl     = "60"
}
