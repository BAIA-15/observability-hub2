#!/bin/bash

export TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
export instance_id=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/1.0/meta-data/instance-id`
export http_proxy=${forward_proxy}
export HTTPS_PROXY=${forward_proxy}

# This will need to be updated if VPC endpoints start getting used
export no_proxy=169.254.169.254

# This will not be needed if VPC endpoints are in use
mkdir -p /etc/systemd/system/amazon-ssm-agent.service.d
cat <<EOF > /etc/systemd/system/amazon-ssm-agent.service.d/override.conf
[Service]
Environment="http_proxy=${forward_proxy}"
Environment="https_proxy=${forward_proxy}"
Environment="no_proxy=169.254.169.254"
EOF

systemctl daemon-reload && systemctl restart amazon-ssm-agent

# Install PIP for the version of Python Ansible uses
python3.11 -m ensurepip

aws ssm send-command --document-name "AWS-ApplyAnsiblePlaybooks" --document-version "1" --targets '[{"Key":"InstanceIds","Values":['"\"$instance_id\""']}]' \
--parameters '{"SourceType":["S3"],"SourceInfo":["{\"path\": \"https://${playbook_bucket}.s3.${region}.amazonaws.com\"}"],"InstallDependencies":["False"],"PlaybookFile":["${playbook_key}"],"ExtraVariables":["SSM=True ansible_python_interpreter=/bin/python3.11"],"Check":["False"],"Verbose":["-v"],"TimeoutSeconds":["3600"]}' \
--timeout-seconds 600 --max-concurrency "50" --max-errors "0" --output-s3-bucket-name "${playbook_bucket}" --region ${region}
