variable "aws_ami_name" {
    description = "Filter to be used to find a Database Lab AMI by name"
    default = "DBLABserver"
}

variable "dle_version_full" {
   description = "3-digit DLE version (2-digit major + minor)"
   default = "2.4.1"
}

variable "aws_deploy_region" {
  description = "AWS Region"
  default = "us-east-1"
}

variable "aws_ami_owner" {
    description = "Filter for the AMI owner"
    default = "self"
}
variable "aws_deploy_ec2_instance_type" {
    description = "Type of EC2 instance"
    default = "t2.micro"
}

variable "aws_keypair" {
    description = "Key pair to access the EC2 instance"
    default = "default"
}

variable "aws_deploy_allow_ssh_from_cidrs" {
    description = "List of CIDRs allowed to connect to SSH"
    default = ["0.0.0.0/0"]
}

variable "aws_deploy_allow_api_from_cidrs" {
    description = "List of CIDRs allowed to connect to API"
    default = ["0.0.0.0/0"]
}

variable "aws_deploy_ec2_instance_tag_name" {
    description = "Value of the tags Name to apply to all resources"
    default = "DBLABserver"
}

variable "aws_deploy_dns_zone_name" {
    description = "The Route53 hosted zone where the DLE will be managed"
    default = "aws.postgres.ai"
}

variable "aws_deploy_dns_api_subdomain" {
    description = "The Hosted zone subdomain that will point to the DLE API"
    default = "demo-api"
}

variable "aws_deploy_certificate_email" {
    description = "The admin email address to use when when requesting a certificate from Let's Encrypt"
    default = "m@m.com"
}

variable "aws_deploy_ebs_availability_zone" {
   description = "AZ for EBS volumes"
   default = "us-east-1a"
}

variable "aws_deploy_ebs_size" {
   description = "The size (GiB) for data volumes used by DLE"
   default = "1"
}

variable "aws_deploy_ebs_type" {
   description = "EBS volume type used by DLE"
   default = "gp2"
}

variable "aws_deploy_ec2_volumes_names" {
  description = "List of paths for EBS volumes mounts"
  default = [
    "/dev/xvdf",
    "/dev/xvdg",
    "/dev/xvdh",
  ]
}

variable "source_postgres_dbname" {
  description = "Source database name"
  default = "dbname"
}

variable "source_postgres_host" {
  description = "Source database host"
  default = "localhost"
}

variable "source_postgres_port" {
  description = "Source database port"
  default = "5432"
}

variable "source_postgres_username" {
  description = "Source database username"
  sensitive   = true
}

variable "source_postgres_password" {
  description = "Source database password"
  sensitive   = true
}

variable "source_postgres_version" {
  description = "Source PostgreSQL major version (examples: 9.6, 11, 14)"
  default = "13"
}

variable "dle_verification_token" {
  description = "DLE verification token"
  default = ""
}

variable "dle_debug_mode" {
  description = "DLE debug mode"
  default = "false"
}

variable "dle_retrieval_refresh_timetable" {
  description = "DLE logical refresh timetable"
  default = "0 0 * * *"
}

variable "platform_access_token" {
  description = "Access token generated on Postgres.ai"
}

variable "platform_joe_signing_secret" {
  description = "Joe config App.joe_signing_secret.webui.credentials.signingSecret value"
  default = ""
}

variable "platform_project_name" {
  description = "Joe config App.joe_signing_secret.webui.channels.project value"
  default = "aws_test_tf"
}

variable "vcs_github_secret_token" {
  description = "GitHub token used to automatically check DB migrations in GitHub Actions"
}

variable "postgres_config_shared_preload_libraries" {
  description = "shared_preload_libraries postgresql.conf parameter value for clones"
}

variable "source_type" {
  description = "Type of data source used for DLE. For now it can be postgres or S3"
  default = "postgres"
}

variable "source_pgdump_s3_bucket" {
  description = "S3 bucket name where a dump (created using pg_dump) is stored. This dump will be used as data source. Leave the value empty (default) to use a different source of data."
  default = ""
}

variable "source_pgdump_path_on_s3_bucket" {
  description = "relative path to pg_dump file or directory"
  default = ""
}

variable "source_pgdump_s3_mount_point"{
  description = "mount point on DLE EC2 instance where S3 bucket with the source dump file/directory is mounted to. If pgdump_s3_bucket is empty, pgdump_s3_mount_point is ignored"
  default = "/s3/pg_dump"
}

variable "postgres_dump_parallelJobs"{
  description = "DLE config parallelJobs parameter value"
  default = "2"
}
