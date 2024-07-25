
data "aws_iam_policy_document" "kms_key_policy_grafana" {
  statement {
    sid    = "Enable root IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
}

resource "aws_kms_key" "grafana" {
  description         = "Symmetric encryption KMS key for Grafana"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.kms_key_policy_grafana.json
}

resource "aws_kms_alias" "grafana" {
  name          = "alias/grafana_kms_key_alias"
  target_key_id = aws_kms_key.grafana.key_id
}

/*
  statement {
    sid = "Allow ECS Fargate use of the key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid = "Allow generate data key access for Fargate tasks"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["fargate.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKeyWithoutPlaintext"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:aws:ecs:clusterName"
      values   = ["${var.cluster_name}"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:aws:ecs:clusterAccount"
      values   = ["${local.account_id}"]
    }
  }
  statement {
    sid = "Allow grant creation permission for Fargate tasks"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["fargate.amazonaws.com"]
    }
    actions = [
      "kms:CreateGrant"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:aws:ecs:clusterName"
      values   = ["${var.cluster_name}"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:aws:ecs:clusterAccount"
      values   = ["${local.account_id}"]
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "kms:GrantOperations"
      values   = ["Decrypt"]
    }
  }

      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${local.account_id}:role/*"
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
          "kms:RotateKeyOnDemand"
        ],
        "Resource" : "*"
      }
,

*/
