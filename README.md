# Database Lab Engine Terraform Module

This [Terraform Module](https://www.terraform.io/docs/language/modules/index.html) is responsible for
deploying the [Database Lab Engine](https://gitlab.com/postgres-ai/database-lab) to cloud hosting
providers.

Supported Cloud Platforms:
* AWS

## Prerequisites
* [AWS Account](https://aws.amazon.com)
* [Terraform Installed](https://learn.hashicorp.com/tutorials/terraform/install-cli) (min version 1.0.0)
* AWS [Route 53](https://aws.amazon.com/route53/) Hosted Zone (For setting up TLS) for a domain or sub-domain you control.

## Setup
* You must have AWS Access Keys and a default region in your Terraform environment (See section on required IAM Permissions).
* The DLE runs on an EC2 instance which can be accessed using a selected set of SSH keys uploaded to EC2.
Use the Terraform parameter `keypair` to specify which EC2 Keypair to use.
* Setup the [Database Lab CLI](https://postgres.ai/docs/guides/cli/cli-install-init)
* To configure parameters used by Terraform (and the Database Lab Engine itself) you should create / modify two variables
files in the root directory of this module.  Examples:

*terraform.tfvars*
```
dle_ami_name = "DBLABserver"
dle_version_short = "2.3"
dle_version_full = "2.3.1"
aws_region = "us-east-2"
instance_type = "t2.large"
keypair = "name_of_keypair"
allow_ssh_from_cidrs = ["0.0.0.0/0"]
tag_name = "Database-Lab"
availability_zone="us-east-2a"
ebs_size="40"
ebs_type="gp2"
postgres_source_dbname="name-of-source-database"
postgres_source_host="postgres-source-hostname"
postgres_source_port="postgres-source-port"
postgres_source_version="13"
dle_debug="true"
dle_retrieval_refresh_timetable="0 0 * * 0"
platform_project_name="database-lab-infra"
dle_url="http\\:\\/\\/demo-api-engine.aws.postgres.ai\\:2345"
```

*secret.tfvars*
```
postgres_source_username="username-goes-here"
postgres_source_password="password-goes-here"
```

## Usage

### Terraform Module
This Terraform module can be run independently or combined with any other standard Terraform module.
You can learn more about using Terraform and the Terraform CLI [here](https://www.terraform.io/docs/cli/commands/index.html).

```
terraform init  # One-time command to setup Terraform
terraform apply -var-file=secret.tfvars # Run Terraform and create the DLE Infrastructure
```

At the end of run, Terraform will return several values that you can use to access the Database Lab Engine and configure
the Database Lab CLI.  Copy down the output for:

```
ip
public_dns_name
dle_verification_token
joe_signing_secret
```

Please note that:

* You can override default parameters (defined in `variables.tf`) either with the CLI or by creating a file called `terraform.tfvars` in the module root directory
* This module currently configures the Database Lab Engine (DLE) to use ["logical" provisioning mode](https://postgres.ai/docs/guides/data/rds) (dump/restore). "Physical" provisioning (copying data directory from the source or fetching it from archives) and other DLE configuration options are planned, but not currently supported by this module.
* All variables starting with `postgres_` represent the database connection information for the data (from that database) to be fetched by the Database Lab Engine. That database must be accessible from the instance hosting the DLE.
* You can view the DLE log by running `sudo docker logs --since 1m -f dblab_server` when ssh'ed to the instance.  See [here](https://postgres.ai/docs/guides/administration/engine-manage#observe-database-lab-engine-logs) for more information.

### Database Lab Engine
Once your EC2 instance is running and the Database Lab Engine (DLE) is deployed, you can learn more about how to use the DLE
on its [documentation site](https://postgres.ai/docs/guides).

Initilize the CLI using output from Terraform run:

```
dblab init --environment-id=<ANY NAME FOR ENVIRONMENT> --url=https://<public_dns_name> --token=<dle_verification_token>
```

Then confirm all is working with `dblab instance status`:

```
{
    "status": {
        "code": "OK",
        "message": "Instance is ready"
    },
    ...
}
```

#### Important Note
When the DLE creates new database clones, it makes them available on incremental ports in the 6000 range (e.g. 6000, 6001, ...).
The DLE CLI will also report that the clone is available on a port in the 6000 range.  However, please note that these are the
ports when accessing the DLE from `localhost`.  This Terraform module deploys [Envoy](https://www.envoyproxy.io/) to handle
SSL termination and port forwarding to connect to DLE generated clones.

Bottom Line: When connecting to clones, add `3000` to the port number reported by the DLE CLI to connect to the clone.
for example, if the CLI reports that a new clone is available at port `6001` connect that clone at port `9001`.

## Required IAM Permissions
To successfully run this Terraform module, the IAM User/Role must have the following permissions:

* Read/Write permissions on EC2
* Read/Write permissions on Route53
* Read/Write permissions on Cloudwatch

## Known Issues
#### Certificate Authority Authorization (CAA) for your Hosted Zone
Depending on your DNS provider and configuration, you may need to create a CAA record in your hosted zone.
On instance creation, this Terraform module will use [Let's Encrypt](https://letsencrypt.org/) to generate
a valid SSL Certificate. For that to succeed, Let's Encrypt must be recognized as a valid issuing CA by
your domain.  To do this, add a DNS record that looks like this:

```
Domain Record  type  Value
example.com.   CAA   0 issue "letsencrypt.org"
```

## Troubleshooting
You can get help deploying the DLE.  Here are two great ways to do this:

* Join the [Database Lab Community Slack](https://database-lab-team.slack.com)
* Reach out to the Postgres.ai team on [Intercom chat widget](https://postgres.ai/) (located at the bottom right corner)

## Reporting Issues & Contributing
We want to make deploying and managing the Database Lab Engine as easy as possible!  Please report bugs
and submit feature ideas using Gitlab's [Issue feature](https://gitlab.com/postgres-ai/database-lab-infrastructure/-/issues/new).

