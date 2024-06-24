


* Signin to the AWS Management Console
* Open CloudShell

Follow the [Terraform installation instructions for Amazon Linux](https://developer.hashicorp.com/terraform/install).

```bash
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform --version
```

```bash
mkdir deploy-elastic-agent
cd deploy-elastic-agent
```

Create a main.tf file and paste contents

```
terraform init
terraform fmt
terraform validate
terraform apply
terraform show
terraform state list
terraform destroy
```


