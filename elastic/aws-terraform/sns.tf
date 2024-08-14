
# Resource: aws_sns_topic - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic
resource "aws_sns_topic" "elastic" {
  name              = var.ec2_name_prefix
  display_name      = var.ec2_name_prefix
  kms_master_key_id = "alias/aws/sns"
  tags = {
    Name = "${var.ec2_name_prefix}"
  }
}

# Resource: aws_sns_topic_subscription - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.elastic.arn
  protocol  = "email"
  endpoint  = "jacob.cantwell@gmail.com"
}
