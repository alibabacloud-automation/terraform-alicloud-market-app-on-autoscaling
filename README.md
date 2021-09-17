Terraform Module for creating web application based on Alibaba Cloud market place ECS image and creating Autoscaling group and Autoscaling configuration.
terraform-alicloud-market-app-on-autoscaling
=============================================

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-on-autoscaling/blob/master/README-CN.md)

Terraform Module will be based on the ECS mirror provided by the Alicloud market to implement the autoscaling application environment.

## Terraform versions

The Module requires Terraform 0.12 and Terraform Provider AliCloud 1.71.0+.

## Usage

Building the web application (e.g.,jenkins) using market place image and create Autoscaling group and Autoscaling configuration.

```hcl
module "market_app_on_autoscaling" {
  source                     = "terraform-alicloud-modules/market-app-on-autoscaling/alicloud"
  region                     = "cn-beijing"
  profile                    = "Your-Profile-Name"

  // product
  product_keyword = "jenkins"

  // Autoscaling Group
  scaling_group_name = "testAccEssScalingGroup"
  min_size           = 3
  max_size           = 4

  // Scaling configuration
  create_autoscaling         = true
  scaling_configuration_name = "testAccEssScalingConfiguration"
  ecs_instance_password      = "YourPassword123"
  instance_types             = "ecs.sn1ne.large"
  system_disk_category       = "cloud_efficiency"
  security_group_ids         = ["sg-2ze0zgaj3hne6aid****"]
  vswitch_ids                = ["vsw-2ze79rz1livcjkfb*****"]
  frontend_port              = 8081

  // Scaling lifecycle hook
  lifecycle_hook_name = "lifehook"
  mns_queue_name      = "sdfwede12****"

  // bind slb
  create_slb    = true
  slb_name      = "for-jenkins"
  bandwidth     = 5
  slb_spec      = "slb.s1.small"
  instance_port = 8080
  weight        = 50

  // bind dns
  bind_domain = true
  domain_name = "dns001.abc"
  dns_record = {
    host_record = "jenkins"
    type        = "A"
  }
}
```

Building the web application (e.g.,java) using market place image and create Autoscaling group and Autoscaling configuration.

```hcl
module "java_ess" {
  source                     = "terraform-alicloud-modules/market-app-on-autoscaling/alicloud"
  region                     = "cn-beijing"
  profile                    = "Your-Profile-Name"

  // product
  product_keyword = "java"

  // Autoscaling Group
  scaling_group_name = "testAccEssScalingGroup"
  min_size           = 2
  max_size           = 4

  // Scaling configuration
  create_autoscaling         = true
  scaling_configuration_name = "testAccEssScalingConfiguration"
  ecs_instance_password      = "YourPassword123"
  instance_types             = "ecs.sn1ne.large"
  system_disk_category       = "cloud_efficiency"
  security_group_ids         = ["sg-2ze0zgaj3hne6aid****"]
  vswitch_ids                = ["vsw-2ze79rz1livcjkfb*****"]
  frontend_port              = 8081

  // Scaling lifecycle hook
  lifecycle_hook_name = "lifehook"
  mns_queue_name      = "sdfwede12****"

  // bind slb
  create_slb    = true
  slb_name      = "for-java"
  bandwidth     = 5
  slb_spec      = "slb.s1.small"
  instance_port = 8080
  weight        = 50

  // bind dns
  bind_domain = true
  domain_name = "dns001.abc"
  dns_record = {
    host_record = "java"
    type        = "A"
  }
}
```

## Examples

* [complete](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-on-autoscaling/tree/master/examples/complete)
* [java-autoscaling-group](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-on-autoscaling/tree/master/examples/java-autoscaling-group)

## Notes
* This module using AccessKey and SecretKey are from `profile` and `shared_credentials_file`.
If you have not set them yet, please install [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) and configure it.

Submit Issues
-------------
If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

Authors
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
