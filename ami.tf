data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["${var.ami_owner}"]

  filter {
    name   = "name"
    values = ["${format("%s-%s*", var.dle_ami_name, var.dle_version_full)}"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
