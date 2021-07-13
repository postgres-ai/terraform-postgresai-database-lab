resource "aws_route53_record" "dblab_clones_subdomain" {
  name = "${var.aws_deploy_dns_api_subdomain}-engine"
  type = "CNAME"

  # TODO -- Allocate an Elastic IP address for the instance rather than using the
  #         default assigned public DNS which can rotate
  records = [
    aws_instance.aws_ec2.public_dns
  ]

  zone_id = data.aws_route53_zone.dblab_zone.zone_id
  ttl     = "60"
}
