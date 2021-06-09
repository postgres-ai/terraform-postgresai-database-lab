data "template_file" "init" {
  template = "${file("dle-logical-init.sh.tpl")}"
  vars = {
    dle_token = "${var.dle_token}"
    dle_debug = "${var.dle_debug}"
    dle_timetable = "${var.dle_timetable}"
    dle_disks = "${join(" ",var.ec2_ebs_names)}"
    dle_version_short = "${var.dle_version_short}"
    postgres_source_dbname = "${var.postgres_source_dbname}"
    postgres_source_host = "${var.postgres_source_host}"
    postgres_source_port = "${var.postgres_source_port}"
    postgres_source_username = "${var.postgres_source_username}"
    postgres_source_password = "${var.postgres_source_password}"
    postgres_source_version = "${var.postgres_source_version}"
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
