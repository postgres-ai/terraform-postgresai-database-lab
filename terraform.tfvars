dle_version = "master"  # it is also possible to use branch name here (e.g., "master")
joe_version = "0.10.0"

aws_ami_name = "DBLABserver*"

aws_deploy_region = "us-east-1"
aws_deploy_ebs_availability_zone = "us-east-1a"
aws_deploy_ec2_instance_type = "c5.large"
aws_deploy_ec2_instance_tag_name = "dmitry-DBLABserver-ec2instance"
aws_deploy_ebs_size = "10"
aws_deploy_ebs_type = "gp2"
aws_deploy_ec2_volumes_count = "2"
aws_deploy_allow_ssh_from_cidrs = ["0.0.0.0/0"]
aws_deploy_dns_api_subdomain = "dmitry-tf-test" # subdomain in aws.postgres.ai, fqdn will be ${dns_api_subdomain}.aws.postgres.ai

source_postgres_version = "13"

dle_debug_mode = "true"
dle_retrieval_refresh_timetable = "0 0 * * 0"
postgres_config_shared_preload_libraries = "pg_stat_statements,logerrors" # DB Migration Checker requires logerrors extension

platform_project_name = "aws_test_tf"

source_type = "s3" # source is dump stored on demo s3 bucket
source_pgdump_s3_bucket = "tf-demo-dump" # This is an example public bucket
source_pgdump_path_on_s3_bucket = "heroku_sql.sql" # This is an example dump from demo database

# Edit this list to have all public keys that will be placed to 
# have them placed to authorized_keys. Instead of ssh_public_keys_files_list,
# it is possible to use ssh_public_keys_list containing public keys as text values.
ssh_public_keys_files_list = ["~/.ssh/id_rsa.pub"]
ssh_public_keys_list = [
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhbblazDXCFEc21DtFzprWC8DiqidnVRROzp6J6BeJR9+XydPUtl0Rt2mcNvxL5ro5bI9u5JRW8aDd6s+Orpr66hEDdwQTbT1wp5nyduFQcT3rR+aeDSilQvAHjr4/z/GZ6IgZ5MICSIh5hJJagHoxAVqeS9dCA27tv/n2T2XrxIUeBhywH1EmfwrnEw97tHM8F+yegayFDI1nVOUWUIxFMaygMygix8uKbQ2fl4rkkxG2oEx7uyAFMXHt4bewNbZuAp8b/b5ODL6tGHuHhcwfbWGriCO+l7UOf1K9maTx00o4wkzAPyd+qs70y/1iMX2YOOLYaYYdptEnFal2DVoD example@example.com"
]
