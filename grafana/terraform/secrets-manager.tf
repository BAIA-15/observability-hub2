
data "aws_secretsmanager_random_password" "grafana_admin_secret_value" {
}

# aws secrets manager secret - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret
resource "aws_secretsmanager_secret" "grafana_admin_password" {
  name_prefix = "grafana/admin_password_"
  description = "Grafana Enterpise admin password"
}

resource "aws_secretsmanager_secret_version" "grafana_admin_secret_version" {
  secret_id     = aws_secretsmanager_secret.grafana_admin_password.id
  secret_string = data.aws_secretsmanager_random_password.grafana_admin_secret_value.random_password
}
