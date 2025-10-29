variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "ecs_cluster_name" { type = string }
variable "ecs_sg_ids" { type = list(string) }
variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "key_name" {
  type    = string
  default = null
}
variable "desired_capacity" { type = number }
variable "min_size" { type = number }
variable "max_size" { type = number }
