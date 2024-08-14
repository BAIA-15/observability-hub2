data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

locals {
  name           = "bitbucket-${var.environment}"
  bitbucket_fqdn = "${var.host_name}.${var.zone_name}"

  tags = {
    o_b_bu         = "Networks"
    o_t_app-plat   = "IP Network Engineering"
    o_t_env        = "gnp"
    o_b_cc         = "5137"
    o_s_app-class  = "cat4"
    o_s_data-class = "conf_non_pii"
    o_t_app-role   = "inf"
    o_a_avail      = "24x7"
    o_s_sra        = "TBC"
    o_t_dep-mthd   = "iac"
    o_t_lifecycle  = "active"
    repo           = "aws-amdocs-bitbucket-dev"
    branch         = "master"
    type           = "infra"
  }
}

module "nlb_sg" {
  source = "git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-security-group.git?ref=v1.0.0"

  name        = "${local.name}-nlb"
  description = "Security group for ${local.name} NLB."
  vpc_id      = var.vpc_id

  egress_with_source_security_group_id = [
    {
      from_port                = 7990
      to_port                  = 7990
      protocol                 = 6
      description              = "HTTP to ${local.name}-ec2"
      source_security_group_id = module.ec2_sg.security_group_id
    },
    {
      from_port                = 7999
      to_port                  = 7999
      protocol                 = 6
      description              = "SSH from ${local.name}-ec2"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]

  ingress_cidr_blocks = var.nlb_ingress_cidr
  ingress_rules = [
    "https-443-tcp",
    "ssh-tcp"
  ]
}

module "ec2_sg" {
  source = "git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-security-group.git?ref=v1.0.0"

  name        = "${local.name}-ec2"
  description = "Security group for ${local.name} EC2 instance."
  vpc_id      = var.vpc_id

  egress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = "10.0.0.0/8"
    },
    {
      from_port   = 3128
      to_port     = 3128
      protocol    = 6
      description = "Forward Proxy TCP:3128"
      cidr_blocks = var.forward_proxy_cidrs
    },
    {
      from_port   = 389
      to_port     = 389
      protocol    = 6
      description = "LDAP TCP:389"
      cidr_blocks = var.ldap_server_cidrs
    },
    {
      from_port   = 636
      to_port     = 636
      protocol    = 6
      description = "LDAP TCP:636"
      cidr_blocks = var.ldap_server_cidrs
    },
    {
      from_port   = 25
      to_port     = 25
      protocol    = 6
      description = "SMTP TCP:25"
      cidr_blocks = var.smtp_server_cidrs
    },
  ]

  egress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = 6
      description              = "PostgreSQL to ${local.name}-rds"
      source_security_group_id = module.rds_sg.security_group_id
    }
  ]

  ingress_with_source_security_group_id = [
    {
      from_port                = 7990
      to_port                  = 7990
      protocol                 = 6
      description              = "HTTP from ${local.name}-nlb"
      source_security_group_id = module.nlb_sg.security_group_id
    },
    {
      from_port                = 7999
      to_port                  = 7999
      protocol                 = 6
      description              = "SSH from ${local.name}-nlb"
      source_security_group_id = module.nlb_sg.security_group_id
    }
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH TCP:22"
      cidr_blocks = "10.0.0.0/8"
    }
  ]
}

module "rds_sg" {
  source = "git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-security-group.git?ref=v1.0.0"

  name        = "${local.name}-rds"
  description = "Security group for ${local.name} RDS cluster."
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = 6
      description              = "PostgreSQL from ${local.name}-ec2"
      source_security_group_id = module.ec2_sg.security_group_id
    }
  ]
}

# S3 Bucket does not contain important or sensitive data.
# Logging and versioning not required.
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
module "ansible_bucket" {
  source = "git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-s3-bucket.git?ref=v1.0.0"

  bucket = "bitbucket-ansible-${data.aws_caller_identity.this.id}"

  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.customer_kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

module "ansible_playbook" {
  source = "git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-s3-bucket.git//modules/object?ref=v1.0.0"

  providers = {
    aws = aws.no_tags
  }

