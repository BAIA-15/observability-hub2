

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
    "Account": "851725631136",
    "KmsAdminPrincipalRoleArn": "arn:aws:iam::851725631136:role/AWS-632_Jacob_Cantwell_DBAAdmin",
    "ClusterName": "observability-hub-grafana"
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
                "AWS": "arn:aws:iam::$(jq --raw-output '.Account' ./output/aws-configuration.json):root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "$(jq --raw-output '.KmsAdminPrincipalRoleArn' ./output/aws-configuration.json)"
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
                "AWS": "arn:aws:iam::$(jq --raw-output '.Account' ./output/aws-configuration.json):role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
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
                    "kms:EncryptionContext:aws:ecs:clusterName": "$(jq --raw-output '.ClusterName' ./output/aws-configuration.json)",
                    "kms:EncryptionContext:aws:ecs:clusterAccount": "$(jq --raw-output '.Account' ./output/aws-configuration.json)"
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
                    "kms:EncryptionContext:aws:ecs:clusterName": "$(jq --raw-output '.ClusterName' ./output/aws-configuration.json)",
                    "kms:EncryptionContext:aws:ecs:clusterAccount": $(jq --raw-output '.Account' ./output/aws-configuration.json)
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
    --alias-name alias/$(jq --raw-output '.ClusterName' ./output/aws-configuration.json) \
    --target-key-id $(jq --raw-output '.KeyMetadata.KeyId' ./output/kms-create-key.json)
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
    --cluster-name $(jq --raw-output '.ClusterName' ./output/aws-configuration.json) \
    --configuration managedStorageConfiguration={kmsKeyId=$(jq --raw-output '.KeyMetadata.KeyId' ./output/kms-create-key.json)} \
    --tags key=project,value=$(jq --raw-output '.ClusterName' ./output/aws-configuration.json) \
    --settings name=containerInsights,value=enabled \
    > ./output/ecs-create-cluster.json
```

ECS update cluster - switching to 

```bash
aws ecs update-cluster \
    --cluster $(jq --raw-output '.cluster.clusterName' ./output/ecs-create-cluster.json) \
    --configuration managedStorageConfiguration={fargateEphemeralStorageKmsKeyId=$(jq --raw-output '.KeyMetadata.KeyId' ./output/kms-create-key.json)}
```

### Create an AWS ECS task definition

#### Task definition

* Create new task definition
* Task definition family: observability-hub-grafana
* Launch type: AWS Fargate (serverless)
* OS, Architecture, Network mode: Linux/X86_64
* Network mode: awsvpc
* Task size
    * CPU: 1 vCPU
    * Memory: 3 GB
* Task role: None
* Task execution role: None

### Container 1

* Container details
    * Name:
    * Image URI:
    * Essential container: Yes

## Useful Resources

* [Securing Amazon ECS workloads on AWS Fargate with customer managed keys](https://aws.amazon.com/blogs/compute/securing-amazon-ecs-workloads-on-aws-fargate-with-customer-managed-keys/)



