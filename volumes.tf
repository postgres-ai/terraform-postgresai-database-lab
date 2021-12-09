resource "aws_volume_attachment" "ebs_att" {
  count = "${length(tolist(var.aws_deploy_ec2_volumes_names))}"
  device_name = "${element(var.aws_deploy_ec2_volumes_names, count.index)}"
  volume_id = "${element(aws_ebs_volume.DLEVolume.*.id, count.index)}"
  instance_id = "${aws_instance.aws_ec2.id}"
  force_detach = true
}

resource "aws_ebs_volume" "DLEVolume" {
  count = "${length(tolist(var.aws_deploy_ec2_volumes_names))}"
  availability_zone = "${var.aws_deploy_ebs_availability_zone}"
  encrypted = "${var.aws_deploy_ebs_encrypted}"
  size  = "${var.aws_deploy_ebs_size}"
  type = "${var.aws_deploy_ebs_type}"
  tags = {
    Name = "DLEVolume"
  }
}
