## Observability Hub

# Table of Contents
- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Repository Structure](#repository-structure)
- [Useful Resources](#useful-resources)

## Introduction

This repository includes the [Terraform](https://www.terraform.io/) to provision and manage infrastructure and services on AWS that are used in the Observability Hub. No PII or customer specific data is in this repository.

## Overview of Projects

[Elastic](./elastic) - This project deploys the Elastic Agent on an EC2 instance with permissions to read from application AWS accounts and send data to an Elastic Cloud SaaS tenant.

[Dynatrace](./dynatrace) - This project deploys the Dynatrace ActiveGate on an EC2 instance with permissions to read from application AWS accounts and send data to an Dynatrace Cloud SaaS tenant.

[Grafana](./grafana) - This project deploys Grafana Enterprise edition on an EC2 instance.

## Repository Structure

```bash
.
|-- README.md
`-- dynatrace
`-- elastic
`-- grafana
`  -- aws-cdk-grafana
`  -- aws-terraform-grafana
`-- images
```


## Windows Subsystem for Linux Version 2 (WSL2)

Windows Subsystem for Linux (WSL) is a feature of Microsoft Windows that allows developers to run a Linux environment without the need for a separate virtual machine or dual booting.

In a Windows command prompt (cmd):

```bash
wsl
cd ~/github/observability-hub/
code .
```

### WSL2 date incorrect after waking from sleep

If your development computer is left to sleep, the AWS CLI command may return errors if the system time deviates more than 15 minutes from the actual time.

* Leave the Windows system untouched until it goes to sleep.
* Wait for a while, say an hour.
* Wake up the computer, and type "date" in WSL 2 shell

Steps to fix:
* `exit` in the cmd shell to exit wsl shell
* `wsl --shutdown` to shutdown wsl
* `wsl` to restart

## Terraform on AWS

### Installing Terraform with AWS CloudShell

* Signin to the AWS Management Console
* Open CloudShell

Follow the [Terraform installation instructions for Amazon Linux](https://developer.hashicorp.com/terraform/install).

```bash
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform --version
terraform init
```

### Example Terraform commands to deploy AWS resources

Change to the Terraform folder for a project.

```bash
cd dynatrace/aws-terraform/
cd elastic/aws-terraform/
cd grafana/aws-terraform/
```

Run the Terraform commands below for the AWS environment that you are deploying to.

#### NCS Environment - 851725631136

```bash
terraform fmt -recursive
terraform plan -out=tfplan --var-file=./environments/ncs-851725631136.tfvars
terraform apply tfplan
terraform destroy --var-file=./environments/ncs-851725631136.tfvars
```

#### NCS Environment - 730335216569

```bash
terraform fmt -recursive
terraform plan -out=tfplan --var-file=./environments/ncs-730335216569.tfvars
terraform apply tfplan
terraform destroy --var-file=./environments/ncs-730335216569.tfvars
```

#### GNP Environment

```bash
terraform fmt -recursive
terraform plan -out=tfplan --var-file=./environments/gnp-851725214198.tfvars
terraform apply tfplan
terraform apply -replace tfplan
terraform destroy --var-file=./environments/gnp-851725214198.tfvars
```

## Create Graph

Install dot

```bash
sudo apt install graphviz
```

Create a graph of the plan

```bash
terraform plan -out=tfplan --var-file=./environments/ncs-851725631136.tfvars
terraform graph -plan=tfplan -type=plan | dot -Tpng >../images/grafana-terraform-plan.png
```


## Terraform Commands

In your project folder, run the Terraform commands.

| Command | Description |
| -- | -- |
| [terraform init](https://developer.hashicorp.com/terraform/cli/commands/init) [options] | Initializes a working directory containing Terraform configuration files |
| [terraform fmt](https://developer.hashicorp.com/terraform/cli/commands/fmt) [options] [target...] | Used to rewrite Terraform configuration files to a canonical format and style |
| [terraform validate](https://developer.hashicorp.com/terraform/cli/commands/validate) [options] | Validates the configuration files in a directory |
| [terraform plan -out=tfplan](https://developer.hashicorp.com/terraform/cli/commands/plan) [options] | Creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure |
| [terraform apply "tfplan"](https://developer.hashicorp.com/terraform/cli/commands/apply) [options] [plan file] | Executes the actions proposed in a Terraform plan |
| [terraform show](https://developer.hashicorp.com/terraform/cli/commands/show) | Provides human-readable output from a plan file |
| [terraform state list](https://developer.hashicorp.com/terraform/cli/commands/state/list) [options] [address...] | Used to list resources within a Terraform state |
| [terraform destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy) [options] | Destroys all remote objects managed by a particular Terraform configuration |

### Deploying Grafana with Terraform

```bash
cd grafana\aws-terraform-grafana
terraform init
terraform plan
```

## Firewall Requirements

| Application | Package | Repository |
| -- | -- | -- |
| Grafana Enterprise | grafana-enterprise | https://rpm.grafana.com |

## AWS Marketplace License

| Product | Repository |
| -- | -- |
| CIS Amazon Linux 2 Kernel 4.14 Benchmark - Level 1 | https://aws.amazon.com/marketplace/pp/prodview-5ihz572adcm7i |

# Useful Resources

* [AWS Security Hub - Bootstrap and Operationalization](https://github.com/aws-samples/aws-security-services-with-terraform/blob/master/aws-security-hub-boostrap-and-operationalization/README.md)
* [AWS Terraform Workshop](https://github.com/aws-samples/terraform-sample-workshop/blob/main/module_1/one_file_tf/simple_nginx_stack/vars.tf)

# AWS PrivateLink

| Service | Interface endpoint | Description |
| -- | -- | -- |
| AWS Systems Manager | com.amazonaws.ap-southeast-2.ssm | The endpoint for the Systems Manager service. |
| AWS Systems Manager | com.amazonaws.ap-southeast-2.ec2messages | Systems Manager uses this endpoint to make calls from SSM Agent to the Systems Manager service. |
| AWS Systems Manager | com.amazonaws.ap-southeast-2.ssmmessages | For connecting to your instances through a secure data channel using Session Manager. |
|Amazon EC2 | com.amazonaws.ap-southeast-2.ec2 | The endpoint for the EC2 service. |
| AWS Key Management Service (AWS KMS) | com.amazonaws.ap-southeast-2.kms | To use AWS KMS encryption for Session Manager or Parameter Store parameters. |
| Amazon CloudWatch Logs | com.amazonaws.ap-southeast-2.logs | To use Amazon CloudWatch Logs (CloudWatch Logs) for Session Manager, Run Command, or SSM Agent logs. |
| Amazon Elastic Filesystem (EFS) | com.amazonaws.ap-southeast-2.monitoring | To use EFS for persistant storage across EC2 instances. |
| AWS Secrets Manager | com.amazonaws.ap-southeast-2.secretsmanager | To use Secrets Manager for creating and reading secrets. |
| Amazon Simple Notification Service | com.amazonaws.ap-southeast-2.sns | To use SNS for publishing and subscribing to event notifications. |
| Amazon S3 | com.amazonaws.ap-southeast-2.s3 | Systems Manager uses this endpoint to update SSM Agent and to perform patching operations. |

## Testing VPC Endpoints

1. Connect to an Amazon EC2 instance that resides in your VPC.
2. Create a JSON file with a log event. The timestamp must be specified as the number of milliseconds after Jan 1, 1970 00:00:00 UTC.
```json
[
  {
    "timestamp": 1533854071310,
    "message": "VPC Connection Test"
  }
]
```
3. Use the put-log-events command to create the log entry. If the response to the command includes nextSequenceToken, the command has succeeded and your VPC endpoint is working.
```bash
aws logs put-log-events --log-group-name LogGroupName --log-stream-name LogStreamName --log-events file://JSONFileName
```

## Controlling access to VPC endpoints

### Amazon Cloudwatch

```
{
  "Statement": [
    {
      "Sid": "PutOnly",
      "Principal": "*",
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
```

# Elastic File System

You must configure the following rules in the security groups:
* The security groups that you associate with a mount target must allow inbound access for the TCP protocol on the NFS port from all EC2 instances on which you want to mount the file system.
* Each EC2 instance that mounts the file system must have a security group that allows outbound access to the mount target on the NFS port.

# AWS Systems Manager

Default Host Management Configuration allows Systems Manager to manage your Amazon EC2 instances automatically. After you've turned on this setting, all instances using Instance Metadata Service Version 2 (IMDSv2) in the AWS Region and AWS account with SSM Agent version 3.2.582.0 or later installed automatically become managed instances.

[Configure instance permissions required for Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-instance-permissions.html)

# Patching

Using AWS Systems Manager - Using Quick Setup patch policies (defined by Vache Abram)

# Backup

Backup - Using AWS Backup in the Observability Hub AWS account (defined by Vache Abram)

# TODO List

## Development Tasks

* Automate this Marketplace subscription acceptance for using the EC2 RHEL license or cross account share the license with AWS license manager
* Firewall burn for grafana enterprise packages
  * https://rpm.grafana.com
* Patching - Using AWS Systems Manager - Using Quick Setup patch policies (defined by Vache Abram)
* Backup - Using AWS Backup in the Observability Hub AWS account (defined by Vache Abram)
* Real values for resource tags
* Remove public IP from Grafana EC2
* Mount Grafana EFS to EC2
* Use Secrets Manager for Grafana admin
* Change subnets reference to use a module (module.vpc.public_subnets)
* Change vpc to use a module (module.vpc.vpc_id)
* Review names of resources with "${var.ec2_name_prefix}"
* Grafana should go in private EC2 instance - https://repost.aws/knowledge-center/ec2-systems-manager-vpc-endpoints
* ~~Encrypt Grafana EFS~~
* ~~[Fix default tags not picking up](https://support.hashicorp.com/hc/en-us/articles/4406026108435-Known-issues-with-default-tags-in-the-Terraform-AWS-Provider-3-38-0-4-67-0)~~

# SSO
* OU Sync - AWS to Azure
* IdP initiated SAML - Azure AD
  * Need to domain join box - if 
  * SAML if not needed

* private DNS, go via zcsaler, setup internal DNS
* ACM+ALB+route53 - https, private facing
  * Manesh - one DNS record to authenicate certicate, CENSE request, GNP domain
  * Dominic - created DNS solution, need to send to Manesh

* email - raise internally with office365, SES, service Now (enterprise)
  * need to/from address


## Project Tasks
* How will users will login to Grafana over a private ip?
* Dynatrace agents on-premise networking to Dynatrace SaaS
  * optus.com.au ActiveGate on on-premise needs to point to new cluster on Dynatrace SaaS
* Dynatrace SSO tenants
  1. Current GNP tenant
  2. Current Production (PRD) tenant
  3. PMX GNP (will merge to Non-production in Jun-25)
  4. PMX Production (will merge to Production in Jun-25)
* Renaissance/Tel will test Elastic, OTEL
* ServiceNow integration - SaaS instances to connect
* Production readiness
* elastic users login in to on-permise and SaaS - should be seamless
* Integrate PMX 4 GNP accounts - will use Elastic for logs and Dynatrace for metrics

* Testing in Obserability Hub accounts
  * IAM permissions
  * Networking
  * Firewall
  * Alerting

# Outstanding Optus tasks
* SSO access to Grafana
* SSO access to Dynatrace SaaS
* SSO access to Elastic SaaS
* Private access to Grafana web application
* Email access for Elastic SaaS

# What is needed to go to production?
* How to deploy in production? Automatic or manual deployments
* IAM scoping
* Testing, testing, testing
  * Networking
  * Performance

## TODO
* ECS or EC2 - hardend images, Linux2 and RHEL
* AMI - Milind knows how to build AMIs
  * Needs to be part of a scan process - Cyber

1. Technical aspect - AWS account, change approvals, additional step (change approval board - CAB)
* Day 2 support - Ross
* Todo - kick off SRA process - scan the environment
* SRB - TODO - ask Oscar where this is?
* ARB - is this needed - one month
* Test plans, monitoring by design - 
* Service Now - requests numbers
* Forward proxy going through this now with Micahel Le Page - SIEM certifate, 2 months+
* Deployment via an admin user - terraform
* Change processes - Michel and Oskar - different team to team
* Nexus repository or internet - cyber process - Optus confluence
  * Firewall burn - change Michel Williams / Michel + Oskar

2. NCS modernization
* September to Optus
* 


# Questions

* Are there any requirements for [Controlling Access to Services with VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints-access.html)?

# Blockers

## AWS IAM Blockers
* IAM permissions required to accept the CIS Amazon Linux 2 Kernel 4.14 Benchmark - Level 1 subscription 
  * aws-marketplace:ViewSubscriptions
* IAM permissisions to create an Amazon EC2 autoscaling group - for grafana
  * autoscaling:Describe*
* IAM permissions boundary for CloudTrail
  * cloudtrail:DescribeTrails
  * cloudtrail:ListChannels
  * cloudtrail:LookupEvents
  * cloudtrail:ListEventDataStores
  * config:DescribeConfigurationRecorderStatus

## Moving to Production account - Meeting with Madhukar Valiveti and Jackson Edwards
* Controls are onboarded
* Account itself for checklist
* Solution design walk through
* Scope of solution - controls that have been on-boarded
* Provisioning of the cloud account - need to sign-off on this
* Checklist of controls
  * SRA - IT observability account
  * Dynatrace and Elastic - SRA - UAM permission request for SaaS access
  * CSPM for SIEM
    * CloudTrail logs are centralized - infra access logs
    * CloudWatch logs from applications
      * Two options - S3 buckets or agent can collect from SIEM
* Observability Hub hosts aggregators for logs and metrics
* OH account will interact with other AWS accounts
* Ready for PMX by October
* Passed data governance, ARB, CMDB, Application Management 
  * Small remaining on data privacy
* Cloud account
  * CSPM (Palo Alto)
  * Application logging with SIEM
  * No code scanning
* Penetration cloud accounts
  * Cat 1 and Cat 2 need pen testing
* SRA filling out section under the sun
* Admin role access goes to PIAM
