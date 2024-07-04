
# Role - application-observability-systems-manager

## Prerequisites

### Using the Default Host Management Configuration setting
https://docs.aws.amazon.com/systems-manager/latest/userguide/managed-instances-default-host-management.html

* An Amazon EC2 instance to be managed must use Instance Metadata Service Version 2 (IMDSv2).
* SSM Agent version 3.2.582.0 or later must be installed on the instance to be managed.

## Attached AWS managed policies

* AmazonSSMManagedEC2InstanceDefaultPolicy

## Attached custom policies

Policy name: application-observability-systems-manager

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        }
    ]
}
```

## Permissions boundary

None

## Trust relationship

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Allows SSM to call AWS services on your behalf",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "ssm.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
