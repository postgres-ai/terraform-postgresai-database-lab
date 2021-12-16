output "aws_ec2_instance_ip" {
  value = "${aws_instance.aws_ec2.public_ip}"
}
output "aws_ec2_instance_id" {
  value = "${aws_instance.aws_ec2.id}"
}
output "aws_ec2_instance_dns" {
  value = "${aws_instance.aws_ec2.public_dns}"
}
output "platform_dle_registration_url" {
  value = "${format("%s://%s", "https",join("", aws_route53_record.dblab_subdomain.*.fqdn))}"
}
output "platform_joe_registration_url" {
  value = "${format("%s://%s:%s", "https",join("", aws_route53_record.dblab_subdomain.*.fqdn),"444")}"
}
output "dle_verification_token" {
  value = "${random_string.dle_verification_token.result}"
}
output "platform_joe_signing_secret" {
  value = "${random_string.platform_joe_signing_secret.result}"
}
output "vcs_db_migration_checker_verification_token" {
  value = "${random_string.vcs_db_migration_checker_verification_token.result}"
}
output "vcs_db_migration_checker_registration_url" {
  value = "${format("%s://%s:%s", "https",join("", aws_route53_record.dblab_subdomain.*.fqdn),"445")}"
}
output "local_ui_url" {
  value = "${format("%s://%s:%s", "https",join("", aws_route53_record.dblab_subdomain.*.fqdn),"446")}"
}

locals {
  welcome_message = <<EOT


    #####################################################################

    Congratulations! Database Lab Engine installed.
    Data initialization may take time, depending on the database size.

    You should be able to work with all DLE interfaces already:
    - [RECOMMENDED] UI: ${format("%s://%s:%s", "https",join("", aws_route53_record.dblab_subdomain.*.fqdn),"446")}
    - CLI: dblab init --url=${format("%s://%s", "https",join("", aws_route53_record.dblab_subdomain.*.fqdn))} --token=${random_string.dle_verification_token.result} --environment="${aws_instance.aws_ec2.id}" --insecure
    - API: ${format("%s://%s", "https",join("", aws_route53_record.dblab_subdomain.*.fqdn))}
    - SSH connection for troubleshooting: ssh ubuntu@${aws_instance.aws_ec2.public_ip} -i ${var.aws_deploy_ec2_instance_tag_name}.pem

    (Use verification token: ${random_string.dle_verification_token.result})

    For support, go to https://postgres.ai/contact.

    #####################################################################

EOT
}
output "zzz_next_steps" {
  value = local.welcome_message
}
