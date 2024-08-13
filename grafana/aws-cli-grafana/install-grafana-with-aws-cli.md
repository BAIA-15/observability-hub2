

## Pushing the Grafane Enterprise Docker image to an Amazon ECR private repository

```bash
aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 851725631136.dkr.ecr.ap-southeast-2.amazonaws.com
```

```bash
docker run -d -p 3000:3000 --name=grafana grafana/grafana-enterprise
```

```bash
docker images
docker tag grafana/grafana-enterprise:latest 851725631136.dkr.ecr.ap-southeast-2.amazonaws.com/observability-hub:latest
docker push 851725631136.dkr.ecr.ap-southeast-2.amazonaws.com/observability-hub:latest
```

## Deploy Grafana Enterprise on Amazon ECS

### Create an AWS KMS Key
* Key type: Symmetric
* Key usage: Encrypt and decrypt
* Key material origin: KMS
* Regionality: Single-Region key
* Alias: observability-hub-grafana
* Description: observability-hub-grafana
* Tags: add required tags
* Key administrators: select admins
* Key deletion: Allow key administrators to delete this key.
* Key users: AWSServiceRoleForECS
* Review
* Finish

### AWS Variables
```bash
cat > ./output/aws-configuration.json <<EOF
{
    "account": "851725631136",
    "ecsTaskRoleArn": "arn:aws:iam::851725631136:role/application-observability-ecs-grafana-enterprise",
    "kmsAdminPrincipalRoleArn": "arn:aws:iam::851725631136:role/AWS-632_Jacob_Cantwell_DBAAdmin",
    "clusterName": "observability-hub-grafana",
    "vpcId": "vpc-03acfc82685dd7a33",
    "subnets": ["subnet-0284b0ef91aea0ea6","subnet-0815036e894d811e5"]
}
EOF
```

### AWS KMS Key Policy

```bash
cat > ./output/kms-key-policy-grafana.json <<EOF
{
    "Version": "2012-10-17",
    "Id": "key-consolepolicy-3",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::$(jq --raw-output '.account' ./output/aws-configuration.json):root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "$(jq --raw-output '.kmsAdminPrincipalRoleArn' ./output/aws-configuration.json)"
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
                "AWS": "arn:aws:iam::$(jq --raw-output '.account' ./output/aws-configuration.json):role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
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
                    "kms:EncryptionContext:aws:ecs:clusterName": "$(jq --raw-output '.clusterName' ./output/aws-configuration.json)",
                    "kms:EncryptionContext:aws:ecs:clusterAccount": "$(jq --raw-output '.account' ./output/aws-configuration.json)"
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
                    "kms:EncryptionContext:aws:ecs:clusterName": "$(jq --raw-output '.clusterName' ./output/aws-configuration.json)",
                    "kms:EncryptionContext:aws:ecs:clusterAccount": $(jq --raw-output '.account' ./output/aws-configuration.json)
                },
                "ForAllValues:StringEquals": {
                    "kms:GrantOperations": "Decrypt"
                }
            }
        }
    ]
}
EOF
```

```bash
aws kms create-key \
    --description observability-hub-grafana \
    --policy file://output/kms-key-policy-grafana.json \
    --tags '[{"TagKey":"project","TagValue":"observability-hub-grafana"}]' \
    > ./output/kms-create-key.json

aws kms create-alias \
    --alias-name alias/$(jq --raw-output '.clusterName' ./output/aws-configuration.json) \
    --target-key-id $(jq --raw-output '.KeyMetadata.KeyId' ./output/kms-create-key.json)
```


## Create AWS Secrets Manager Password for Grafana Admin

    // Grafana Admin Password
    const grafanaAdminPassword = new secretsmanager.Secret(this, 'grafanaAdminPassword');
    // Allow Task to access Grafana Admin Password
    grafanaAdminPassword.grantRead(taskRole);

```bash
openssl rand -base64 32 > ./output/grafana-credentials.txt
```

```bash
aws secretsmanager create-secret \
    --name grafanaEnterpriseAdminPasswordv1 \
    --description "Grafana Enterpise admin password" \
    --secret-string file://output/grafana-credentials.txt \
    > ./output/secretsmanager-create-secret.json
```

### Create an AWS ECS cluster

* Cluster name: observability-hub-grafana
* Default namaspace: observability-hub-grafana
* Infrastructure: AWS Fargate (serverless)
* Monitoring: Use Container Insights
* Encryption
    * Managed storage: observability-hub-grafana
    * Fargate ephemeral storage: observability-hub-grafana
* Tags: add required tags
    * project: observability-hub-grafana
* Create


```bash
aws ecs create-cluster \
    --cluster-name $(jq --raw-output '.clusterName' ./output/aws-configuration.json) \
    --configuration managedStorageConfiguration={kmsKeyId=$(jq --raw-output '.KeyMetadata.KeyId' ./output/kms-create-key.json)} \
    --tags key=project,value=$(jq --raw-output '.clusterName' ./output/aws-configuration.json) \
    --settings name=containerInsights,value=enabled \
    > ./output/ecs-create-cluster.json
```

ECS update cluster example (optional)

```bash
aws ecs update-cluster \
    --cluster $(jq --raw-output '.cluster.clusterName' ./output/ecs-create-cluster.json) \
    --configuration managedStorageConfiguration={fargateEphemeralStorageKmsKeyId=$(jq --raw-output '.KeyMetadata.KeyId' ./output/kms-create-key.json)}
```

### Create an AWS ECS task definition

#### Task definition

