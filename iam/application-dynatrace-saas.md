
# Role - application-dynatrace-saas

## Attached AWS managed policies

None

## Attached custom policies

* ApplicationDynatraceSaas

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
		"Effect": "Allow",
		"Action": [
			"apigateway:GET*",
			"autoscaling:DescribeAutoScalingGroups",
			"cloudformation:ListStackResources",
			"cloudfront:ListDistributions",
			"cloudwatch:GetMetricData",
			"cloudwatch:ListMetrics",
			"dynamodb:ListTables",
			"dynamodb:ListTagsOfResource",
			"ec2:DescribeAvailabilityZones",
			"ec2:DescribeInstances",
			"ec2:DescribeNatGateways",
			"ec2:DescribeSpotFleetRequests",
			"ec2:DescribeVolumes",
			"ecs:ListClusters",
			"elasticache:DescribeCacheClusters",
			"elasticbeanstalk:DescribeEnvironmentResources",
			"elasticbeanstalk:DescribeEnvironments",
			"elasticfilesystem:DescribeFileSystems",
			"elasticloadbalancing:DescribeInstanceHealth",
			"elasticloadbalancing:DescribeListeners",
			"elasticloadbalancing:DescribeLoadBalancers",
			"elasticloadbalancing:DescribeRules",
			"elasticloadbalancing:DescribeTags",
			"elasticloadbalancing:DescribeTargetHealth",
			"elasticmapreduce:ListClusters",
			"es:ListDomainNames",
			"firehose:ListDeliveryStreams",
			"glue:GetJobs",
			"kinesis:ListStreams",
			"kinesisanalytics:ListApplications",
			"kinesisvideo:ListStreams",
			"lambda:ListFunctions",
			"lambda:ListTags",
			"rds:DescribeDBClusters",
			"rds:DescribeDBInstances",
			"rds:DescribeEvents",
			"rds:ListTagsForResource",
			"redshift:DescribeClusters",
			"s3:ListAllMyBuckets",
			"sagemaker:ListEndpoints",
			"sns:ListTopics",
			"sqs:ListQueues",
			"sts:GetCallerIdentity",
			"tag:GetResources",
			"tag:GetTagKeys"            
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
				"AWS": ">>>>>AWS ACCOUNT<<<<<<<<<<<<"
			},
			"Action": "sts:AssumeRole",
			"Condition": {
				"StringEquals": {
					"sts:ExternalId": "<enter the dynatrace toke ID>########IMPORTANT####"
				}
			}
		}
	]
}
```
