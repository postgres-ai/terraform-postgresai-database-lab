/**
 * This file sets up all resources necessary to accept inbound
 * HTTPS requests to the DLE API and direct them to the DLE
 * instance itself.
 *
 * It uses an AWS Application Load Balancer to terminate SSL
 * requests and then forward HTTP traffic to the DLE instance.
 */

# Create the Load Balancer for only the main DLE API
resource "aws_lb" "dle_api_lb" {
  name               = "dle-api-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dle_api_sg.id]

  subnets            = data.aws_subnet_ids.dle_vpc_subnets.ids
  tags               = "${local.common_tags}"
}

# Setup an HTTPS listener that will terminate SSL
resource "aws_lb_listener" "dle_api_ssl_listener" {
  load_balancer_arn = aws_lb.dle_api_lb.arn

  port              = 80
  protocol          = "HTTP"

  # FIXME -- Need to have Domain and Certificate in ACM
  # port              = 443
  # protocol          = "HTTPS"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = aws_acm_certificate.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_target_group.arn
  }

  tags = "${local.common_tags}"
}

# The target group defines how the Load Balancer should
# forward incoming requests and also sets up a health
# check on the target instance.
resource "aws_lb_target_group" "api_target_group" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.dle_vpc.id

  health_check {
    path                = "/healthz"
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.dle_api_lb
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = "${local.common_tags}"
}

# This makes the connection between the Target Group and the
# actual DLE EC2 Instance itself.
resource "aws_lb_target_group_attachment" "dle_instance_attachment" {
  target_group_arn = aws_lb_target_group.api_target_group.arn
  target_id        = aws_instance.aws_ec2.id
  port             = 80
}
