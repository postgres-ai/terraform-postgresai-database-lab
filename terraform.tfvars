dle_version_full = "2.4.0"

aws_ami_name = "DBLABserver*"
aws_keypair = "YOUR_AWS_KEYPAIR"

aws_deploy_region = "us-east-1"
aws_deploy_ebs_availability_zone="us-east-1a"
aws_deploy_ec2_instance_type = "t2.large"
aws_deploy_ec2_instance_tag_name = "DBLABserver-ec2instance"
aws_deploy_ebs_size="40"
aws_deploy_ebs_type="gp2"
aws_deploy_allow_ssh_from_cidrs = ["0.0.0.0/0"]
aws_deploy_dns_api_subdomain="tf-test" # subdomain in aws.postgres.ai, fqdn will be ${dns_api_subdomain}-engine.aws.postgres

source_postgres_version="13"
source_postgres_host="ec2-3-215-57-87.compute-1.amazonaws.com"
source_postgres_port="5432"
source_postgres_dbname="d3dljqkrnopdvg"
source_postgres_username="postgres"

dle_debug_mode="true"
dle_retrieval_refresh_timetable="0 0 * * 0"
postgres_config_shared_preload_libraries="pg_stat_statements"

platform_project_name="aws_test_tf"
