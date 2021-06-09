resource "aws_volume_attachment" "ebs_att" {
  count = "${length(tolist(var.ec2_ebs_names))}"
  device_name= "${element(var.ec2_ebs_names, count.index)}"
  volume_id   = "${element(aws_ebs_volume.DLEVolume.*.id, count.index)}"
  instance_id = "${aws_instance.aws_ec2.id}"
}

resource "aws_ebs_volume" "DLEVolume" {
  count = "${length(tolist(var.ec2_ebs_names))}"
  availability_zone = "${var.availability_zone}"
  size  = "${var.ebs_size}"
  type="${var.ebs_type}"
  tags = {
    Name = "DLEVolume"
  }
}
