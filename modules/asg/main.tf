resource "aws_launch_template" "ecs" {
  name_prefix            = "ecs-ec2-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.ecs_sg_ids

  user_data = base64encode(<<-EOT
    #!/bin/bash
    echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
  EOT
  )
}

resource "aws_autoscaling_group" "ecs" {
  name                = "${var.ecs_cluster_name}-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  protect_from_scale_in = true

  tag {
    key                 = "Name"
    value               = "${var.ecs_cluster_name}-ec2"
    propagate_at_launch = true
  }
}
