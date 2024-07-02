
# Role - application-observability-systems-manager

## Prerequisites

### Using the Default Host Management Configuration setting
https://docs.aws.amazon.com/systems-manager/latest/userguide/managed-instances-default-host-management.html

* An Amazon EC2 instance to be managed must use Instance Metadata Service Version 2 (IMDSv2).
* SSM Agent version 3.2.582.0 or later must be installed on the instance to be managed.

## Attached AWS managed policies

* AmazonSSMManagedEC2InstanceDefaultPolicy

## Attached custom policies

None

## Permissions boundary

None

## Trust relationship

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ssm.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
