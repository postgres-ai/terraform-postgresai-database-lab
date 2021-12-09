dle_version = "master"
joe_version = "0.10.0"

aws_ami_name = "DBLABserver*"

aws_deploy_region = "us-east-1"
aws_deploy_ebs_availability_zone = "us-east-1a"
aws_deploy_ec2_instance_type = "c5.large"
aws_deploy_ec2_instance_tag_name = "dmitry-DBLABserver-ec2instance"
aws_deploy_ebs_size = "40"
aws_deploy_ebs_type = "gp2"
aws_deploy_allow_ssh_from_cidrs = ["0.0.0.0/0"]
aws_deploy_dns_api_subdomain = "dmitry-tf-test" # subdomain in aws.postgres.ai, fqdn will be ${dns_api_subdomain}.aws.postgres.ai

source_postgres_version = "13"
source_postgres_host = "ec2-3-215-57-87.compute-1.amazonaws.com"
source_postgres_port = "5432"
source_postgres_dbname = "d3dljqkrnopdvg" # this is an existing DB (Heroku example DB)
source_postgres_username = "bfxuriuhcfpftt" # in secret.tfvars, use:   source_postgres_password = "dfe01cbd809a71efbaecafec5311a36b439460ace161627e5973e278dfe960b7" 

dle_debug_mode = "true"
dle_retrieval_refresh_timetable = "0 0 * * 0"
postgres_config_shared_preload_libraries = "pg_stat_statements,logerrors" # DB Migration Checker requires logerrors extension

platform_project_name = "aws_test_tf"

ssh_public_keys_files_list = ["~/.ssh/id_rsa.pub"]
