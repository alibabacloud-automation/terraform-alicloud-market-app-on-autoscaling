# 下线公告

感谢您对阿里云 Terraform Module 的关注。即日起，本 Module 将停止维护并会在将来正式下线。更多丰富的 Module 可在 [阿里云 Terraform Module](https://registry.terraform.io/browse/modules?provider=alibaba) 中搜索获取。

再次感谢您的理解和合作。

terraform-alicloud-market-app-on-autoscaling
============================================

本 Terraform Module 将基于阿里云市场提供的 ECS 镜像来创建自动伸缩的应用运行环境。

## 用法

使用云市场镜像搭建 web 应用程序（以 jenkins 为例）并创建自动伸缩组和伸缩组配置。

```hcl
module "market_app_on_autoscaling" {
  source                     = "terraform-alicloud-modules/market-app-on-autoscaling/alicloud"

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

## 示例

* [jenkins 完整示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-on-autoscaling/tree/master/examples/complete)
* [java 伸缩环境示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-on-autoscaling/tree/master/examples/java-autoscaling-group)

## 注意事项
本Module从版本v1.1.0开始已经移除掉如下的 provider 的显式设置：

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/market-app-on-autoscaling"
}
```

如果你依然想在Module中使用这个 provider 配置，你可以在调用Module的时候，指定一个特定的版本，比如 1.0.0:

```hcl
module "market_app_on_autoscaling" {
  source          = "terraform-alicloud-modules/market-app-on-autoscaling/alicloud"
  version         = "1.0.0"
  region          = "cn-beijing"
  profile         = "Your-Profile-Name"
  product_keyword = "jenkins"
  // ...
}
```

如果你想对正在使用中的Module升级到 1.1.0 或者更高的版本，那么你可以在模板中显式定义一个相同Region的provider：
```hcl
provider "alicloud" {
  region  = "cn-beijing"
  profile = "Your-Profile-Name"
}
module "market_app_on_autoscaling" {
  source          = "terraform-alicloud-modules/market-app-on-autoscaling/alicloud"
  product_keyword = "jenkins"
  // ...
}
```
或者，如果你是多Region部署，你可以利用 `alias` 定义多个 provider，并在Module中显式指定这个provider：

```hcl
provider "alicloud" {
  region  = "cn-beijing"
  profile = "Your-Profile-Name"
  alias   = "bj"
}
module "market_app_on_autoscaling" {
  source          = "terraform-alicloud-modules/market-app-on-autoscaling/alicloud"
  providers    = {
    alicloud = alicloud.bj
  }
  product_keyword = "jenkins"
  // ...
}
```

定义完provider之后，运行命令 `terraform init` 和 `terraform apply` 来让这个provider生效即可。

更多provider的使用细节，请移步[How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform 版本

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.71.0 |

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

参考
----
Apache 2 Licensed. See LICENSE for full details.

许可
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)