provider "alicloud" {
  region = "cn-shenzhen"
}

data "alicloud_zones" "default" {
}

data "alicloud_resource_manager_resource_groups" "default" {
}

data "alicloud_db_instance_classes" "default" {
  engine         = "MySQL"
  engine_version = "5.6"
}

data "alicloud_regions" "this" {
  current = true
}

data "alicloud_market_products" "products" {
  search_term           = "Jenkins自动化部署"
  supplier_name_keyword = "科技"
  suggested_price       = 0
  product_type          = "MIRROR"
}

data "alicloud_market_product" "product" {
  product_code     = data.alicloud_market_products.products.products.0.code
  available_region = data.alicloud_regions.this.ids.0
}

data "alicloud_instance_types" "this" {
  cpu_core_count    = 2
  memory_size       = 4
  availability_zone = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_ecs_key_pair" "default" {
  key_pair_name = "key_pair_name_2022"
}

resource "alicloud_ram_role" "default" {
  name     = "tf-ram-name-2022"
  document = var.document
}

resource "alicloud_kms_key" "kms" {
  key_usage              = "ENCRYPT/DECRYPT"
  pending_window_in_days = var.pending_window_in_days
  status                 = "Enabled"
}

resource "alicloud_kms_ciphertext" "kms" {
  plaintext = "test"
  key_id    = alicloud_kms_key.kms.id
  encryption_context = {
    test = "test"
  }
}

resource "alicloud_ecs_disk" "default" {
  zone_id = data.alicloud_zones.default.zones.0.id
  size    = var.system_disk_size
}

resource "alicloud_ecs_snapshot" "default" {
  disk_id  = alicloud_ecs_disk_attachment.default.disk_id
  category = "standard"
  force    = var.force_delete
}

resource "alicloud_ecs_disk_attachment" "default" {
  disk_id     = alicloud_ecs_disk.default.id
  instance_id = module.ecs_instance.this_instance_id[0]
}

resource "alicloud_db_instance" "default" {
  engine           = "MySQL"
  engine_version   = "5.6"
  vswitch_id       = module.vpc.this_vswitch_ids[0]
  instance_type    = data.alicloud_db_instance_classes.default.instance_classes.0.instance_class
  instance_storage = var.instance_storage
}

resource "alicloud_mns_topic" "default" {
  name = "tf-topic-name-2022"
}

resource "alicloud_mns_queue" "default" {
  name = "tf-queue-name-2022"
}

# Create a new vpc using terraform module
module "vpc" {
  source             = "alibaba/vpc/alicloud"
  create             = true
  vpc_cidr           = "172.16.0.0/16"
  vswitch_cidrs      = ["172.16.0.0/21"]
  availability_zones = [data.alicloud_zones.default.zones.0.id]
}

# Create a new security and open all ports
module "security_group" {
  source              = "alibaba/security-group/alicloud"
  vpc_id              = module.vpc.this_vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}

module "ecs_instance" {
  source = "alibaba/ecs-instance/alicloud"

  number_of_instances = 1

  instance_type      = data.alicloud_instance_types.this.instance_types.0.id
  image_id           = data.alicloud_market_product.product.product.0.skus.0.images.0.image_id
  vswitch_ids        = [module.vpc.this_vswitch_ids[0]]
  security_group_ids = [module.security_group.this_security_group_id]
}

module "market_application_with_autoscaling_slb" {
  source = "../.."

  #alicloud_market_products
  product_keyword               = "Jenkins自动化部署"
  product_supplier_name_keyword = "科技"
  product_suggested_price       = 0

  # Autoscaling Group
  create_autoscaling = true

  scaling_group_name                       = var.scaling_group_name
  min_size                                 = var.min_size
  max_size                                 = var.max_size
  default_cooldown                         = var.default_cooldown
  vswitch_ids                              = module.vpc.this_vswitch_ids
  removal_policies                         = var.removal_policies
  db_instance_ids                          = [alicloud_db_instance.default.id]
  multi_az_policy                          = "COST_OPTIMIZED"
  on_demand_base_capacity                  = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
  spot_instance_pools                      = var.spot_instance_pools
  spot_instance_remedy                     = var.spot_instance_remedy

  # scaling configuration
  image_id                   = data.alicloud_market_product.product.product.0.skus.0.images.0.image_id
  instance_types             = data.alicloud_instance_types.this.ids
  security_group_ids         = [module.security_group.this_security_group_id]
  scaling_configuration_name = var.scaling_configuration_name
  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_in  = var.internet_max_bandwidth_in
  allocate_public_ip         = true
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  system_disk_category       = var.system_disk_category
  system_disk_size           = var.system_disk_size
  enable                     = var.enable
  active                     = var.active
  user_data                  = var.user_data
  key_name                   = alicloud_ecs_key_pair.default.id
  role_name                  = alicloud_ram_role.default.id
  force_delete               = var.force_delete
  password_inherit           = var.password_inherit
  ecs_instance_password      = "YourPassword123!"
  kms_encrypted_password     = "YourPassword123!"
  kms_encryption_context     = alicloud_kms_ciphertext.kms.encryption_context
  data_disks = [{
    delete_with_instance = true
    snapshot_id          = alicloud_ecs_snapshot.default.id
    size                 = 30
    category             = "cloud_efficiency"
  }]

  # ess_lifecycle_hook
  lifecycle_hook_name   = "tf-lifecycle-hook-name"
  lifecycle_transition  = var.lifecycle_transition
  heartbeat_timeout     = var.heartbeat_timeout
  hook_action_policy    = var.hook_action_policy
  mns_topic_name        = alicloud_mns_topic.default.name
  mns_queue_name        = alicloud_mns_queue.default.name
  notification_metadata = var.notification_metadata

  # Create SLB
  create_slb       = true
  use_existing_slb = false

  slb_name                 = var.slb_name
  slb_internet_charge_type = "PayByTraffic"
  address_type             = "intranet"
  vswitch_id               = module.vpc.this_vswitch_ids[0]
  slb_spec                 = var.slb_spec
  bandwidth                = var.bandwidth
  master_zone_id           = data.alicloud_zones.default.zones.0.id
  slave_zone_id            = data.alicloud_zones.default.zones.1.id
  slb_tags                 = var.slb_tags

  #alicloud_slb_server_group
  virtual_server_group_name = var.virtual_server_group_name

  #alicloud_slb_listener
  frontend_port = 80
  backend_port  = 80

  #alicloud_ess_scalinggroup_vserver_groups
  instance_port = var.instance_port
  weight        = var.weight

  # Create DNS
  bind_domain = false

}

# Bind a dns domain for this module
module "market_application_with_dns" {
  source = "../.."

  # Autoscaling Group
  create_autoscaling = false
  scaling_group_id   = module.market_application_with_autoscaling_slb.this_autoscaling_group_id

  # Create SLB
  create_slb       = false
  use_existing_slb = false

  # Create DNS
  bind_domain = true

  domain_name     = "dns168.abc"
  existing_slb_id = module.market_application_with_autoscaling_slb.this_slb_id
  dns_record      = var.dns_record

}