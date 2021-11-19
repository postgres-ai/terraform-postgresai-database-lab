
resource "aws_security_group" "dle_instance_sg" {
  tags = "${local.common_tags}"
}

resource "aws_security_group_rule" "dle_instance_ssh" {
  security_group_id = aws_security_group.dle_instance_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.aws_deploy_allow_ssh_from_cidrs}"
}

resource "aws_security_group_rule" "dle_products" {
  # Ports:
  # 443 - dle_instance_api
  # 444 - joe_bot_api
  # 445 - ci_observer_api
  # 446 - dle_local_ui
  security_group_id         = aws_security_group.dle_instance_sg.id
  type                      = "ingress"
  from_port                 = 443
  to_port                   = 446
  protocol                  = "tcp"
  cidr_blocks               = "${var.aws_deploy_allow_api_from_cidrs}"
}

resource "aws_security_group_rule" "dle_instance_http_cert_auth" {
  security_group_id         = aws_security_group.dle_instance_sg.id
  type                      = "ingress"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  cidr_blocks               = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "dle_instance_clones" {
  security_group_id = aws_security_group.dle_instance_sg.id
  type              = "ingress"
  from_port         = 9000
  to_port           = 9999
  protocol          = "tcp"
  cidr_blocks       = "${var.aws_deploy_allow_ssh_from_cidrs}"
}

resource "aws_security_group_rule" "dle_instance_egress" {
  security_group_id = aws_security_group.dle_instance_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
