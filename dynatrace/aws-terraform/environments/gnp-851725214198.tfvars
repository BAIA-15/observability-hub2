# Optus AWS account gnp 851725214198
aws_cli_profile       = "aws-it-observability-gnp-admin-851725214198"
aws_region            = "ap-southeast-2"
main_vpc_id           = "vpc-09f66367832c81626"    # AWS VPC id used in this deployment
compute_subnet_1_id   = "subnet-0956ea0317a3e43ed" # The first subnet id used in this deployment
compute_subnet_2_id   = "subnet-0dc8294f868fec22c" # The second subnet id used in this deployment
ec2_ami_id            = "RHEL8-SOE-*"              # EC2 AMI id
aws_ec2_instance_type = "t2.micro"                 # EC2 instance type
tags = {
  o_a_avail        = "Optus_OperatingHours"
  o_b_bu           = "Optus_MegaBusinessUnit"
  o_b_bus-own      = "Optus_FinancialOwner"
  o_b_cc           = "Optus_FinacialCostCentre"
  o_b_pri-own      = "Optus_PrimaryOwner"
  o_b_project      = "Optus_ItassistProjectName"
  o_s_app-class    = "Optus_CyberApplicationCategory"
  o_s_data-class   = "Optus_DataClassification"
  o_s_sra          = "Optus_CyberSraEngagementNumber"
  o_t_app          = "Optus_MegaApplicationName"
  o_t_app-own      = "Optus_CurrentApplicationOwner"
  o_t_app-plat     = "Optus_MegaBusinessDivision"
  o_t_app-role     = "Optus_RoleOfResource"
  o_t_dep-mthd     = "Optus_DeploymentMethod"
  o_t_env          = "Optus_EnvironmentInstance"
  o_t_lifecycle    = "Optus_LifecycleStage"
  o_t_patch_window = "dev_1"
  o_t_tech-own     = "Optus_NameSupportingIndividual1"
}