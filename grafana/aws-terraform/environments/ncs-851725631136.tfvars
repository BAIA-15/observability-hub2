# NCS AWS account 851725631136
aws_cli_profile     = "ncs"
aws_region          = "ap-southeast-2"
main_vpc_id         = "vpc-03acfc82685dd7a33"    # AWS VPC id used in this deployment
compute_subnet_1_id = "subnet-0284b0ef91aea0ea6" # The first subnet id used in this deployment
compute_subnet_2_id = "subnet-0815036e894d811e5" # The second subnet id used in this deployment
# ec2_ami_id            = "ami-030a5acd7c996ef60"    # EC2 AMI id - Amazon Linux 2023
ec2_ami_id            = "ami-03f0544597f43a91d" # Ubuntu Server 24.04 LTS
aws_ec2_instance_type = "t2.micro"              # EC2 instance type
sns_email = "jacob.cantwell@gmail.com"
aws_vpc_endpoints = [
  "ssm",               # AWS Systems Manager - com.amazonaws.ap-southeast-2.ssm
  "ec2messages",       # AWS Systems Manager - com.amazonaws.ap-southeast-2.ec2messages
  "ssmmessages",       # AWS Systems Manager - com.amazonaws.ap-southeast-2.ssmmessages
  "ec2",               # Amazon EC2 - com.amazonaws.ap-southeast-2.ec2
  "kms",               # AWS KMS - com.amazonaws.ap-southeast-2.kms
  "logs",              # Amazon CloudWatch Logs - com.amazonaws.ap-southeast-2.logs
  "monitoring",        # Amazon CloudWatch Monitoring - com.amazonaws.ap-southeast-2.monitoring
  "elasticfilesystem", # Amazon Elastic Filesystem (EFS) - com.amazonaws.ap-southeast-2.elasticfilesystem
  "secretsmanager",    # AWS Secrets Manager - com.amazonaws.ap-southeast-2.secretsmanager
  "sns",               # Amazon Simple Notification Service (SNS) - com.amazonaws.ap-southeast-2.sns
  # "s3",          # Amazon S3 -com.amazonaws.ap-southeast-2.s3
]
tags = {
  o_a_avail        = "NCS_OperatingHours"
  o_b_bu           = "NCS_MegaBusinessUnit"
  o_b_bus-own      = "NCS_FinancialOwner"
  o_b_cc           = "NCS_FinacialCostCentre"
  o_b_pri-own      = "NCS_PrimaryOwner"
  o_b_project      = "NCS_ItassistProjectName"
  o_s_app-class    = "NCS_CyberApplicationCategory"
  o_s_data-class   = "NCS_DataClassification"
  o_s_sra          = "NCS_CyberSraEngagementNumber"
  o_t_app          = "NCS_MegaApplicationName"
  o_t_app-own      = "NCS_CurrentApplicationOwner"
  o_t_app-plat     = "NCS_MegaBusinessDivision"
  o_t_app-role     = "NCS_RoleOfResource"
  o_t_dep-mthd     = "NCS_DeploymentMethod"
  o_t_env          = "NCS_EnvironmentInstance"
  o_t_lifecycle    = "NCS_LifecycleStage"
  o_t_patch_window = "dev_1"
  o_t_tech-own     = "NCS_NameSupportingIndividual"
}