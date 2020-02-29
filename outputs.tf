######################
# slb outputs
######################
output "this_slb_public_address" {
  description = "The slb public address."
  value       = concat(alicloud_slb.this.*.address, [""])[0]
}

output "this_slb_id" {
  description = "The slb id."
  value       = concat(alicloud_slb.this.*.id, [""])[0]
}

output "this_slb_name" {
  description = "The slb name."
  value       = concat(alicloud_slb.this.*.name, [""])[0]
}

output "this_slb_listener_frontend_port" {
  description = "The frontend_port of slb listener."
  value       = concat(alicloud_slb_listener.this.*.frontend_port, [""])[0]
}

output "this_slb_listener_protocol" {
  description = "The protocol of slb listener."
  value       = concat(alicloud_slb_listener.this.*.protocol, [""])[0]
}

output "this_slb_listener_server_group_id" {
  description = "The backend server group id of slb listener."
  value       = concat(alicloud_slb_listener.this.*.server_group_id, [""])[0]
}

######################
# dns outputs
######################
output "this_dns_record_host_record" {
  description = "The host_record of dns record."
  value       = module.dns.this_domain_records
}

output "this_dns_record_name" {
  description = "The domain of dns record."
  value       = module.dns.this_domain_name
}

output "this_application_url" {
  description = "The url of ecs cluster."
  value       = format("http://%s", local.this_app_url)
}

######################
# Autoscaling module
######################
output "this_autoscaling_configuration_id" {
  description = "The id of the autoscaling configuration."
  value       = module.market-autoscaling.this_autoscaling_configuration_id
}

output "this_autoscaling_configuration_name" {
  description = "The name of the autoscaling configuration."
  value       = module.market-autoscaling.this_autoscaling_configuration_name
}

output "this_autoscaling_group_id" {
  description = "The id of the autoscaling group."
  value       = module.market-autoscaling.this_autoscaling_group_id
}

output "this_autoscaling_group_name" {
  description = "The name of the autoscaling group."
  value       = module.market-autoscaling.this_autoscaling_group_name
}

output "this_autoscaling_group_min_size" {
  description = "The minimum size of the autoscaling group."
  value       = module.market-autoscaling.this_autoscaling_group_min_size
}

output "this_autoscaling_group_max_size" {
  description = "The maximum size of the autoscaling group."
  value       = module.market-autoscaling.this_autoscaling_group_max_size
}

output "this_autoscaling_group_default_cooldown" {
  description = "The default cooldown of the autoscaling group."
  value       = module.market-autoscaling.this_autoscaling_group_default_cooldown
}

output "this_autoscaling_group_load_balancers" {
  description = "The load balancer ids associated with the autoscaling group."
  value       = module.market-autoscaling.this_autoscaling_group_load_balancers
}

output "this_autoscaling_group_rds_instance_ids" {
  description = "The rds instance ids associated with the autoscaling group."
  value       = module.market-autoscaling.this_autoscaling_group_rds_instance_ids
}

output "this_autoscaling_group_vswitch_ids" {
  description = "The vswitch ids associated with the autoscaling group."
  value       = concat(module.market-autoscaling.this_autoscaling_group_vswitch_ids, [""])[0]
}

output "this_autoscaling_group_sg_ids" {
  description = "The security group ids associated with the autoscaling group."
  value       = concat(module.market-autoscaling.this_autoscaling_group_sg_ids, [""])[0]
}

output "this_autoscaling_group_multi_az_policy" {
  description = "Multi-AZ scaling group ECS instance expansion and contraction strategy."
  value       = module.market-autoscaling.this_autoscaling_group_multi_az_policy
}

output "this_autoscaling_group_on_demand_base_capacity" {
  description = "The minimum amount of the Auto Scaling group's capacity that must be fulfilled by On-Demand Instances."
  value       = module.market-autoscaling.this_autoscaling_group_on_demand_base_capacity
}

output "this_autoscaling_group_on_demand_percentage_above_base_capacity" {
  description = "Controls the percentages of On-Demand Instances and Spot Instances for your additional capacity beyond OnDemandBaseCapacity."
  value       = module.market-autoscaling.this_autoscaling_group_on_demand_percentage_above_base_capacity
}

output "this_autoscaling_group_spot_instance_pools" {
  description = "The number of Spot pools to use to allocate your Spot capacity."
  value       = module.market-autoscaling.this_autoscaling_group_spot_instance_pools
}

output "this_autoscaling_group_spot_instance_remedy" {
  description = "Whether to replace spot instances with newly created spot/onDemand instance when receive a spot recycling message."
  value       = module.market-autoscaling.this_autoscaling_group_spot_instance_remedy
}

output "this_autoscaling_lifecycle_hook_id" {
  description = "The id of the lifecycle hook."
  value       = module.market-autoscaling.this_autoscaling_lifecycle_hook_id
}

output "this_autoscaling_lifecycle_hook_name" {
  description = "The name of the lifecycle hook."
  value       = module.market-autoscaling.this_autoscaling_lifecycle_hook_name
}

output "this_autoscaling_lifecycle_hook_notification_arn" {
  description = "The notification arn of the lifecycle hook."
  value       = module.market-autoscaling.this_autoscaling_lifecycle_hook_notification_arn
}