
# Role - application-observability-ec2-elastic-agent

## Attached AWS managed policies

* AmazonKinesisFirehoseFullAccess
* AmazonS3ReadOnlyAccess
* AmazonSQSFullAccess
* AmazonSSMManagedInstanceCore
* CloudWatchReadOnlyAccess

## Attached custom policies

* AwsEc2ElasticAgentPolicy

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllResources",
            "Effect": "Allow",
            "Action": [
                "ce:GetCostAndUsage",
                "iam:ListAccountAliases",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "ec2:DescribeInstances",
                "ec2:DescribeRegions",
                "logs:DescribeLogGroups",
                "organizations:ListAccounts",
                "rds:DescribeDBInstances",
                "rds:ListTagsForResource",
                "sns:ListTopics",
                "tag:GetResources",
                "sqs:ListQueues"
            ],
            "Resource": [
                "*"
            ]
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
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
