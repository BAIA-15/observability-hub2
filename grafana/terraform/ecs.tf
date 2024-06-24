
####################################################################################################
### ECS Cluster o11y ###
####################################################################################################

module "ecs_cluster" {
  source = "https://github.com/EzzioMoreira/aws-terraform-module//modules/ecs-cluster?ref=v0.0.1-ecs-cluster-alb"
  cluster_name  = "ecs-cluster-example"
  min_size      = 1
  max_size      = 2
  desired_size  = 1
  instance_type = "t3a.medium"
  vpc_id        = "vpc-xxxxxxxx"
  tags = {
    created_by    = "terraform"
    documentation = "null"
    env           = "prod"
    repository    = "ezziomoreira/aws-terraform-modules"
    service       = "observability"
    team          = "sre"
  }
}

####################################################################################################
### Loadbalance o11y ###
####################################################################################################
module "loadbalance" {
  source = "https://github.com/EzzioMoreira/aws-terraform-module//modules/loadbalance?ref=v0.0.1-ecs-cluster-alb"
  name               = "ecs-cluster-example-internal"
  type               = "application"
  internal           = true
  subnet_ids         = ["subnet-xyxyx", "subnet-yxyxyx"]
  security_group_ids = [sg-123123123]
  tags = {
    created_by    = "terraform"
    documentation = "null"
    env           = "prod"
    repository    = "ezziomoreira/aws-terraform-modules"
    service       = "observability"
    team          = "sre"
  }
}
