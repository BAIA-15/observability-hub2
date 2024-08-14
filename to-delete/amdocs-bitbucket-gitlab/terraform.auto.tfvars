acm_cert_domain = "*.csi.gnpaws.au.singtelgroup.net"
ami_id          = "ami-08293b1fc4da5760a"
bitbucket_admin_user = {
  display_name = "BitBucket Admin"
  email        = "some_email@some_domain.com"
  username     = "bitbucket_admin"
}
bitbucket_installer  = "atlassian-bitbucket-8.19.1-x64.bin"
bitbucket_license    = "MIIDKDCCAhCgAwIBAgIQLqMbgF80Je/SsucU7caddTANBgkqhkiG9w0BAQsFADAuMQ4wDAYDVQQDDAVvcHR1czEcMBoGA1UEAwwTUmFkaWFudCBMb2dpYywgSW5jLjAeFw0yMDA5MTQxMjIzMjJaFw0yNTA5MTUxMjIzMjJaMC4xDjAMBgNVBAMMBW9wdHVzMRwwGgYDVQQDDBNSYWRpYW50IExvZ2ljLCBJbmMuMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAon3dKwbqxuCmFc8YUNUZsbenoH8uIDo5Kmzj+7Fu0CZ0qfdTGhs97c9bXe8IijvnQ5+4VfHuPp/1YtcjcAfaVF8D1C3XZRsnVqA+9ZJhQ0gojIcgjXK0plBsw7PxuuXjvB6qEbURO+NZIY8/WZ6XTWzXl/AAwdDNisXAG1upVcQCLYorTjBfzYSODqkTPJSYMKiGAPHwFiN6wJcZPFPUg2UxNqB67zuCoKjhc/J5RcBcLaTr0OKmLAi8dTcCSk+ln6BgSUI4MflJ4bnIOANXFga487KOMFT0lLt22+R4dATmO6o1SkI1QxvIJnJel33LMYigybK4I8gzIxNghiXO4wIDAQABo0IwQDAdBgNVHQ4EFgQU3CZU0kpbIF0XwEZifryNc11XQAwwEgYDVR0TAQH/BAgwBgEB/wIBADALBgNVHQ8EBAMCAYYwDQYJKoZIhvcNAQELBQADggEBAAqjhqO75AD8wrABpOAUs0beUoD5iVJuu+UWlybZqHS3AAUKZuJmckc4PB+7Pf4HBQOcu7kN8iqBhQ9j25HBSbdFIIbUqcNNpWUrj7+JZwPvdCbo0PyuPHKo3T+Nz0sFLx0AE8s/5pqegjgTkJjNqPXpLm6rb/x0s3cbPf/D/lkph9fRp8bTn0c5BPjSPFcG/uKFQKl6dCR2FAlOV3VE0kF0esKdx9uNbu69d/xlP/rHnju8il5kTbEPQhBLeeTbUr8IDo9d0fcsdjAc9tMrDO/7ohN0EUM0p7xFh/1JsGKzeilYja45eUKz2wlegoaz3Z1CQvEYjqEJInVB3i4orxw="
bitbucket_version    = "8.19.1"
customer_kms_key_arn = "arn:aws:kms:ap-southeast-2:339713147971:key/mrk-bf4e2880339447e49c429c69366f944d"
deployment_role_arn  = "arn:aws:iam::339713147971:role/coretooling-gitlabci-bitbucket"
ec2_subnet_ids       = ["subnet-0d1fe687360225a19"]
environment          = "amdocs-tooling-dev"
host_name            = "ctodevbitla001"
forward_proxy        = "http://10.110.157.26:3128"
forward_proxy_cidrs  = "10.110.157.26/32,10.110.157.55/32"
instance_type        = "t3.large"
ldap_server_cidrs    = "10.10.193.195/32,10.10.193.196/32,10.32.224.4/32,10.33.124.10/32,10.42.58.51/32,10.42.58.52/32,10.59.57.1/32,10.8.36.1/32,10.8.37.94/32,10.10.195.178/32"
nlb_ingress_cidr     = ["10.0.0.0/8"]
nlb_subnets = [
  {
    private_ipv4_address = "10.104.178.38"
    subnet_id            = "subnet-0d34f02972a139b67"
  },
  {
    private_ipv4_address = "10.104.178.54"
    subnet_id            = "subnet-0203ad8da9f100961"
  }
]
permissions_boundary_arn = "arn:aws:iam::339713147971:policy/ToolingBoundaryPolicy"
rds_instance_type        = "db.t4g.medium"
rds_subnet_ids = [
  "subnet-01b67578416f847f8",
  "subnet-0534d3a07a03235f5"
]
root_block_device_size = 100
route53_role_arn       = "arn:aws:iam::530211118880:role/route53_records_339713147971"
route53_zone_id        = "Z0474464ASIEM7CWRYZB"
smtp_server_cidrs      = "10.121.48.17/32,10.120.48.230/32,10.120.48.231/32,10.120.48.232/32,10.120.48.233/32,10.121.48.16/32,10.10.192.158/32,10.8.192.11/32,10.121.48.5/32,10.120.48.218/32"
ssh_key_name           = "ec2-key"
vpc_id                 = "vpc-09746b06f90d3ad5b"
zone_name              = "csi.gnpaws.au.singtelgroup.net"
