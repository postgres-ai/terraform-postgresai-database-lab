resource "random_string" "dle_token" {
  length  = 32
  upper   = true
  lower   = true
  number  = true
  special = false
}

resource "random_string" "joe_signing_secret" {
  length  = 32
  upper   = true
  lower   = true
  number  = true
  special = false
}

resource "random_string" "ci_observer_token" {
  length  = 32
  upper   = true
  lower   = true
  number  = true
  special = false
}

data "template_file" "init" {
  template = "${file("dle-logical-init.sh.tpl")}"
  vars = {
    dle_token = "${random_string.dle_token.result}"
    dle_debug = "${var.dle_debug}"
    dle_retrieval_refresh_timetable = "${var.dle_retrieval_refresh_timetable}"
    dle_disks = "${join(" ",var.ec2_ebs_names)}"
    dle_version_full = "${var.dle_version_full}"
    dns_api_subdomain = "${var.dns_api_subdomain}"
    postgres_source_dbname = "${var.postgres_source_dbname}"
    postgres_source_host = "${var.postgres_source_host}"
    postgres_source_port = "${var.postgres_source_port}"
    postgres_source_username = "${var.postgres_source_username}"
    postgres_source_password = "${var.postgres_source_password}"
    postgres_source_version = "${var.postgres_source_version}"
    platform_token = "${var.platform_token}"
    platform_project_name = "${var.platform_project_name}"
    joe_signing_secret = "${random_string.joe_signing_secret.result}" 
    ci_observer_token = "${random_string.ci_observer_token.result}"
    github_vcs_secret_token = "${var.github_vcs_secret_token}"
  }
}

resource "aws_instance" "aws_ec2" {
  ami               = "${data.aws_ami.ami.id}"
  availability_zone = "${var.availability_zone}"
  instance_type     = "${var.instance_type}"
  security_groups   = ["${aws_security_group.dle_instance_sg.name}"]
  key_name          = "${var.keypair}"
  tags              = "${local.common_tags}"
  user_data         = "${data.template_file.init.rendered}"
}
