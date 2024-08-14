terraform {
  required_version = "~> 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }

  backend "s3" {
    key            = "aws-amdocs-bitbucket-dev/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state"
    encrypt        = true
  }

}
