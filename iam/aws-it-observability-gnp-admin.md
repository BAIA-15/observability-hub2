
# Role - application-observability-ec2-elastic-agent

## Attached AWS managed policies

* AmazonEC2ContainerRegistryFullAccess
* AmazonEC2FullAccess
* AmazonEventBridgeFullAccess
* AmazonRDSFullAccess
* AmazonS3FullAccess
* AmazonVPCReadOnlyAccess
* AutoScalingFullAccess
* AWSCloudShellFullAccess
* CloudWatchEventsFullAccess

## Attached custom policies

* AwsSSOInlinePolicy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/acm.amazonaws.com/AWSServiceRoleForCertificateManager*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": "acm.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:DeleteServiceLinkedRole",
                "iam:GetServiceLinkedRoleDeletionStatus",
                "iam:GetRole"
            ],
            "Resource": "arn:aws:iam::*:role/aws-service-role/acm.amazonaws.com/AWSServiceRoleForCertificateManager*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "license-manager:ListLicenseConfigurations",
                "license-manager:ListLicenseSpecificationsForResource"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetRole"
            ],
            "Resource": "arn:aws:iam::*:role/aws-service-role/imagebuilder.amazonaws.com/AWSServiceRoleForImageBuilder"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetInstanceProfile"
            ],
            "Resource": "arn:aws:iam::*:instance-profile/*imagebuilder*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListInstanceProfiles",
                "iam:ListRoles"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": [
                "arn:aws:iam::*:instance-profile/*imagebuilder*",
                "arn:aws:iam::*:role/*imagebuilder*"
            ],
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "ec2.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3::*:*imagebuilder*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/imagebuilder.amazonaws.com/AWSServiceRoleForImageBuilder",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "imagebuilder.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeImages",
                "ec2:DescribeSnapshots",
                "ec2:DescribeVpcs",
                "ec2:DescribeRegions",
                "ec2:DescribeVolumes",
                "ec2:DescribeSubnets",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeInstanceTypeOfferings",
                "ec2:DescribeLaunchTemplates"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListGroups",
                "iam:ListRoles",
                "iam:ListUsers"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:DescribeStacks",
                "cloudformation:ListStackResources",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "iam:ListRoles",
                "lambda:*",
                "logs:DescribeLogGroups",
                "states:DescribeStateMachine",
                "states:ListStateMachines",
                "tag:GetResources",
                "xray:GetTraceSummaries",
                "xray:BatchGetTraces"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "lambda.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogStreams",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:Describe*",
                "cloudwatch:*",
                "logs:*",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "oam:ListSinks"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "events.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:*",
            ],
            "Resource": "*"
        },
        {
            "Sid": "ListAndViewAccountAccess",
            "Effect": "Allow",
            "Action": [
                "account:List*",
                "account:GetAccountInformation",
                "aws-portal:View*",
                "budgets:View*",
                "iam:Get*",
                "iam:List*",
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
            "Sid": "DenyPurchases",
            "Effect": "Deny",
            "Action": [
                "ec2:PurchaseReserved*"
            ],
            "Resource": "*"
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
                "cloudtrail:*",
                "cloudtrail-data:*",
                "cloudwatch:*",
                "cognito-idp:Describe*",
                "compute-optimizer:*",
                "config:*",
                "cost-optimization-hub:*",
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
                "arn:aws:iam::851725214198:role/application-observability-ec2-elastic-agent",
                "arn:aws:iam::851725214198:role/application-observability-ec2-dynatrace-agent"
            ]
        }
    ]
}
```
## Permissions boundary

* AwsItObservabilityPoliCyBoundaryGnp 

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAll",
            "Effect": "Allow",
            "Action": [
                "iam:*",
                "access-analyzer:*",
                "ce:*",
                "cloudshell:*",
                "ec2:*",
                "secretsmanager:*",
                "cloudformation:*",
                "docdb-elastic:*",
                "lambda:*",
                "rds:*",
                "tag:*",
                "s3:*",
                "events:*",
                "schemas:*",
                "scheduler:*",
                "pipes:*",
                "s3-object-lambda:*",
                "cloudwatch:*",
                "elasticloadbalancing:*",
                "ram:*",
                "logs:*",
                "sns:*",
                "oam:*",
                "autoscaling:*",
                "organizations:*",
                "ecr:*",
                "cognito-idp:*",
                "arc-zonal-shift:*",
                "acm:*",
                "rds:*",
                "application-autoscaling:*",
                "outposts:*",
                "devops-guru:*",
                "pi:*",
                "eks:*",
                "sts:*",
                "ssm:*",
                "kms:*",
                "cloudwatch:*",
                "autoscaling:*",
                "ec2messages:*",
                "ssmmessages:*",
                "imagebuilder:*",
                "events:*",
                "schemas:*",
                "scheduler:*",
                "pipes:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "DenyCreateUpdateIAMUser",
            "Effect": "Deny",
            "Action": [
                "iam:CreateUser",
                "iam:UpdateUser",
                "iam:DeleteUser"
            ],
            "Resource": "*"
        },
        {
            "Sid": "DenyCreateUpdateRoleWithoutPermissionBoundary",
            "Effect": "Deny",
            "Action": [
                "iam:CreateRole",
                "iam:UpdateRole"
            ],
            "Resource": "*",
            "Condition": {
                "StringNotEquals": {
                    "iam:PermissionsBoundary": "arn:aws:iam::851725214198:policy/AwsItObservabilityPoliCyBoundaryGnp"
                }
            }
        },
        {
            "Sid": "DenyPutAndDeletePermissionsBoundary",
            "Effect": "Deny",
            "Action": [
                "iam:DeleteUserPermissionsBoundary",
                "iam:PutUserPermissionsBoundary",
                "iam:PutRolePermissionsBoundary",
                "iam:DeleteRolePermissionsBoundary"
            ],
            "Resource": "*"
        },
        {
            "Sid": "DenyDeleteOrUpdateBoundaryPolicy",
            "Effect": "Deny",
            "Action": [
                "iam:DeletePolicy",
                "iam:DeletePolicyVersion",
                "iam:CreatePolicyVersion",
                "iam:SetDefaultPolicyVersion"
            ],
            "Resource": "arn:aws:iam::851725214198:policy/AwsItObservabilityPoliCyBoundaryGnp"
        }
    ]
}
```

## Trust relationship

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
