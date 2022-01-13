module "aws" {
  source                  = "./modules/aws"
  count                   = contains(var.clouds, "aws") ? 1 : 0
  network_cidr            = var.network_cidr
  subnet_cidr             = var.subnet_cidr
  acl_rules               = var.acl_rules
  ssh_key                 = var.ssh_key
  naming_suffixes         = var.naming_suffixes
  instance_type           = lookup(var.instance_type, "aws", "t2.micro")
  tags                    = var.tags
}

module "azure" {
  source                  = "./modules/azure"
  count                   = contains(var.clouds, "azure") ? 1 : 0
  network_cidr            = var.network_cidr
  subnet_cidr             = var.subnet_cidr
  acl_rules               = var.acl_rules
  enable_outbound_traffic = var.enable_outbound_traffic
  ssh_key                 = var.ssh_key
  user_data               = lookup(var.user_data, "azure", "")
  naming_suffixes         = var.naming_suffixes
  instance_type           = lookup(var.instance_type, "azure", "Standard_B1s")
  region                  = var.region
  tags                    = var.tags
}

resource "aws_instance" "aws_ec2" {
  ami               = "${data.aws_ami.ami.id}"
  availability_zone = "${var.aws_deploy_ebs_availability_zone}"
  instance_type     = "${var.aws_deploy_ec2_instance_type}"
  security_groups   = ["${aws_security_group.dle_instance_sg.name}"]
  key_name          = aws_key_pair.provision_key.key_name
  tags              = "${local.common_tags}"
  iam_instance_profile = "${var.source_type == "s3" ? "${aws_iam_instance_profile.instance_profile[0].name}" : null}"
}


