############################################
# Data source to get specified product image
############################################
data "alicloud_regions" "this" {
  current = true
}

data "alicloud_market_products" "products" {
  search_term           = var.product_keyword
  supplier_name_keyword = var.product_supplier_name_keyword
  suggested_price       = var.product_suggested_price
  product_type          = "MIRROR"
}

data "alicloud_market_product" "product" {
  product_code     = data.alicloud_market_products.products.products.0.code
  available_region = data.alicloud_regions.this.ids.0
}

############################################
# market-autoscaling
############################################
module "market-autoscaling" {
  source                  = "terraform-alicloud-modules/autoscaling/alicloud"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation

  // Autoscaling Group
  scaling_group_id   = var.scaling_group_id
  scaling_group_name = var.scaling_group_name
  max_size           = var.max_size
  min_size           = var.min_size
  default_cooldown   = var.default_cooldown
  vswitch_ids        = var.vswitch_ids
  removal_policies   = var.removal_policies
  db_instance_ids    = var.db_instance_ids

  // slb
  loadbalancer_ids = alicloud_slb.this.*.id

  multi_az_policy                          = var.multi_az_policy
  on_demand_base_capacity                  = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
  spot_instance_pools                      = var.spot_instance_pools
  spot_instance_remedy                     = var.spot_instance_remedy

  // scaling configuration
  create_scaling_configuration = var.create_autoscaling
  image_id                     = var.image_id != "" ? var.image_id : data.alicloud_market_product.product.product.0.skus.0.images.0.image_id
  instance_types               = var.instance_types
  instance_name                = "market-app-ess-${var.product_keyword}"
  security_group_ids           = var.security_group_ids
  scaling_configuration_name   = var.scaling_configuration_name
  internet_charge_type         = var.internet_charge_type
  internet_max_bandwidth_in    = var.internet_max_bandwidth_in
  associate_public_ip_address  = var.allocate_public_ip
  internet_max_bandwidth_out   = var.internet_max_bandwidth_out
  system_disk_category         = var.system_disk_category
  system_disk_size             = var.system_disk_size
  enable                       = true
  active                       = true
  user_data                    = var.user_data
  key_name                     = var.key_name
  role_name                    = var.role_name
  force_delete                 = true
  password_inherit             = var.password_inherit
  password                     = var.ecs_instance_password
  kms_encrypted_password       = var.kms_encrypted_password
  kms_encryption_context       = var.kms_encryption_context
  data_disks                   = var.data_disks

  // ess_lifecycle_hook
  create_lifecycle_hook = var.create_autoscaling
  lifecycle_hook_name   = var.lifecycle_hook_name
  lifecycle_transition  = var.lifecycle_transition
  heartbeat_timeout     = var.heartbeat_timeout
  hook_action_policy    = var.hook_action_policy
  mns_topic_name        = var.mns_topic_name
  mns_queue_name        = var.mns_queue_name
  notification_metadata = var.notification_metadata
}
############################################
# Create SLB
############################################
locals {
  create_slb       = var.min_size > 0 ? var.create_slb : false
  create_slb_group = var.use_existing_slb || var.create_slb ? true : false
  this_slb_id      = var.use_existing_slb ? var.existing_slb_id : var.create_slb ? concat(alicloud_slb.this.*.id, [""])[0] : ""
}

resource "alicloud_slb" "this" {
  count = local.create_slb ? 1 : 0

  name                 = var.slb_name
  internet_charge_type = var.internet_charge_type
  address_type         = "internet"
  specification        = var.slb_spec == "" ? null : var.slb_spec
  bandwidth            = var.bandwidth
  tags                 = var.slb_tags
  master_zone_id       = var.master_zone_id == "" ? null : var.master_zone_id
  slave_zone_id        = var.slave_zone_id == "" ? null : var.slave_zone_id
}

resource "alicloud_slb_server_group" "this" {
  count            = local.create_slb_group ? 1 : 0
  load_balancer_id = local.this_slb_id
  name             = var.virtual_server_group_name != "" ? var.virtual_server_group_name : "${var.slb_name}-virtual"
}

resource "alicloud_slb_listener" "this" {
  count            = local.create_slb || var.use_existing_slb ? 1 : 0
  frontend_port    = var.frontend_port
  backend_port     = var.backend_port
  load_balancer_id = local.this_slb_id
  protocol         = "http"
  bandwidth        = var.bandwidth
  server_group_id  = concat(alicloud_slb_server_group.this.*.id, [""])[0]
}

resource "alicloud_ess_scalinggroup_vserver_groups" "this" {
  scaling_group_id = module.market-autoscaling.this_autoscaling_group_id
  vserver_groups {
    loadbalancer_id = concat(alicloud_slb.this.*.id, [""])[0]
    vserver_attributes {
      port             = var.instance_port
      vserver_group_id = concat(alicloud_slb_server_group.this.*.id, [""])[0]
      weight           = var.weight
    }
  }
}

############################################
# Create DNS
############################################
data "alicloud_slbs" "this" {
  ids = var.existing_slb_id != "" ? [var.existing_slb_id] : null
}

locals {
  allocate_public_ip = var.min_size > 0 ? false : local.create_slb == true ? false : var.allocate_public_ip
  create_dns         = var.create_slb || var.use_existing_slb || var.min_size > 0 ? var.bind_domain : local.allocate_public_ip ? var.bind_domain : false
  value              = var.create_slb || var.use_existing_slb ? var.existing_slb_id != "" ? data.alicloud_slbs.this.address : concat(alicloud_slb.this.*.address, [""])[0] : null
  records = [
    {
      value    = local.value
      rr       = lookup(var.dns_record, "host_record", "")
      type     = lookup(var.dns_record, "type", "")
      ttl      = lookup(var.dns_record, "ttl", 600)
      priority = lookup(var.dns_record, "priority", 1)
      line     = lookup(var.dns_record, "line", "default")
    }
  ]
  this_app_url = var.bind_domain ? format("%s%s", lookup(var.dns_record, "host_record", "") != "" ? "${lookup(var.dns_record, "host_record", "")}." : "", var.domain_name) : local.create_slb ? format("%s:${var.frontend_port}", concat(alicloud_slb.this.*.address, [""])[0]) : ""
}

module "dns" {
  source                  = "terraform-alicloud-modules/dns/alicloud"
  region                  = var.region
  profile                 = var.profile
  shared_credentials_file = var.shared_credentials_file
  skip_region_validation  = var.skip_region_validation

  create      = local.create_dns
  domain_name = var.domain_name
  records     = local.records
}
