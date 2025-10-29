output "ecs_cluster_name" {
  value = module.ecs_cluster.name
}

output "asg_name" {
  value = module.asg.asg_name
}

output "launch_template_id" {
  value = module.asg.launch_template_id
}

output "asg_arn" {
  value = module.asg.asg_arn
}

output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.asg_provider.name
}
