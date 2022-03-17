variable "region" {
  description = "(Deprecated from version 1.1.0) The region used to launch this module resources."
  type        = string
  default     = ""
}

variable "profile" {
  description = "(Deprecated from version 1.1.0) The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  type        = string
  default     = ""
}

variable "shared_credentials_file" {
  description = "(Deprecated from version 1.1.0) This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  type        = string
  default     = ""
}

variable "skip_region_validation" {
  description = "(Deprecated from version 1.1.0) Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  type        = bool
  default     = false
}

###################
# Market Product
###################
variable "product_keyword" {
  description = "The name keyword of Market Product used to fetch the specified product image."
  type        = string
  default     = ""
}

variable "product_supplier_name_keyword" {
  description = "The name keyword of Market Product supplier name used to fetch the specified product image."
  type        = string
  default     = ""
}

variable "product_suggested_price" {
  description = "The suggested price of Market Product used to fetch the specified product image."
  type        = number
  default     = 0
}

###################
# Autoscaling Group
###################
variable "create_autoscaling" {
  description = "Whether to create scaling resource."
  type        = bool
  default     = true
}

variable "scaling_group_id" {
  description = "Specifying existing autoscaling group ID. If not set, a new one will be created named with 'scaling_group_name'."
  type        = string
  default     = ""
}

variable "scaling_group_name" {
  description = "The name for autoscaling group. Default to a random string prefixed with 'terraform-ess-group-'."
  type        = string
  default     = ""
}

variable "min_size" {
  description = "Minimum number of ECS instances in the scaling group."
  type        = string
  default     = 1
}

variable "max_size" {
  description = "Maximum number of ECS instance in the scaling group."
  type        = number
  default     = 3
}

variable "default_cooldown" {
  description = "The amount of time (in seconds),after a scaling activity completes before another scaling activity can start."
  type        = string
  default     = 300
}

variable "vswitch_ids" {
  description = "Virtual switch IDs in which the ecs instances to be launched."
  type        = list(string)
  default     = []
}

variable "removal_policies" {
  description = "RemovalPolicy is used to select the ECS instances you want to remove from the scaling group when multiple candidates for removal exist."
  type        = list(string)
  default = [
    "OldestScalingConfiguration",
    "OldestInstance",
  ]
}

variable "db_instance_ids" {
  description = "A list of rds instance ids to add to the autoscaling group. If not set, it can be retrieved automatically by specifying filter 'rds_name_regex' or 'rds_tags'."
  type        = list(string)
  default     = []
}

variable "multi_az_policy" {
  description = "Multi-AZ scaling group ECS instance expansion and contraction strategy. PRIORITY, BALANCE or COST_OPTIMIZED."
  type        = string
  default     = "PRIORITY"
}

variable "on_demand_base_capacity" {
  description = "The minimum amount of the Auto Scaling group's capacity that must be fulfilled by On-Demand Instances. This base portion is provisioned first as your group scales."
  type        = number
  default     = 0
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Controls the percentages of On-Demand Instances and Spot Instances for your additional capacity beyond OnDemandBaseCapacity."
  type        = number
  default     = 0
}

variable "spot_instance_pools" {
  description = "The number of Spot pools to use to allocate your Spot capacity. The Spot pools is composed of instance types of lowest price."
  type        = number
  default     = 0
}

variable "spot_instance_remedy" {
  description = "Whether to replace spot instances with newly created spot/onDemand instance when receive a spot recycling message."
  type        = bool
  default     = true
}

variable "image_id" {
  description = "The image id used to launch ecs instances."
  type        = string
  default     = ""
}

variable "instance_types" {
  description = "A list of ECS instance types. If not set, one will be returned automatically by specifying 'cpu_core_count' and 'memory_size'. If it is set, 'instance_type' will be ignored."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List IDs of the security group to which a newly created instance belongs."
  type        = list(string)
  default     = []
}

variable "scaling_configuration_name" {
  description = "Name for the autoscaling configuration. Default to a random string prefixed with `terraform-ess-configuration-`."
  type        = string
  default     = ""
}

variable "internet_charge_type" {
  description = "The ECS instance network billing type: PayByTraffic or PayByBandwidth."
  type        = string
  default     = "PayByTraffic"
}

variable "internet_max_bandwidth_in" {
  description = "Maximum incoming bandwidth from the public network."
  type        = number
  default     = 200
}

variable "allocate_public_ip" {
  description = "Whether to associate a public ip address with an instance in a VPC."
  type        = bool
  default     = false
}

variable "internet_max_bandwidth_out" {
  description = "Maximum outgoing bandwidth from the public network. It will be ignored when 'associate_public_ip_address' is false."
  type        = number
  default     = 0
}

variable "system_disk_category" {
  description = "Category of the system disk."
  type        = string
  default     = "cloud_efficiency"
}

variable "system_disk_size" {
  description = "Size of the system disk."
  type        = number
  default     = 50
}

variable "enable" {
  description = "Whether enable the specified scaling group(make it active) to which the current scaling configuration belongs."
  type        = bool
  default     = true
}

variable "active" {
  description = "Whether active current scaling configuration in the specified scaling group"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User-defined data to customize the startup behaviors of the ECS instance and to pass data into the ECS instance."
  type        = string
  default     = ""
}

variable "key_name" {
  description = "The name of key pair that login ECS."
  type        = string
  default     = ""
}

