
# Set as [local values](https://www.terraform.io/docs/configuration/locals.html)
locals {
  account_id    = data.aws_caller_identity.current.account_id
  cluster_name = data.aws_iam_account_alias.current.account_alias
}

resource "aws_kms_key" "example" {
  description = "example"
}

resource "aws_kms_key_policy" "example" {
    key_id = aws_kms_key.example.id
    policy = jsonencode({
        "Version": "2012-10-17",
        "Id": "key-consolepolicy-3",
        "Statement": [
            {
                "Sid": "Enable IAM User Permissions",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::{account_id}:root"
                },
                "Action": "kms:*",
                "Resource": "*"
            },
            {
                "Sid": "Allow access for Key Administrators",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "$(jq --raw-output '.KmsAdminPrincipalRoleArn' ./output/aws-configuration.json)"
                },
                "Action": [
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
                "Resource": "*"
            },
            {
                "Sid": "Allow use of the key",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::{account_id}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
                },
                "Action": [
                    "kms:Encrypt",
                    "kms:Decrypt",
                    "kms:ReEncrypt*",
                    "kms:GenerateDataKey*",
                    "kms:DescribeKey"
                ],
                "Resource": "*"
            },
            {
                "Sid": "Allow generate data key access for Fargate tasks.",
                "Effect": "Allow",
                "Principal": {
                    "Service": "fargate.amazonaws.com"
                },
                "Action": "kms:GenerateDataKeyWithoutPlaintext",
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "kms:EncryptionContext:aws:ecs:clusterName": "{cluster_name}",
                        "kms:EncryptionContext:aws:ecs:clusterAccount": "{account_id}"
                    }
                }
            },
            {
                "Sid": "Allow grant creation permission for Fargate tasks.",
                "Effect": "Allow",
                "Principal": {
                    "Service": "fargate.amazonaws.com"
                },
                "Action": "kms:CreateGrant",
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "kms:EncryptionContext:aws:ecs:clusterName": "$(jq --raw-output '.ClusterName' ./output/aws-configuration.json)",
                        "kms:EncryptionContext:aws:ecs:clusterAccount": $(jq --raw-output '.Account' ./output/aws-configuration.json)
                    },
                    "ForAllValues:StringEquals": {
                        "kms:GrantOperations": "Decrypt"
                    }
                }
            }
        ]
    })
}
