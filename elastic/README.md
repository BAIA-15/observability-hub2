


* Signin to the AWS Management Console
* Open CloudShell

Follow the [Terraform installation instructions for Amazon Linux](https://developer.hashicorp.com/terraform/install).

```bash
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform --version
```

```bash
mkdir deploy-elastic-agent
cd deploy-elastic-agent
```

Create a main.tf file and paste contents

```
terraform init
terraform fmt
terraform validate
terraform apply
terraform show
terraform state list
terraform destroy
```

## Elastic SaaS Account Team
* Sam Hayward - manages OCS partnership
* Bradley Wu-Byrne - manages NCS partnership
* Sam Harley - ex-Databricks

## Meeting 2024-07-16 - Elastic account team
* Attendees
    * Optus: Michel, Oskar Gaboda
    * Elastic: Sam, Sam
    * NCS: Jacob
* Elastic needs integration with ServiceNow, emails, PagerDuty, SSO
* SSO needs 2FA
* Todo - Mail server for Elastic SaaS to connect to Optus mail server
* Elastic has best practice configuration guide
* Elastic ECU pricing - calculated daily
    * Let Elastic know of any large scale events
* Playbooks for production - backup
* Enterprise discount plan

