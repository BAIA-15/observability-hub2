from aws_cdk import (
    Duration,
    Stack,
    aws_sqs as sqs
)
from constructs import Construct

class GrafanaCdkStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # SQS resource
        queue = sqs.Queue(
             self, "CdkQueue",
             visibility_timeout=Duration.seconds(300),
        )
