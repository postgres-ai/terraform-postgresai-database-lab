resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "provision_key" {
  key_name   = "${var.aws_deploy_ec2_instance_tag_name}"
  public_key = tls_private_key.ssh_key.public_key_openssh
}


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

resource "aws_instance" "aws_ec2" {
  ami               = "${data.aws_ami.ami.id}"
  availability_zone = "${var.aws_deploy_ebs_availability_zone}"
  instance_type     = "${var.aws_deploy_ec2_instance_type}"
  security_groups   = ["${aws_security_group.dle_instance_sg.name}"]
  key_name          = aws_key_pair.provision_key.key_name
  tags              = "${local.common_tags}"
  iam_instance_profile = "${var.source_type == "s3" ? "${aws_iam_instance_profile.instance_profile[0].name}" : null}"
  user_data         = templatefile("${path.module}/dle-logical-init.sh.tpl",{
    dle_verification_token = "${random_string.dle_verification_token.result}"
    dle_debug_mode = "${var.dle_debug_mode}"
    dle_retrieval_refresh_timetable = "${var.dle_retrieval_refresh_timetable}"
    dle_version = "${var.dle_version}"
    joe_version = "${var.joe_version}"
    aws_deploy_dns_zone_name = "${var.aws_deploy_dns_zone_name}"
    aws_deploy_dns_api_subdomain = "${var.aws_deploy_dns_api_subdomain}"
    aws_deploy_certificate_email = "${var.aws_deploy_certificate_email}"
    source_postgres_dbname = "${var.source_postgres_dbname}"
    source_postgres_host = "${var.source_postgres_host}"
    source_postgres_port = "${var.source_postgres_port}"
    source_postgres_username = "${var.source_postgres_username}"
    source_postgres_password = "${var.source_postgres_password}"
    source_postgres_version = "${var.source_postgres_version}"
    postgres_config_shared_preload_libraries = "${var.postgres_config_shared_preload_libraries}"
    postgres_dump_parallel_jobs = "${var.postgres_dump_parallel_jobs}"
    platform_access_token = "${var.platform_access_token}"
    platform_project_name = "${var.platform_project_name}"
    platform_joe_signing_secret = "${random_string.platform_joe_signing_secret.result}"
    vcs_db_migration_checker_verification_token = "${random_string.vcs_db_migration_checker_verification_token.result}"
    vcs_github_secret_token = "${var.vcs_github_secret_token}"
    source_type = "${var.source_type}"
    source_pgdump_s3_bucket = "${var.source_pgdump_s3_bucket}"
    source_pgdump_s3_mount_point = "${var.source_pgdump_s3_mount_point}"
    source_pgdump_path_on_s3_bucket = "${var.source_pgdump_path_on_s3_bucket}"
  })

  provisioner "local-exec" { # save private key locally
    command = "echo '${tls_private_key.ssh_key.private_key_pem}' > ./${var.aws_deploy_ec2_instance_tag_name}.pem"
  }
  provisioner "local-exec" {
    command = "chmod 600 ./'${var.aws_deploy_ec2_instance_tag_name}'.pem"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${tls_private_key.ssh_key.private_key_pem}"
      host        = "${self.public_dns}"
    }
    inline = [
      "echo 'ssh is ready, will copy ssh public keys'",
      "echo '${join("\n", var.ssh_public_keys_list)}' >> ~/.ssh/authorized_keys"
    ]
  }

  provisioner "local-exec" {
    command = "for ssh_key in ${join(" ", var.ssh_public_keys_files_list)}; do cat $ssh_key | ssh -i ./${var.aws_deploy_ec2_instance_tag_name}.pem ubuntu@${self.public_dns} -o StrictHostKeyChecking=no 'cat >> ~/.ssh/authorized_keys'; done"
  }

  provisioner "file" {
    source      = "postgresql_clones_custom.conf"
    destination = "/tmp/postgresql_clones_custom.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${tls_private_key.ssh_key.private_key_pem}"
      host        = "${self.public_dns}"
    }
  }
}
