
# Role - application-observability-ec2-elastic-agent

## Attached AWS managed policies

### NCS account only - TODO remove
* AWSCodeCommitFullAccess

## Attached custom policies

* AwsSSOInlinePolicy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAndViewAccountAccess",
            "Effect": "Allow",
            "Action": [
                "account:List*",
                "account:Get*",
                "aws-portal:View*",
                "budgets:View*",
                "iam:Get*",
                "iam:List*",
                "license-manager:List*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ComputeEC2Access",
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:Get*",
                "ec2:Search*",
                "ec2:AllocateAddress",
                "ec2:AllocateHosts",
                "ec2:AssignPrivateIpAddresses",
                "ec2:AssociateAddress",
                "ec2:AssociateIamInstanceProfile",
                "ec2:AssociateRouteTable",
                "ec2:AssociateSubnetCidrBlock",
                "ec2:AttachNetworkInterface",
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CopySnapshot",
                "ec2:CreateFlowLogs",
                "ec2:CreateLaunchTemplate",
                "ec2:CreateLaunchTemplateVersion",
                "ec2:CreateNetworkInterface",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSnapshot",
                "ec2:CreateSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateKeyPair",
                "ec2:DeleteKeyPair",
                "ec2:DeleteLaunchTemplate",
                "ec2:DeleteNetworkAcl",
                "ec2:DeleteNetworkAclEntry",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteResourcePolicy",
                "ec2:DeleteRoute",
                "ec2:DeleteRouteTable",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSnapshot",
                "ec2:DeleteTags",
                "ec2:DeleteVolume",
                "ec2:DetachVolume",
                "ec2:DisassociateIamInstanceProfile",
                "ec2:DisassociateRouteTable",
                "ec2:DisassociateSubnetCidrBlock",
                "ec2:DisableFastSnapshotRestores",
                "ec2:EnableFastSnapshotRestores",
                "ec2:ImportImage",
                "ec2:ImportKeyPair",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifyInstancePlacement",
                "ec2:MonitorInstances",
                "ec2:ModifySecurityGroupRules",
                "ec2:ModifySnapshotAttribute",
                "ec2:ModifySnapshotTier",
                "ec2:ModifyVolume",
                "ec2:PutResourcePolicy",
                "ec2:ReplaceIamInstanceProfileAssociation",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:RunInstances",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
                "ec2:UpdateSecurityGroupRuleDescriptionsIngress"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:Region": "ap-southeast-2"
                }
            }
        },
        {
            "Sid": "AllowResourceActions",
            "Effect": "Allow",
            "Action": [
                "access-analyzer:*",
                "acm:*",
                "application-autoscaling:*",
                "applicationinsights:*",
                "arc-zonal-shift:List*",
                "athena:*",
                "autoscaling:*",
                "backup:*",
                "ce:*",
                "cloudformation:*",
                "cloudshell:*",
                "cloudtrail:*",
                "cloudtrail-data:*",
                "cloudwatch:*",
                "cognito-idp:Describe*",
                "compute-optimizer:*",
                "config:*",
                "cost-optimization-hub:*",
                "devops-guru:*",
                "dlm:*",
                "ec2-instance-connect:*",
                "ec2messages:*",
                "ecr:*",
                "ecs:*",
                "elasticloadbalancing:*",
                "events:*",
                "firehose:*",
                "freetier:*",
                "fsx:*",
                "health:*",
                "kinesis:*",
                "kms:*",
                "lambda:*",
                "logs:*",
                "networkmonitor:*",
                "oam:*",
                "pi:*",
                "pipes:*",
                "rds:*",
                "resource-explorer:*",
                "s3:*",
                "s3-object-lambda:*",
                "scheduler:*",
                "schemas:*",
                "secretsmanager:*",
                "sns:*",
                "sqs:*",
                "ssm:*",
                "ssm-guiconnect:*",
                "ssm-incidents:*",
                "ssmmessages:*",
                "support:*",
                "tag:*",
                "trustedadvisor:*",
                "wellarchitected:*",
                "xray:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowPassIamRole",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": [
                "arn:aws:iam::*:role/application-observability-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:AttachRolePolicy",
                "iam:CreateServiceLinkedRole",
                "iam:DeleteServiceLinkedRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/aws-service-role/*"
            ]
        }
    ]
}
```
## Permissions boundary

None
