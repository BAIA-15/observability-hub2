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
```

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
```
### Terraform Commands

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
cd grafana\terraform
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

# TODO List

* Automate this Marketplace subscription acceptance for using the EC2 RHEL license or cross account share the license with AWS license manager
* Firewall burn for grafana enterprise packages
  * https://rpm.grafana.com
* Patching - Using AWS Systems Manager - Using Quick Setup patch policies (defined by Vache Abram)
* Backup - Using AWS Backup in the Observability Hub AWS account (defined by Vache Abram)
* Real values for resource tags

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


