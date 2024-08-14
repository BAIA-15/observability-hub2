
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = var.aws_cli_profile
  region  = var.aws_region
  default_tags {
    tags = var.tags
  }
}
