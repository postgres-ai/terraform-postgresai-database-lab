variable "dle_ami_name" {
    description = "Filter to be used to find a Database Lab AMI by name"
    default = "DBLABserver"
}

variable "dle_version_short" {
   description = "2-digit DLE version (major version)"
   default = "2.3"
}

variable "dle_version_full" {
   description = "3-digit DLE version (2-digit major + minor)"
   default = "2.3.1"
}

variable "aws_region" {
  description = "AWS Region"
  default = "us-east-1"
}

variable "ami_owner" {
    description = "Filter for the AMI owner"
    default = "self"
}
variable "instance_type" {
    description = "Type of EC2 instance"
    default = "t2.micro"
}

variable "keypair" {
    description = "Key pair to access the EC2 instance"
    default = "default"
}

variable "allow_ssh_from_cidrs" {
    description = "List of CIDRs allowed to connect to SSH"
    default = ["0.0.0.0/0"]
}

variable "allow_api_from_cidrs" {
    description = "List of CIDRs allowed to connect to API"
    default = ["0.0.0.0/0"]
}

variable "tag_name" {
    description = "Value of the tags Name to apply to all resources"
    default = "DBLABserver"
}

variable "dns_zone_name" {
    description = "The Route53 hosted zone where the DLE will be managed"
    default = "aws.postgres.ai"
}

variable "dns_api_subdomain" {
    description = "The Hosted zone subdomain that will point to the DLE API"
    default = "demo-api"
}

variable "availability_zone" {
   description = "AZ for EBS volumes"
   default = "us-east-1a"
}

variable "ebs_size" {
   description = "The size (GiB) for data volumes used by DLE"
   default = "1"
}

variable "ebs_type" {
   description = "EBS volume type used by DLE"
   default="gp2"
}

variable "ec2_ebs_names" {
  description = "List of paths for EBS volumes mounts"
  default = [
    "/dev/xvdf",
    "/dev/xvdg",
  ]
}

variable "postgres_source_dbname" {
  description = "Source database name"
  default="dbname"
}

variable "postgres_source_host" {
  description = "Source database host"
  default="localhost"
}

variable "postgres_source_port" {
  description = "Source database port"
  default="5432"
}

variable "postgres_source_username" {
  description = "Source database username"
  sensitive   = true
}

variable "postgres_source_password" {
  description = "Source database password"
  sensitive   = true
}

variable "postgres_source_version" {
  description = "Source PostgreSQL major version (examples: 9.6, 11, 14)"
  default="13"
}

variable "dle_token" {
  description = "DLE verification token"
  default = "_token_"
}

variable "dle_debug" {
  description = "DLE debug mode"
  default = "false"
}

variable "dle_retrieval_refresh_timetable" {
  description = "DLE logical refresh timetable"
  default = "0 0 * * 0"
}
