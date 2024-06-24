provider "aws" {
  region = "ap-southeast-2"

  assume_role {
    role_arn = var.deployment_role_arn
  }

  default_tags {
    tags = local.tags
  }
}

provider "aws" {
  alias = "no_tags"

  region = "ap-southeast-2"

  assume_role {
    role_arn = var.deployment_role_arn
  }
}

provider "aws" {
  alias = "route53"

  assume_role {
    role_arn = var.route53_role_arn
  }

  default_tags {
    tags = local.tags
  }
}
