output "this_url_of_application" {
  description = "The url of web application with binding dns."
  value       = module.market_application_with_dns.this_application_url
}

output "this_slb_id_of_market_application" {
  description = "The slb id of web application binding dns."
  value       = module.market_application_with_autoscaling_slb.this_slb_id
}

output "this_autoscaling_group_vswitch_ids" {
  description = "The id of autoscaling group vswitch ."
  value       = module.market_application_with_autoscaling_slb.this_autoscaling_group_vswitch_ids
}

output "this_autoscaling_group_id" {
  description = "The id of scaling group"
  value       = module.market_application_with_autoscaling_slb.this_autoscaling_group_id
}

output "this_scaling_configuration_id" {
  description = "The id of scaling configuration"
  value       = module.market_application_with_autoscaling_slb.this_autoscaling_configuration_id
}

output "this_slb_listener_server_group_id" {
  description = "The backend server group id of slb listener."
  value       = module.market_application_with_autoscaling_slb.this_slb_listener_server_group_id
}

output "this_autoscaling_group_sg_ids" {
  description = "The security group ids associated with the autoscaling group."
  value       = module.market_application_with_autoscaling_slb.this_autoscaling_group_sg_ids
}

output "this_autoscaling_lifecycle_hook_id" {
  description = "The id of the lifecycle hook."
  value       = module.market_application_with_autoscaling_slb.this_autoscaling_lifecycle_hook_id
}