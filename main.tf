terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ECS Cluster
module "ecs_cluster" {
  source       = "./modules/ecs-cluster"
  cluster_name = var.cluster_name
}

# Auto Scaling Group for ECS EC2 capacity
module "asg" {
  source            = "./modules/asg"
  vpc_id            = var.vpc_id
  private_subnets   = var.private_subnets
  ecs_cluster_name  = module.ecs_cluster.name
  ecs_sg_ids        = concat(var.default_sg_ids, var.extra_sg_ids)
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  desired_capacity  = var.asg_desired_capacity
  min_size          = var.asg_min_size
  max_size          = var.asg_max_size
}

# Capacity Provider
resource "aws_ecs_capacity_provider" "asg_provider" {
  name = "${var.cluster_name}-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.asg.asg_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
    }
  }
}

# Attach capacity provider to ECS cluster
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = module.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.asg_provider.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.asg_provider.name
    weight            = 1
    base              = 1
  }
}