* Create new task definition
* Task definition family: grafana-enterprise
* Launch type: AWS Fargate (serverless)
* OS, Architecture, Network mode: Linux/X86_64
* Network mode: awsvpc
* Task size
    * CPU: 1 vCPU
    * Memory: 1 GB
* Task role: None
* Task execution role: None

### Container 1

Container details
* Name: grafana-enterprise
* Image URI: 851725631136.dkr.ecr.ap-southeast-2.amazonaws.com/observability-hub:latest
* Essential container: Yes

Port mappings
* Container port: 3000
* Protocol: TCP

Log collection
* awslogs-group | Value | /ecs/observability-hub-grafana
* aws-region | Value | ap-southeast-2
* awslogs-stream-prefix | Value | ecs
* awslogs-create-group | Value | true

```bash
cat > ./output/ecs-fargate-task-definition-grafana.json <<EOF
{
    "family": "grafana-enterprise",
    "containerDefinitions": [
        {
            "name": "grafana-enterprise",
            "image": "grafana/grafana-enterprise",
            "cpu": 0,
            "portMappings": [
                {
                    "name": "grafana-enterprise-3000-tcp",
                    "containerPort": 3000,
                    "hostPort": 3000,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environment": [
                {
                    "name": "GF_SECURITY_ADMIN_USER",
                    "value": "administrator"
                },
                {
                    "name": "GF_WHITE_LABELING_APP_TITLE",
                    "value": "HeyTaxi"
                }
            ],
            "environmentFiles": [],
            "mountPoints": [],
            "volumesFrom": [],
            "ulimits": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/grafana-enterprise",
                    "awslogs-create-group": "true",
                    "awslogs-region": "ap-southeast-2",
                    "awslogs-stream-prefix": "ecs"
                },
                "secretOptions": []
            },
            "secrets": [
                {
                    "name": "GF_SECURITY_ADMIN_PASSWORD",
                    "valueFrom": "$(jq --raw-output '.ARN' ./output/secretsmanager-create-secret.json)"
                }
            ]
        }
    ],
    "networkMode": "awsvpc",
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "cpu": "1024",
    "memory": "2048",
    "runtimePlatform": {
        "cpuArchitecture": "X86_64",
        "operatingSystemFamily": "LINUX"
    }
}
EOF
```

```bash
aws ecs register-task-definition \
    --task-role-arn $(jq --raw-output '.ecsTaskRoleArn' ./output/aws-configuration.json) \
    --execution-role-arn $(jq --raw-output '.ecsTaskRoleArn' ./output/aws-configuration.json) \
    --cli-input-json file://output/ecs-fargate-task-definition-grafana.json \
    --tags key=project,value=$(jq --raw-output '.clusterName' ./output/aws-configuration.json) \
    > ./output/ecs-register-task-definition.json
```

### Create an AWS VPC Security Group for the AWS ECS service

```bash
aws ec2 create-security-group \
    --description $(jq --raw-output '.cluster.clusterName' ./output/ecs-create-cluster.json) \
    --group-name $(jq --raw-output '.cluster.clusterName' ./output/ecs-create-cluster.json) \
    --vpc-id $(jq -r '.vpcId' ./output/aws-configuration.json) \
    --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=$(jq --raw-output '.cluster.clusterName' ./output/ecs-create-cluster.json)},{Key=project,Value=heytaxi}]"  \
    > ./output/ec2-create-security-group-for-ecs-fargate.json
```

#### Allow access from my IP address

Get my IP address
```bash
curl -o ifconfig.me  ifconfig.me
```

Authorise EC2 Security Group

```bash
aws ec2 authorize-security-group-ingress \
    --group-id $(jq --raw-output '.GroupId' ./output/ec2-create-security-group-for-ecs-fargate.json) \
    --ip-permissions IpProtocol=tcp,FromPort=3000,ToPort=3000,IpRanges="[{CidrIp=###.###.##.##/32,Description='Web access from NCS office'}]" \
    --tag-specifications "ResourceType=security-group-rule,Tags=[{Key=Name,Value=$(jq --raw-output '.cluster.clusterName' ./output/ecs-create-cluster.json)},{Key=project,Value=heytaxi}]"
```

### Create an AWS ECS service

* Capacity provider: FARGATE
* Family: grafana-enterprise
* Revision: LATEST
* Service name: grafana-enterprise
* Desired tasks: 1

```bash
aws ecs create-service \
    --cluster $(jq --raw-output '.cluster.clusterName' ./output/ecs-create-cluster.json) \
    --service-name "grafana-enterprise" \
    --task-definition $(jq -r '.taskDefinition.taskDefinitionArn' ./output/ecs-register-task-definition.json) \
    --desired-count 1 \
    --launch-type FARGATE \
    --platform-version LATEST \
    --network-configuration "awsvpcConfiguration={subnets=$(jq -r '.subnets' ./output/aws-configuration.json),securityGroups=[$(jq -r '.GroupId' ./output/ec2-create-security-group-for-ecs-fargate.json)],assignPublicIp=ENABLED}" \
    --tags key=Name,value=$(jq --raw-output '.cluster.clusterName' ./output/ecs-create-cluster.json) key=project,value=heytaxi \
    > ./output/ecs-create-service.json
```

```
TODO - add     --load-balancers targetGroupArn=string,containerName=string,containerPort=3000 \

awsvpcConfiguration={subnets=[subnet-12344321],securityGroups=[sg-12344321],assignPublicIp=ENABLED}
assignPublicIp=DISABLED
--load-balancers targetGroupArn=string,loadBalancerName=string,containerName=string,containerPort=integer
```
