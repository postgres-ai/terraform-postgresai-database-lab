[[_TOC_]]

# How to setup Database Lab using Terraform in AWS

This [Terraform Module](https://www.terraform.io/docs/language/modules/index.html) is responsible for deploying the [Database Lab Engine](https://gitlab.com/postgres-ai/database-lab) to cloud hosting providers.

Your source PostgreSQL database can be located anywhere, but DLE with other components will be created on an EC2 instance under your AWS account. Currently, only "logical" mode of data retrieval (dump/restore) is supported – the only available method for managed PostgreSQL cloud services such as RDS Postgres, RDS Aurora Postgres, Azure Postgres, or Heroku. "Physical" mode is not yet supported, but it will be in the future. More about various data retrieval options for DLE: https://postgres.ai/docs/how-to-guides/administration/ata.

## Supported Cloud Platforms:
- AWS

## Prerequisites
- [AWS Account](https://aws.amazon.com)
- [Terraform Installed](https://learn.hashicorp.com/tutorials/terraform/install-cli) (minimal version: 1.0.0)
- AWS [Route 53](https://aws.amazon.com/route53/) Hosted Zone (For setting up TLS) for a domain or sub-domain you control
- You must have AWS Access Keys and a default region in your Terraform environment (See section on required IAM Permissions)
- The DLE runs on an EC2 instance which can be accessed using a selected set of SSH keys uploaded to EC2. Use the Terraform parameter `aws_keypair` to specify which EC2 Keypair to use
- Required IAM Permissions: to successfully run this Terraform module, the IAM User/Role must have the following permissions:
    * Read/Write permissions on EC2
    * Read/Write permissions on Route53
    * Read/Write permissions on Cloudwatch

## How to use
- It is recommended to clone this Git repository and adjust for your needs. Below we provide the detailed step-by-step instructions for quick start (see "Quick start") for a PoC setup
- To configure parameters used by Terraform (and the Database Lab Engine itself), you will need to modify `terraform.tfvars` and create a file with secrets (`secret.tfvars`)
- This Terraform module can be run independently or combined with any other standard Terraform module. You can learn more about using Terraform and the Terraform CLI [here](https://www.terraform.io/docs/cli/commands/index.html)
- The variables can be set in multiple ways with the following precedence order (lowest to highest):
    - default values in `variables.tf`
    - values defined in `terraform.tfvars`
    - values passed on the command line
- All variables starting with `postgres_` represent the source database connection information for the data (from that database) to be fetched by the DLE. That database must be accessible from the instance hosting the DLE (that one created by Terraform)

## Quick start
The following steps were tested on Ubuntu 20.04 but supposed to be valid for other Linux distributions without significant modification.

1. SSH to any machine with internet access, it will be used as deployment machine
1. Install Terraform  https://learn.hashicorp.com/tutorials/terraform/install-cli. Example for Ubuntu:
    ```shell
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl 
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"  # Adjust if you have ARM platform.
    sudo apt-get update && sudo apt-get install terraform
    # Verify installation.
    terraform -help
    ```
1. Get TF code for Database Lab:
    ```shell
    git clone https://gitlab.com/postgres-ai/database-lab-infrastructure.git
    cd database-lab-infrastructure/
    ```
1. Edit `terraform.tfvars` file. In our example, we will use Heroku demo database as a source:
    ```config
    dle_version_full = "2.4.1"

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
    ```
1. Create `secret.tfvars` containing `source_postgres_password`, `platform_access_token`, and `vcs_github_secret_token`. An example:
    ```config
    source_postgres_password="YOUR_DB_PASSWORD" # todo: put pwd for heroku example DB here
    platform_access_token="YOUR_ACCESS_TOKEN"   # to generate, open https://console.postgres.ai/, choose your organization,
                                                # then "Access tokens" in the left menu
    vcs_github_secret_token="vcs_secret_token"  # to generate, open https://github.com/settings/tokens/new
    ```
1. Initialize
    ```shell
    terraform init
    ```
1. Set environment variables with AWS credentials:
    ```shell
    export AWS_ACCESS_KEY_ID="keyid"  # todo: how to get it?
    export AWS_SECRET_ACCESS_KEY="accesskey"
    ```
1. Deploy:
    ```
    terraform  apply -var-file="secret.tfvars" -auto-approve
    ```
1. If everything goes well, you should get an output like this:
    ```config
    vcs_db_migration_checker_verification_token = "gsio7KmgaxECfJ80kUx2tUeIf4kEXZex"
    dle_verification_token = "zXPodd13LyQaKgVXGmSCeB8TUtnGNnIa"
    ec2_public_dns = "ec2-18-118-126-25.us-east-2.compute.amazonaws.com"
    ec2instance = "i-0b07738148950af25"
    ip = "18.118.126.25"
    platform_joe_signing_secret = "lG23qZbUh2kq0ULIBfW6TRwKzqGZu1aP"
    public_dns_name = "demo-api-engine.aws.postgres.ai"  # todo: this should be URL, not hostname – further we'll need URL, with protocol – `https://`
    ```

1. To verify result and check the progress, you might want to connect to the just-created EC2 machine using IP address or hostname from the terraform output. In our example, it can be done using this one-liner (you can find more about DLE logs and configuration on this page: https://postgres.ai/docs/how-to-guides/administration/engine-manage):
    ```shell
    echo "sudo docker logs dblab_server -f" | ssh ubuntu@18.118.126.25 -i postgres_ext_test.pem
    ```

    Once you see the message like:
    ```
    2021/07/02 10:28:51 [INFO]   Server started listening on :2345.
    ```
    – it means that the DLE server started successfully and is waiting for you commands

 1. Sign in to the [Postgres.ai Platform](https://console.postgres.ai/) and register your new DLE server:
     1. Go to `Database Lab > Instances` in the left menu
     1. Press the "Add instance" button
     1. `Project` – specify any name (this is how your DLE server will be named in the platform)
     1. `Verification token` – use the token generated above (`verification_token` value); do NOT press the "Generate" button here
     1. `URL` – use the value generated above // todo: not convenient, we need URL but reported was only hostname
     1. Press the "Verify URL" button to check the connectivity. Then press "Add". If everything is right, you should see the DLE page with green "OK" status:
    <img src="/uploads/8371e7f79de199aa017ff2df82b8f704/image.png" width="400" />
 1. Add Joe chatbot for efficient SQL optimization workflow:
    1. Go to the "SQL Optimization > Ask Joe" page using the left menu, click the "Add instance" button, specify the same project as you defined in the previous step
    1. `Signing secret` – use `platform_joe_signing_secret` from the Terraform output
    1. `URL` – use `public_dns_name` values from the Terraform output with port `444`; in our example, it's `https://demo-api-engine.aws.postgres.ai:444`
    1. Press "Verify URL" to check connectivity and then press "Add". You should see:
    <img src="/uploads/252e5f74cd324fc4df301bbf7c2bdd25/image.png" width="400" />

    Now you can start using Joe chatbot for SQL execution plans troubleshooting and verification of optimization ideas. As a quick test, go to `SQL Optimization > Ask Joe` in the left menu, and enter `\dt+` command (a psql command to show the list of tables with sizes). You should see how Joe created a thin clone behind the scenes and immediately ran this psql command, presenting the result to you:
    <img src="/uploads/d9e9e1fdafb0ded3504691cec9018868/image.png" width="400" />

1. TODO: CI checker  !!!!!!

1. Install and try the client CLI (`dblab`)
    1. TODO: install CLI !!!!!
    1. Initialize CLI:
    ```shell
    dblab init --environment-id=<ANY NAME FOR ENVIRONMENT> --url=https://<public_dns_name> --token=<your_personal_token_from_postgres_ai_platform>
    ```
    1. Try it:
    ```shell
    dblab instance status
    ```
    It should return the OK status:
    ```json
    {
        "status": {
            "code": "OK",
            "message": "Instance is ready"
        },
        ...
    }
    ```

## Important Note
When the DLE creates new database clones, it makes them available on incremental ports in the 6000 range (e.g. 6000, 6001, ...). The DLE CLI will also report that the clone is available on a port in the 6000 range.  However, please note that these are the ports when accessing the DLE from `localhost`.  This Terraform module deploys [Envoy](https://www.envoyproxy.io/) to handle SSL termination and port forwarding to connect to DLE generated clones.

Bottom Line: When connecting to clones, add `3000` to the port number reported by the DLE CLI to connect to the clone. for example, if the CLI reports that a new clone is available at port `6001` connect that clone at port `9001`.

## Known Issues
### Certificate Authority Authorization (CAA) for your Hosted Zone
Depending on your DNS provider and configuration, you may need to create a CAA record in your hosted zone.vOn instance creation, this Terraform module will use [Let's Encrypt](https://letsencrypt.org/) to generate a valid SSL Certificate. For that to succeed, Let's Encrypt must be recognized as a valid issuing CA by your domain.  To do this, add a DNS record that looks like this:

```
Domain Record  type  Value
example.com.   CAA   0 issue "letsencrypt.org"
```

## Troubleshooting
You can get help deploying the DLE. Here are two great ways to do this:
- Join the [Database Lab Community Slack](https://database-lab-team.slack.com)
- Reach out to the Postgres.ai team on [Intercom chat widget](https://postgres.ai/) (located at the bottom right corner)

## Reporting Issues & Contributing
We want to make deploying and managing the Database Lab Engine as easy as possible! Please report bugs
and submit feature ideas using Gitlab's [Issue feature](https://gitlab.com/postgres-ai/database-lab-infrastructure/-/issues/new).

