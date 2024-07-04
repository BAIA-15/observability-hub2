
# Role - application-observability-ec2-ssm-managed

## Attached AWS managed policies

* AmazonKinesisFirehoseFullAccess
* AmazonS3ReadOnlyAccess
* AmazonSQSFullAccess
* AmazonSSMManagedInstanceCore
* CloudWatchReadOnlyAccess

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
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
