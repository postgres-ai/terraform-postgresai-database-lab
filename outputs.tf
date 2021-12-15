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


Congratulations! 
You have successfully provisioned cloud infrastructure for DLE. 

To connect to created VM you may ssh ubuntu@${aws_instance.aws_ec2.public_ip} -i ${var.aws_deploy_ec2_instance_tag_name}.pem
To open embedded UI ${format("%s://%s:%s", "https",join("", aws_route53_record.dblab_subdomain.*.fqdn),"446")}
To open to DLE API ${format("%s://%s", "https",join("", aws_route53_record.dblab_subdomain.*.fqdn))}
To open DB Migration Checker API ${format("%s://%s:%s", "https",join("", aws_route53_record.dblab_subdomain.*.fqdn),"445")}
EOT
}
output "next_steps" {
  value = local.welcome_message
}
