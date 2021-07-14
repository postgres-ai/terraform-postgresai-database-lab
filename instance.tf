resource "random_string" "dle_verification_token" {
  length  = 32
  upper   = true
  lower   = true
  number  = true
  special = false
}

resource "random_string" "platform_joe_signing_secret" {
  length  = 32
  upper   = true
  lower   = true
  number  = true
  special = false
}

resource "random_string" "vcs_db_migration_checker_verification_token" {
  length  = 32
  upper   = true
  lower   = true
  number  = true
  special = false
}

data "template_file" "init" {
  template = "${file("dle-logical-init.sh.tpl")}"
  vars = {
    dle_verification_token = "${random_string.dle_verification_token.result}"
    dle_debug_mode = "${var.dle_debug_mode}"
    dle_retrieval_refresh_timetable = "${var.dle_retrieval_refresh_timetable}"
    dle_disks = "${join(" ",var.aws_deploy_ec2_volumes_names)}"
    dle_version_full = "${var.dle_version_full}"
    aws_deploy_dns_zone_name = "${var.aws_deploy_dns_zone_name}"
    aws_deploy_dns_api_subdomain = "${var.aws_deploy_dns_api_subdomain}"
    aws_deploy_certificate_email = "{var.aws_deploy_certificate_email}"
    source_postgres_dbname = "${var.source_postgres_dbname}"
    source_postgres_host = "${var.source_postgres_host}"
    source_postgres_port = "${var.source_postgres_port}"
    source_postgres_username = "${var.source_postgres_username}"
    source_postgres_password = "${var.source_postgres_password}"
    source_postgres_version = "${var.source_postgres_version}"
    postgres_config_shared_preload_libraries = "${var.postgres_config_shared_preload_libraries}"
    platform_access_token = "${var.platform_access_token}"
    platform_project_name = "${var.platform_project_name}"
    platform_joe_signing_secret = "${random_string.platform_joe_signing_secret.result}"
    vcs_db_migration_checker_verification_token = "${random_string.vcs_db_migration_checker_verification_token.result}"
    vcs_github_secret_token = "${var.vcs_github_secret_token}"
  }
}

resource "aws_instance" "aws_ec2" {
  ami               = "${data.aws_ami.ami.id}"
  availability_zone = "${var.aws_deploy_ebs_availability_zone}"
  instance_type     = "${var.aws_deploy_ec2_instance_type}"
  security_groups   = ["${aws_security_group.dle_instance_sg.name}"]
  key_name          = "${var.aws_keypair}"
  tags              = "${local.common_tags}"
  user_data         = "${data.template_file.init.rendered}"
}
