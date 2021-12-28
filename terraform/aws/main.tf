terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_deploy_region}"
}

locals {
  common_tags = {
    Name = "${var.aws_deploy_ec2_instance_tag_name}"
  }
}
