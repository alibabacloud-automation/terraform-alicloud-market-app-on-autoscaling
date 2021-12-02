variable "profile" {
  default = "default"
}

variable "region" {
  default = "cn-beijing"
}

provider "alicloud" {
  region  = var.region
  profile = var.profile
}
data "alicloud_zones" "default" {
}
#############################################################
# Data sources to get VPC, vswitch details
#############################################################

data "alicloud_vpcs" "default" {
  is_default = true
}

resource "alicloud_vpc" "default" {
  count = length(data.alicloud_vpcs.default.ids) > 0 ? 0 : 1
  cidr_block = "172.16.0.0/12"
  vpc_name = "test_vpc_007"
}

data "alicloud_vswitches" "default" {
  ids = [data.alicloud_vpcs.default.vpcs.0.vswitch_ids.0]
}

resource "alicloud_vswitch" "this" {
  count = length(data.alicloud_vswitches.default.ids) > 0 ? 0 : 1
  vswitch_name              = "redis_vpc_007"
  zone_id                   = data.alicloud_zones.default.zones[0].id
  vpc_id                    = length(data.alicloud_vpcs.default.ids) > 0 ?  data.alicloud_vpcs.default.vpcs.0.id : alicloud_vpc.default.0.id
  cidr_block                = "172.16.0.0/24"
}

data "alicloud_instance_types" "this" {
  cpu_core_count    = 1
  memory_size       = 2
  availability_zone = data.alicloud_zones.default.zones[0].id
}

resource "alicloud_mns_queue" "default" {
  name = "lifehooks"
}
#############################################################
# Create a new security and open all ports
#############################################################
module "security_group" {
  source              = "alibaba/security-group/alicloud"
  region              = var.region
  profile             = var.profile
  vpc_id              = length(data.alicloud_vpcs.default.ids) > 0 ?  data.alicloud_vpcs.default.vpcs.0.id : alicloud_vpc.default.0.id
  name                = "web-applacation"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}

module "market_app_on_autoscaling" {
  source  = "../.."
  region  = var.region
  profile = var.profile

  // product
  product_keyword = "jenkins"

  // Autoscaling Group
  scaling_group_name = "testAccEssScalingGroupTestDD"
  min_size           = 2
  max_size           = 4

  // Scaling configuration
  create_autoscaling         = true
  scaling_configuration_name = "testAccEssScalingConfigurationTest"
  ecs_instance_password      = "YourPassword123"
  instance_types             = [data.alicloud_instance_types.this.ids.0]
  system_disk_category       = "cloud_efficiency"
  security_group_ids         = [module.security_group.this_security_group_id]
  vswitch_ids                = [length(data.alicloud_vswitches.default.ids) > 0 ? data.alicloud_vswitches.default.ids.0 : alicloud_vswitch.this.0.id]
  frontend_port              = 8081

  // lifecycle hook
  lifecycle_hook_name = "lifehook"
  mns_queue_name      = alicloud_mns_queue.default.name

  // bind slb
  create_slb    = true
  slb_name      = "for-jenkins"
  bandwidth     = 5
  slb_spec      = "slb.s1.small"
  instance_port = 8080
  weight        = 50

  // bind dns
  bind_domain = true
  domain_name = "dns004.abc"
  dns_record = {
    host_record = "jenkins"
    type        = "A"
  }
}
