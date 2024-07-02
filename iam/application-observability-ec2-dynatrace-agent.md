
# Role - application-observability-ec2-dynatrace-agent

## Attached AWS managed policies

* AmazonS3ReadOnlyAccess
* AmazonSSMManagedInstanceCore

## Attached custom policies

* AwsEc2DynatraceAgent

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "cloudwatch:GetMetricData",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInstances",
                "ec2:DescribeVolumes",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeTargetHealth",
                "rds:DescribeDBInstances",
                "rds:DescribeEvents",
                "rds:ListTagsForResource",
                "dynamodb:ListTables",
                "dynamodb:ListTagsOfResource",
                "lambda:ListFunctions",
                "lambda:ListTags",
                "elasticbeanstalk:DescribeEnvironments",
                "elasticbeanstalk:DescribeEnvironmentResources",
                "s3:ListAllMyBuckets",
                "sts:GetCallerIdentity",
                "cloudformation:ListStackResources",
                "tag:GetResources",
                "tag:GetTagKeys",
                "cloudwatch:ListMetrics",
                "kinesisvideo:ListStreams",
                "sns:ListTopics",
                "sqs:ListQueues",
                "ec2:DescribeNatGateways",
                "ec2:DescribeSpotFleetRequests",
                "kinesis:ListStreams",
                "es:ListDomainNames",
                "cloudfront:ListDistributions",
                "firehose:ListDeliveryStreams",
                "elasticmapreduce:ListClusters",
                "kinesisanalytics:ListApplications",
                "elasticache:DescribeCacheClusters",
                "elasticfilesystem:DescribeFileSystems",
                "ecs:ListClusters",
                "redshift:DescribeClusters",
                "rds:DescribeDBClusters",
                "glue:GetJobs",
                "sagemaker:ListEndpoints",
                "apigateway:GET"
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
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
