# Aws Amdocs Bitbucket Dev

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ansible_bucket"></a> [ansible\_bucket](#module\_ansible\_bucket) | git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-s3-bucket.git | v1.0.0 |
| <a name="module_ansible_playbook"></a> [ansible\_playbook](#module\_ansible\_playbook) | git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-s3-bucket.git//modules/object | v1.0.0 |
| <a name="module_bitbucket_secret"></a> [bitbucket\_secret](#module\_bitbucket\_secret) | git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-secrets-manager.git | v1.0.0 |
| <a name="module_ec2_instance"></a> [ec2\_instance](#module\_ec2\_instance) | git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-ec2-instance.git | v1.0.0 |
| <a name="module_ec2_sg"></a> [ec2\_sg](#module\_ec2\_sg) | git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-security-group.git | v1.0.0 |
| <a name="module_nlb"></a> [nlb](#module\_nlb) | git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-alb-nlb.git | v1.0.0 |
| <a name="module_nlb_sg"></a> [nlb\_sg](#module\_nlb\_sg) | git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-security-group.git | v1.0.0 |
| <a name="module_rds"></a> [rds](#module\_rds) | git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-aurora.git | v1.0.0 |
| <a name="module_rds_sg"></a> [rds\_sg](#module\_rds\_sg) | git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-security-group.git | v1.0.0 |
| <a name="module_route53"></a> [route53](#module\_route53) | git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-route53.git//modules/records | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.ec2_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [random_password.bitbucket_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.bitbucket_db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.rds_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ec2_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_cert_domain"></a> [acm\_cert\_domain](#input\_acm\_cert\_domain) | Domain of the certificate to use on the NLB TLS Listener. If NULL, NLB will use a TCP Listener instead. | `string` | `null` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID to deploy BitBucket Data Centre on. | `string` | n/a | yes |
| <a name="input_bitbucket_admin_user"></a> [bitbucket\_admin\_user](#input\_bitbucket\_admin\_user) | Details for the admin user in BitBucket. | `map(string)` | n/a | yes |
| <a name="input_bitbucket_installer"></a> [bitbucket\_installer](#input\_bitbucket\_installer) | Filename of the BitBucket installer. | `string` | n/a | yes |
| <a name="input_bitbucket_license"></a> [bitbucket\_license](#input\_bitbucket\_license) | License key for BitBucket Data Cantre. Default is a trial license key. | `string` | n/a | yes |
| <a name="input_bitbucket_version"></a> [bitbucket\_version](#input\_bitbucket\_version) | Version of BitBucket to be installed. | `string` | n/a | yes |
| <a name="input_customer_kms_key_arn"></a> [customer\_kms\_key\_arn](#input\_customer\_kms\_key\_arn) | ARN of the CMK used for data encryption on EBS, RDS, S3 etc. | `string` | n/a | yes |
| <a name="input_deployment_role_arn"></a> [deployment\_role\_arn](#input\_deployment\_role\_arn) | ARN of the IAM Role to assume to deploy the resources | `string` | n/a | yes |
| <a name="input_ec2_subnet_ids"></a> [ec2\_subnet\_ids](#input\_ec2\_subnet\_ids) | Subnet IDs to deploy EC2 into. | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment. | `string` | n/a | yes |
| <a name="input_forward_proxy"></a> [forward\_proxy](#input\_forward\_proxy) | Forward proxy for internet access, e.g. http://<IP/DNS>:<PORT> | `string` | n/a | yes |
| <a name="input_forward_proxy_cidrs"></a> [forward\_proxy\_cidrs](#input\_forward\_proxy\_cidrs) | Forward Proxy CIDRs for use in security groups. | `string` | n/a | yes |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | Host name for use with ACM and Route53. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type to use for BitBucket server. | `string` | n/a | yes |
| <a name="input_ldap_server_cidrs"></a> [ldap\_server\_cidrs](#input\_ldap\_server\_cidrs) | LDAP server CIDRs for use in security groups. | `string` | n/a | yes |
| <a name="input_nlb_ingress_cidr"></a> [nlb\_ingress\_cidr](#input\_nlb\_ingress\_cidr) | Allowed ingress CIDRs for the NLB security group. | `list(string)` | `[]` | no |
| <a name="input_nlb_subnets"></a> [nlb\_subnets](#input\_nlb\_subnets) | Subnet IDs to deploy NLB into. | `list(map(string))` | n/a | yes |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | ARN of the permissions boundary policy to attach to IAM roles. | `string` | `null` | no |
| <a name="input_rds_instance_type"></a> [rds\_instance\_type](#input\_rds\_instance\_type) | Instance type to use for RDS instances. | `string` | n/a | yes |
| <a name="input_rds_subnet_ids"></a> [rds\_subnet\_ids](#input\_rds\_subnet\_ids) | Subnet IDs to deploy RDS resources into. | `list(string)` | n/a | yes |
| <a name="input_root_block_device_size"></a> [root\_block\_device\_size](#input\_root\_block\_device\_size) | Size in GB for the EC2 instance root block device. | `number` | n/a | yes |
| <a name="input_route53_role_arn"></a> [route53\_role\_arn](#input\_route53\_role\_arn) | ARN of the IAM role to assume to create Route53 records. | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Zone ID to create BitBucket Route53 records in. | `string` | n/a | yes |
| <a name="input_smtp_server_cidrs"></a> [smtp\_server\_cidrs](#input\_smtp\_server\_cidrs) | SMTP server CIDRs for use in security groups. | `string` | n/a | yes |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | SSH key pair name for EC2 instance. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to deploy resources into. | `string` | n/a | yes |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | Route53 zone name. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
