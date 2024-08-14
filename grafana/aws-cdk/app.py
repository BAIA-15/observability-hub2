#!/usr/bin/env python3
import os
import aws_cdk as cdk

from lib.cdk_stack import GrafanaCdkStack

env_NCS = cdk.Environment(account="851725631136", region="ap-southeast-2")
env_GNP = cdk.Environment(account="851725214198", region="ap-southeast-2")

app = cdk.App()
GrafanaCdkStack(
    app,
    "grafana-stack-ncs",
    env=env_NCS  # https://docs.aws.amazon.com/cdk/latest/guide/environments.html
)
app.synth()
