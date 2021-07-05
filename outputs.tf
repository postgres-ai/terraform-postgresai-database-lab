output "ip" {
  value = "${aws_instance.aws_ec2.public_ip}"
}
output "ec2instance" {
  value = "${aws_instance.aws_ec2.id}"
}
output "ec2_public_dns" {
  value = "${aws_instance.aws_ec2.public_dns}"
}
output "dle_url_for_registration" {
  value = "${format("%s://%s", "https",join("", aws_route53_record.dblab_clones_subdomain.*.fqdn))}"
}
output "joe_url_for_registration" {
  value = "${format("%s://%s:%s", "https",join("", aws_route53_record.dblab_clones_subdomain.*.fqdn),"444")}"
}
output "dle_verification_token" {
  value = "${random_string.dle_token.result}"
}
output "joe_signing_secret" {
  value = "${random_string.joe_signing_secret.result}"
}
output "ci_observer_token" {
  value = "${random_string.ci_observer_token.result}"
}
