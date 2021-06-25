output "ip" {
  value = "${aws_instance.aws_ec2.public_ip}"
}
output "ec2instance" {
  value = "${aws_instance.aws_ec2.id}"
}
output "ec2_public_dns" {
  value = "${aws_instance.aws_ec2.public_dns}"
}
output "public_dns_name" {
  value = "${join("", aws_route53_record.dblab_clones_subdomain.*.fqdn)}"
}
output "dle_verification_token" {
  value = "${random_string.dle_token.result}"
}
output "joe_signing_secret" {
  value = "${random_string.joe_signing_secret.result}"
}
