
output "account_id" {
  description = "Selected AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "Details about selected AWS region"
  value       = data.aws_region.current.name
}

output "my_computer_public_ip" {
  description = "Computer IP allowed to talk to ALB"
  value       = chomp(data.http.icanhazip.response_body)
}

output "alb_dns" {
  description = "DNS of ALB"
  value       = aws_lb.grafana.dns_name
}
