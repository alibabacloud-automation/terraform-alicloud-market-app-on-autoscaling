#alicloud_kms_key
pending_window_in_days = 7

#alicloud_ram_role
document = <<EOF
		{
		  "Statement": [
			{
			  "Action": "sts:AssumeRole",
			  "Effect": "Allow",
			  "Principal": {
				"Service": [
				  "ecs.aliyuncs.com"
				]
			  }
			}
		  ],
		  "Version": "1"
		}
	    EOF

#alicloud_db_instance
instance_storage = "50"

#alicloud_ess_scaling_group
scaling_group_name                       = "update-tf-scaling-group-name"
min_size                                 = 2
max_size                                 = 4
default_cooldown                         = 320
removal_policies                         = ["OldestInstance", "NewestInstance"]
on_demand_base_capacity                  = 10
on_demand_percentage_above_base_capacity = 10
spot_instance_pools                      = 8
spot_instance_remedy                     = false
scaling_configuration_name               = "update-tf-scaling-configuration-name"
internet_charge_type                     = "PayByBandwidth"
internet_max_bandwidth_out               = 20
system_disk_category                     = "cloud_ssd"
system_disk_size                         = 60
enable                                   = false
user_data                                = "update-tf-user-data"
force_delete                             = true
password_inherit                         = true

#alicloud_ess_lifecycle_hook
lifecycle_transition  = "SCALE_OUT"
heartbeat_timeout     = 610
hook_action_policy    = "ABANDON"
notification_metadata = "update-tf-autoscaling"

# slb
slb_name  = "update-tf-testacc-slb-name"
slb_spec  = "slb.s2.medium"
bandwidth = 20
slb_tags = {
  Name = "updateSLB"
}
virtual_server_group_name = "update-tf-testacc-server-group-name"
instance_port             = 90
weight                    = 20

# dns
dns_record = {
  host_record = "updatejenkins"
  type        = "A"
  ttl         = 1200
  priority    = 2
  line        = "telecom"
}