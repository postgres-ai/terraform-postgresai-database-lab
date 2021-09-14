# Database Lab Terraform Module

This [Terraform Module](https://www.terraform.io/docs/language/modules/index.html) is responsible for deploying the [Database Lab Engine](https://gitlab.com/postgres-ai/database-lab) to cloud hosting providers.

Your source PostgreSQL database can be located anywhere, but DLE with other components will be created on an EC2 instance under your AWS account. Currently, only "logical" mode of data retrieval (dump/restore) is supported – the only available method for managed PostgreSQL cloud services such as RDS Postgres, RDS Aurora Postgres, Azure Postgres, or Heroku. "Physical" mode is not yet supported, but it will be in the future. More about various data retrieval options for DLE: https://postgres.ai/docs/how-to-guides/administration/data.

## Supported Cloud Platforms
- AWS

## Installation

Follow the [how-to guide](https://postgres.ai/docs/how-to-guides/administration/install-database-lab-with-terraform) to install Database Lab with Terraform on AWS

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

