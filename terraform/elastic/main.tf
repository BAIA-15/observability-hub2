terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "observability-hub"
  region  = "ap-southeast-2"
  default_tags {
    tags = {
        ncs-au:account-owner:owner = "dev-ops"
        ncs-au:data:classification = "public"
        ncs-au:instance-sheduler:schedule = "mon-9am-fri-5pm"
    }
  }
}