  bucket = module.ansible_bucket.s3_bucket_id
  key    = "playbook.yml"
  content = templatefile("files/playbook.yml", {
    admin_displayname   = var.bitbucket_admin_user.display_name
    admin_email         = var.bitbucket_admin_user.email
    admin_username      = var.bitbucket_admin_user.username
    database_endpoint   = module.rds.cluster_endpoint
    database_port       = module.rds.cluster_port
    bitbucket_installer = var.bitbucket_installer
    bitbucket_license   = var.bitbucket_license
    bitbucket_version   = var.bitbucket_version
    domain_name         = local.bitbucket_fqdn
    forward_proxy       = var.forward_proxy
    region              = data.aws_region.this.name
    secret_name         = module.bitbucket_secret.secret_id
    server_secure       = var.acm_cert_domain != null ? "true" : "false"
    server_scheme       = var.acm_cert_domain != null ? "https" : "http"
  })
}

data "aws_iam_policy_document" "ec2_instance" {
  statement {
    sid = "KMS"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [var.customer_kms_key_arn]
  }

  statement {
    sid = "SecretsManagerReadWrite"

    actions = ["secretsmanager:GetSecretValue"]

    resources = [module.bitbucket_secret.secret_arn]
  }

  statement {
    sid = "S3ListBucket"

    actions = ["s3:ListBucket"]

    resources = [module.ansible_bucket.s3_bucket_arn]
  }

  statement {
    sid = "S3ReadWrite"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    # Data is not sensitive and the keys for PutObject are dynamic
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["${module.ansible_bucket.s3_bucket_arn}/*"]
  }

  statement {
    sid = "SessionManager"

    actions = [
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenDataChannel",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:OpenControlChannel",
      "ssm:UpdateInstanceInformation"
    ]

    resources = ["*"]
  }

  statement {
    sid = "SSMSendCommandPlayBook"

    actions = ["ssm:SendCommand"]

    resources = ["arn:aws:ssm:${data.aws_region.this.name}::document/AWS-ApplyAnsiblePlaybooks"]

  }

  statement {
    sid = "SSMSendCommandInstance"

    actions = ["ssm:SendCommand"]

    resources = ["arn:aws:ec2:${data.aws_region.this.name}:${data.aws_caller_identity.this.id}:instance/*"]

    condition {
      test     = "StringLike"
      variable = "ssm:resourceTag/Name"

      values = [local.name]
    }

  }
}

locals {
  instance_role_name = "${local.name}-instance-role"
}

resource "aws_iam_role" "ec2_instance" {
  name = local.instance_role_name

  inline_policy {
    name   = "${local.name}-access"
    policy = data.aws_iam_policy_document.ec2_instance.json
  }

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  permissions_boundary = var.permissions_boundary_arn

  tags = {
    Name = local.instance_role_name
  }
}

locals {
  instance_profile_name = "${local.name}-profile"
}

resource "aws_iam_instance_profile" "ec2_instance" {

  name = local.instance_profile_name
  role = aws_iam_role.ec2_instance.name

  tags = {
    Name = local.instance_profile_name
  }
}

module "ec2_instance" {
  source = "git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-ec2-instance.git?ref=v1.0.0"

  name = local.name

  ami                    = var.ami_id
  key_name               = var.ssh_key_name
  ebs_optimized          = true
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id              = var.ec2_subnet_ids[0]

  iam_instance_profile = aws_iam_instance_profile.ec2_instance.name

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 8
    instance_metadata_tags      = "enabled"
  }

  root_block_device = [{
    encrypted   = true
    kms_key_id  = var.customer_kms_key_arn
    volume_size = var.root_block_device_size
  }]

  user_data = templatefile(("files/user_data.tpl"), {
    forward_proxy   = var.forward_proxy
    playbook_bucket = module.ansible_bucket.s3_bucket_id
    playbook_key    = module.ansible_playbook.s3_object_id
    region          = data.aws_region.this.name
  })

  tags = {
    Name = local.name
  }

  depends_on = [module.rds]
}

locals {
  ssh_tg_name = "bitbucket-tcp-7999"
  tls_tg_name = "bitbucket-tcp-7990"
}

data "aws_acm_certificate" "this" {
  count = var.acm_cert_domain != null ? 1 : 0

  domain = var.acm_cert_domain
}

module "nlb" {
  source = "git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-alb-nlb.git?ref=v1.0.0"

