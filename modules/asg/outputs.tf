output "launch_template_id" {
  value = aws_launch_template.ecs.id
}

output "asg_name" {
  value = aws_autoscaling_group.ecs.name
}

output "asg_arn" {
  value = aws_autoscaling_group.ecs.arn
}
