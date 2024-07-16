
# Role - application-observability-vpc-flow-logs

Role name: application-observability-vpc-flow-logs
Description: Allows VPC Flow Logs to create Amazon CloudWatch resources.

## Attached AWS managed policies

None

## Attached custom policies

Policy name: application-observability-vpc-flow-logs

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
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
            "Action": [
                "sts:AssumeRole"
            ],
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "vpc-flow-logs.amazonaws.com"
                ]
            }
        }
    ]
}
```