  name = local.name

  load_balancer_type               = "network"
  internal                         = true
  vpc_id                           = var.vpc_id
  dns_record_client_routing_policy = "availability_zone_affinity"

  subnet_mapping = var.nlb_subnets

  enable_deletion_protection = false

  create_security_group = false
  security_groups       = [module.nlb_sg.security_group_id]

  listeners = {
    ssh = {
      port     = 22
      protocol = "TCP"
      forward = {
        target_group_key = "ssh"
      }
    }

    tls = {
      port            = 443
      protocol        = var.acm_cert_domain != null ? "TLS" : "TCP"
      certificate_arn = var.acm_cert_domain != null ? data.aws_acm_certificate.this[0].arn : null
      forward = {
        target_group_key = "tls"
      }
    }
  }

  target_groups = {
    ssh = {
      name        = local.ssh_tg_name
      protocol    = "TCP"
      port        = 7999
      target_type = "ip"
      target_id   = module.ec2_instance.private_ip

      tags = {
        Name = local.ssh_tg_name
      }
    }

    tls = {
      name        = local.tls_tg_name
      protocol    = "TCP"
      port        = 7990
      target_type = "ip"
      target_id   = module.ec2_instance.private_ip

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/status"
        port                = "traffic-port"
        protocol            = "HTTP"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
      }

      tags = {
        Name = local.tls_tg_name
      }
    }
  }

  tags = {
    Name = local.name
  }
}

module "route53" {
  source = "git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-route53.git//modules/records?ref=v1.0.0"

  providers = {
    aws = aws.route53
  }

  zone_id = var.route53_zone_id

  records = [
    {
      allow_overwite = false

      name = var.host_name
      type = "A"
      alias = {
        name    = module.nlb.dns_name
        zone_id = module.nlb.zone_id
      }
    }
  ]
}

resource "random_password" "bitbucket_admin_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "bitbucket_db_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "rds_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "rds" {
  source = "git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-aurora.git?ref=v1.0.0"

  name                        = local.name
  engine                      = "aurora-postgresql"
  engine_version              = "15.4"
  manage_master_user_password = false
  master_username             = "postgres"
  master_password             = random_password.rds_password.result
  storage_type                = "aurora"
  database_name               = "bitbucket"
  instances = {
    1 = {
      instance_class          = var.rds_instance_type
      publicly_accessible     = false
      db_parameter_group_name = "default.aurora-postgresql14"
    }
  }

  create_db_subnet_group = true
  subnets                = var.rds_subnet_ids

  vpc_id                 = var.vpc_id
  vpc_security_group_ids = [module.rds_sg.security_group_id]

  apply_immediately     = true
  create_security_group = false
  skip_final_snapshot   = true

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = local.name
  db_cluster_parameter_group_family      = "aurora-postgresql15"
  db_cluster_parameter_group_description = "${local.name} cluster parameter group"
  db_cluster_parameter_group_parameters = [
    {
      name         = "log_min_duration_statement"
      value        = 4000
      apply_method = "immediate"
      }, {
      name         = "rds.force_ssl"
      value        = 1
      apply_method = "immediate"
    }
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = local.name
  db_parameter_group_family      = "aurora-postgresql15"
  db_parameter_group_description = "${local.name} DB parameter group"
  db_parameter_group_parameters = [
    {
      name         = "log_min_duration_statement"
      value        = 4000
      apply_method = "immediate"
    }
  ]

  enabled_cloudwatch_logs_exports = ["postgresql"]
  create_cloudwatch_log_group     = false

  storage_encrypted = true
  kms_key_id        = var.customer_kms_key_arn
}

module "bitbucket_secret" {
  source = "git::https://iacprdgitla001.nix.au.singtelgroup.net/TEL/terraform-aws-optus-secrets-manager.git?ref=v1.0.0"

  name_prefix             = "bitbucket_credentials"
  description             = "Admin and Database credentials for BitBucket Data Centre."
  recovery_window_in_days = 30

  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid = "AllowAccountRead"
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.id}:root"]
      }]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }

  secret_string = jsonencode({
    admin_password          = random_password.bitbucket_admin_password.result
    admin_database_password = random_password.rds_password.result
    database_password       = random_password.bitbucket_db_password.result
  })
}