variable "role_name" {
  description = "Instance RAM role name."
  type        = string
  default     = ""
}

variable "force_delete" {
  description = "The last scaling configuration will be deleted forcibly with deleting its scaling group"
  type        = bool
  default     = true
}

variable "password_inherit" {
  description = "Specifies whether to use the password that is predefined in the image. If true, the 'password' and 'kms_encrypted_password' will be ignored. You must ensure that the selected image has a password configured."
  type        = bool
  default     = false
}

variable "ecs_instance_password" {
  description = "The password of the ECS instance. It is valid when 'password_inherit' is false"
  type        = string
  default     = ""
}

variable "kms_encrypted_password" {
  description = "An KMS encrypts password used to a db account. If 'password_inherit' and 'password' is set, this field will be ignored."
  type        = string
  default     = ""
}

variable "kms_encryption_context" {
  description = "An KMS encryption context used to decrypt 'kms_encrypted_password' before creating ECS instance. See Encryption Context: https://www.alibabacloud.com/help/doc-detail/42975.htm. It is valid when kms_encrypted_password is set."
  type        = map(string)
  default     = {}
}

variable "data_disks" {
  description = "Additional data disks to attach to the scaled ECS instance."
  type        = list(map(string))
  default     = []
}

###################
# ess_lifecycle_hook
###################
variable "lifecycle_hook_name" {
  description = "The name for lifecyle hook. Default to a random string prefixed with 'terraform-ess-hook-'."
  type        = string
  default     = ""
}

variable "lifecycle_transition" {
  description = "Type of Scaling activity attached to lifecycle hook. Supported value: SCALE_OUT, SCALE_IN."
  type        = string
  default     = "SCALE_IN"
}

variable "heartbeat_timeout" {
  description = "Defines the amount of time, in seconds, that can elapse before the lifecycle hook times out. When the lifecycle hook times out, Auto Scaling performs the action defined in the default_result parameter."
  type        = number
  default     = 600
}

variable "hook_action_policy" {
  description = "Defines the action which scaling group should take when the lifecycle hook timeout elapses. Valid value: CONTINUE, ABANDON."
  type        = string
  default     = "CONTINUE"
}

variable "mns_topic_name" {
  description = "Specify a MNS topic to send notification."
  type        = string
  default     = ""
}

variable "mns_queue_name" {
  description = "Specify a MNS queue to send notification. It will be ignored when 'mns_topic_name' is set."
  type        = string
  default     = ""
}

variable "notification_metadata" {
  description = "Additional information that you want to include when Auto Scaling sends a message to the notification target."
  type        = string
  default     = ""
}

###################
# slb
###################
variable "create_slb" {
  description = "Whether to create a balancer instance."
  type        = bool
  default     = false
}

variable "use_existing_slb" {
  description = "Whether to use an existing load balancer instance. If true, 'existing_slb_id' should not be empty. Also, you can create a new one by setting 'create = true'."
  type        = bool
  default     = false
}

variable "existing_slb_id" {
  description = "An existing load balancer instance id."
  type        = string
  default     = ""
}

variable "slb_name" {
  description = "The name of a new load balancer."
  type        = string
  default     = ""
}

variable "slb_internet_charge_type" {
  description = "The charge type of load balancer instance internet network."
  type        = string
  default     = "PayByTraffic"
}

variable "address_type" {
  description = "The type if address. Choices are 'intranet' and 'internet'. Default to 'internet'."
  type        = string
  default     = "internet"
}

variable "vswitch_id" {
  description = "The vswitch id used to launch load balancer."
  type        = string
  default     = ""
}

variable "slb_spec" {
  description = "The specification of the SLB instance."
  type        = string
  default     = ""
}

variable "bandwidth" {
  description = "The load balancer instance bandwidth."
  type        = number
  default     = 10
}

variable "master_zone_id" {
  description = "The primary zone ID of the SLB instance. If not specified, the system will be randomly assigned."
  type        = string
  default     = ""
}

variable "slave_zone_id" {
  description = "The standby zone ID of the SLB instance. If not specified, the system will be randomly assigned."
  type        = string
  default     = ""
}

variable "slb_tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "virtual_server_group_name" {
  description = "The name virtual server group. If not set, the 'name' and adding suffix '-virtual' will return."
  type        = string
  default     = ""
}

variable "frontend_port" {
  description = "The fronted port of balancer."
  type        = number
  default     = 8080
}

variable "backend_port" {
  description = "The backend port of balancer."
  type        = number
  default     = 8080
}

variable "instance_port" {
  description = "The port will be used for VServer Group backend server."
  type        = number
  default     = 8080
}

variable "weight" {
  description = "The weight of an ECS instance attached to the VServer Group."
  type        = number
  default     = 50
}

###################
# dns
###################
variable "bind_domain" {
  description = "Whether to bind domain."
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "The name of domain."
  type        = string
  default     = ""
}

variable "dns_record" {
  description = "DNS record. Each item can contains keys: 'host_record'(The host record of the domain record.),'type'(The type of the domain. Valid values: A, NS, MX, TXT, CNAME, SRV, AAAA, CAA, REDIRECT_URL, FORWORD_URL. Default to A.),'priority'(The priority of domain record. Valid values are `[1-10]`. When the `type` is `MX`, this parameter is required.),'ttl'(The ttl of the domain record. Default to 600.),'line'(The resolution line of domain record. Default value is default.)."
  type        = map(string)
  default     = {}
}