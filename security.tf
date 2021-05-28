resource "aws_security_group" "dle_instance_sg" {
  ingress {
    cidr_blocks = "${var.allow_ssh_from_cidrs}"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.common_tags}"
}

resource "aws_security_group" "dle_api_sg" {
  ingress {
    cidr_blocks = "${var.allow_api_from_cidrs}"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.common_tags}"
}
