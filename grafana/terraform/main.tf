
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

provider "aws" {
  profile = "ncs"
  # profile = "aws-it-observability-gnp-admin-851725214198"
  region = "ap-southeast-2"
  default_tags {
    tags = {
      o_b_bus-own    = "FinancialOwner"
      o_s_sra        = "CyberSraEngagementNumber"
      o_s_app-class  = "CyberApplicationCategory"
      o_t_app-role   = "RoleOfResource"
      o_t_env        = "EnvironmentInstance"
      o_t_app-plat   = "MegaBusinessDivision"
      o_t_app        = "MegaApplicationName"
      o_t_tech-own   = "NameSupportingIndividual"
      o_b_cc         = "FinacialCostCentre"
      o_b_pri-own    = "PrimaryOwner"
      o_b_project    = "ItassistProjectName"
      o_b_bu         = "MegaBusinessUnit"
      o_s_data-class = "DataClassification"
      o_t_app-own    = "CurrentApplicationOwner"
      o_t_dep-mthd   = "DeploymentMethod"
      o_a_avail      = "OperatingHours"
      o_t_lifecycle  = "LifecycleStage"
    }
  }
}
