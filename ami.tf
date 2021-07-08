data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["${var.ami_owner}"]

  filter {
    name   = "name"
    values = ["${var.dle_ami_name}"]
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
