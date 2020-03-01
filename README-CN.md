terraform-alicloud-market-app-on-autoscaling
============================================

本 Terraform Module 将基于阿里云市场提供的 ECS 镜像来创建自动伸缩的应用运行环境。

## Terraform 版本

本模板要求使用版本 Terraform 0.12 和 阿里云 Provider 1.71.0+。

## 用法

使用云市场镜像搭建 web 应用程序（以 jenkins 为例）并创建自动伸缩组和伸缩组配置。

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

## 示例

* [jenkins 完整示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-on-autoscaling/tree/master/examples/complete)
* [java 伸缩环境示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-market-app-on-autoscaling/tree/master/examples/java-autoscaling-group)

## 注意事项

* 本 Module 使用的 AccessKey 和 SecretKey 可以直接从 `profile` 和 `shared_credentials_file` 中获取。如果未设置，可通过下载安装 [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) 后进行配置。

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Zhou qilin(z17810666992@163.com), He Guimin(@xiaozhu36, heguimin36@163.com).

参考
----
Apache 2 Licensed. See LICENSE for full details.

许可
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)
