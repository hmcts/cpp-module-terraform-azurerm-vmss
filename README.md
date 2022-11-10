<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ssh_private_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ssh_public_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_lb.vmsslb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.bepool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_nat_pool.natpol](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_pool) | resource |
| [azurerm_lb_probe.lbp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.lbrule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_linux_virtual_machine_scale_set.linux_vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_monitor_autoscale_setting.auto](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) | resource |
| [azurerm_monitor_diagnostic_setting.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.vmmsdiag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [random_password.passwd](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.rsa](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_data_disks"></a> [additional\_data\_disks](#input\_additional\_data\_disks) | Adding additional disks capacity to add each instance (GB) | `list(number)` | `[]` | no |
| <a name="input_additional_data_disks_storage_account_type"></a> [additional\_data\_disks\_storage\_account\_type](#input\_additional\_data\_disks\_storage\_account\_type) | The Type of Storage Account which should back this Data Disk. Possible values include Standard\_LRS, StandardSSD\_LRS, Premium\_LRS and UltraSSD\_LRS. | `string` | `"Standard_LRS"` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The Password which should be used for the local-administrator on this Virtual Machine | `any` | `null` | no |
| <a name="input_admin_ssh_key_data"></a> [admin\_ssh\_key\_data](#input\_admin\_ssh\_key\_data) | specify the path to the existing ssh key to authenciate linux vm | `string` | `""` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The username of the local administrator used for the Virtual Machine. | `string` | `"azureadmin"` | no |
| <a name="input_availability_zone_balance"></a> [availability\_zone\_balance](#input\_availability\_zone\_balance) | Should the Virtual Machines in this Scale Set be strictly evenly distributed across Availability Zones? | `bool` | `true` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in | `list` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| <a name="input_custom_image"></a> [custom\_image](#input\_custom\_image) | Provide the custom image to this module if the default variants are not sufficient | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | `null` | no |
| <a name="input_disable_password_authentication"></a> [disable\_password\_authentication](#input\_disable\_password\_authentication) | Should Password Authentication be disabled on this Virtual Machine Scale Set? Defaults to true. | `bool` | `true` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of dns servers to use for network interface | `list` | `[]` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | Should Accelerated Networking be enabled? Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_automatic_instance_repair"></a> [enable\_automatic\_instance\_repair](#input\_enable\_automatic\_instance\_repair) | Should the automatic instance repair be enabled on this Virtual Machine Scale Set? | `bool` | `false` | no |
| <a name="input_enable_autoscale_for_vmss"></a> [enable\_autoscale\_for\_vmss](#input\_enable\_autoscale\_for\_vmss) | Manages a AutoScale Setting which can be applied to Virtual Machine Scale Sets | `bool` | `false` | no |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding) | Should IP Forwarding be enabled? Defaults to false | `bool` | `false` | no |
| <a name="input_enable_lb_nat_pool"></a> [enable\_lb\_nat\_pool](#input\_enable\_lb\_nat\_pool) | If enabled load balancer nat pool will be created for SSH if flavor is linux and for winrm if flavour is windows | `bool` | `false` | no |
| <a name="input_enable_load_balancer"></a> [enable\_load\_balancer](#input\_enable\_load\_balancer) | Controls if public load balancer should be created | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `""` | no |
| <a name="input_generate_admin_ssh_key"></a> [generate\_admin\_ssh\_key](#input\_generate\_admin\_ssh\_key) | Generates a secure private key and encodes it as PEM. | `bool` | `true` | no |
| <a name="input_grace_period"></a> [grace\_period](#input\_grace\_period) | Amount of time (in minutes, between 30 and 90, defaults to 30 minutes) for which automatic repairs will be delayed. | `string` | `"PT30M"` | no |
| <a name="input_instances_count"></a> [instances\_count](#input\_instances\_count) | The number of Virtual Machines in the Scale Set. | `number` | `1` | no |
| <a name="input_isImageFromMarketPlace"></a> [isImageFromMarketPlace](#input\_isImageFromMarketPlace) | is image from market place. this will include plan block | `bool` | `true` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Azure keyvault ID to write the secrets | `string` | `""` | no |
| <a name="input_lb_private_ip_address"></a> [lb\_private\_ip\_address](#input\_lb\_private\_ip\_address) | Private IP Address to assign to the Load Balancer. | `any` | `null` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies the type of on-premise license which should be used for this Virtual Machine. Possible values are None, Windows\_Client and Windows\_Server. | `string` | `"None"` | no |
| <a name="input_linux_distribution_list"></a> [linux\_distribution\_list](#input\_linux\_distribution\_list) | n/a | <pre>map(object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  }))</pre> | <pre>{<br>  "centos8": {<br>    "offer": "CentOS",<br>    "publisher": "OpenLogic",<br>    "sku": "7.5",<br>    "version": "latest"<br>  },<br>  "coreos": {<br>    "offer": "CoreOS",<br>    "publisher": "CoreOS",<br>    "sku": "Stable",<br>    "version": "latest"<br>  },<br>  "ubuntu1604": {<br>    "offer": "UbuntuServer",<br>    "publisher": "Canonical",<br>    "sku": "16.04-LTS",<br>    "version": "latest"<br>  },<br>  "ubuntu1804": {<br>    "offer": "UbuntuServer",<br>    "publisher": "Canonical",<br>    "sku": "18.04-LTS",<br>    "version": "latest"<br>  }<br>}</pre> | no |
| <a name="input_linux_distribution_name"></a> [linux\_distribution\_name](#input\_linux\_distribution\_name) | Variable to pick an OS flavour for Linux based VMSS possible values include: centos8, ubuntu1804 | `string` | `"ubuntu1804"` | no |
| <a name="input_load_balanced_port_list"></a> [load\_balanced\_port\_list](#input\_load\_balanced\_port\_list) | List of ports to be forwarded through the load balancer to the VMs | <pre>list(object({<br>    frontend_port = number<br>    backend_port  = number<br>  }))</pre> | <pre>[<br>  {<br>    "backend_port": 80,<br>    "frontend_port": 80<br>  }<br>]</pre> | no |
| <a name="input_load_balancer_health_probe_port_list"></a> [load\_balancer\_health\_probe\_port\_list](#input\_load\_balancer\_health\_probe\_port\_list) | Port on which the Probe queries the backend endpoint. Default `80` | `list(number)` | <pre>[<br>  80<br>]</pre> | no |
| <a name="input_load_balancer_sku"></a> [load\_balancer\_sku](#input\_load\_balancer\_sku) | The SKU of the Azure Load Balancer. Accepted values are Basic and Standard. | `string` | `"Standard"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Controls the type of load balancer should be created. Possible values are public and private | `string` | `"private"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure Location | `string` | `""` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics workspace ID | `string` | `null` | no |
| <a name="input_maximum_instances_count"></a> [maximum\_instances\_count](#input\_maximum\_instances\_count) | The maximum number of instances for this resource. Valid values are between 0 and 1000 | `string` | `""` | no |
| <a name="input_minimum_instances_count"></a> [minimum\_instances\_count](#input\_minimum\_instances\_count) | The minimum number of instances for this resource. Valid values are between 0 and 1000 | `any` | `null` | no |
| <a name="input_nat_pool_frontend_ports"></a> [nat\_pool\_frontend\_ports](#input\_nat\_pool\_frontend\_ports) | Optional override for default NAT ports | `list(number)` | <pre>[<br>  50000,<br>  50119<br>]</pre> | no |
| <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id) | NSG ID | `string` | `""` | no |
| <a name="input_nsg_diag_logs"></a> [nsg\_diag\_logs](#input\_nsg\_diag\_logs) | NSG Monitoring Category details for Azure Diagnostic setting | `list` | <pre>[<br>  "NetworkSecurityGroupEvent",<br>  "NetworkSecurityGroupRuleCounter"<br>]</pre> | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | The Size of the Internal OS Disk in GB | `number` | `100` | no |
| <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type) | The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard\_LRS, StandardSSD\_LRS and Premium\_LRS. | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_os_upgrade_mode"></a> [os\_upgrade\_mode](#input\_os\_upgrade\_mode) | Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Automatic | `string` | `"Manual"` | no |
| <a name="input_overprovision"></a> [overprovision](#input\_overprovision) | Should Azure over-provision Virtual Machines in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first - which improves provisioning success rates and improves deployment time. You're not billed for these over-provisioned VM's and they don't count towards the Subscription Quota. Defaults to true. | `bool` | `false` | no |
| <a name="input_private_ip_address_allocation"></a> [private\_ip\_address\_allocation](#input\_private\_ip\_address\_allocation) | The allocation method for the Private IP Address used by this Load Balancer. Possible values as Dynamic and Static. | `string` | `"Dynamic"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group Name | `string` | `""` | no |
| <a name="input_scale_in_cpu_percentage_threshold"></a> [scale\_in\_cpu\_percentage\_threshold](#input\_scale\_in\_cpu\_percentage\_threshold) | Specifies the threshold of the metric that triggers the scale in action. | `string` | `"20"` | no |
| <a name="input_scale_out_cpu_percentage_threshold"></a> [scale\_out\_cpu\_percentage\_threshold](#input\_scale\_out\_cpu\_percentage\_threshold) | Specifies the threshold % of the metric that triggers the scale out action. | `string` | `"80"` | no |
| <a name="input_scaling_action_instances_number"></a> [scaling\_action\_instances\_number](#input\_scaling\_action\_instances\_number) | The number of instances involved in the scaling action | `string` | `"1"` | no |
| <a name="input_single_placement_group"></a> [single\_placement\_group](#input\_single\_placement\_group) | Allow to have cluster of 100 VMs only | `bool` | `false` | no |
| <a name="input_source_image_id"></a> [source\_image\_id](#input\_source\_image\_id) | The ID of an Image which each Virtual Machine in this Scale Set should be based on | `any` | `null` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | Storage account ID | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | The Virtual Machine SKU for the Scale Set, Default is Standard\_A2\_V2 | `string` | `"Standard_D2_v3"` | no |
| <a name="input_vmscaleset_name"></a> [vmscaleset\_name](#input\_vmscaleset\_name) | Specifies the name of the virtual machine scale set resource | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_ssh_key_public"></a> [admin\_ssh\_key\_public](#output\_admin\_ssh\_key\_public) | The generated public key data in PEM format |
| <a name="output_linux_virtual_machine_scale_set_id"></a> [linux\_virtual\_machine\_scale\_set\_id](#output\_linux\_virtual\_machine\_scale\_set\_id) | The resource ID of the Linux Virtual Machine Scale Set. |
| <a name="output_linux_virtual_machine_scale_set_name"></a> [linux\_virtual\_machine\_scale\_set\_name](#output\_linux\_virtual\_machine\_scale\_set\_name) | The name of the Linux Virtual Machine Scale Set. |
| <a name="output_linux_virtual_machine_scale_set_unique_id"></a> [linux\_virtual\_machine\_scale\_set\_unique\_id](#output\_linux\_virtual\_machine\_scale\_set\_unique\_id) | The unique ID of the Linux Virtual Machine Scale Set. |
| <a name="output_load_balancer_health_probe_id"></a> [load\_balancer\_health\_probe\_id](#output\_load\_balancer\_health\_probe\_id) | The resource ID of the Load Balancer health Probe. |
| <a name="output_load_balancer_nat_pool_id"></a> [load\_balancer\_nat\_pool\_id](#output\_load\_balancer\_nat\_pool\_id) | The resource ID of the Load Balancer NAT pool. |
| <a name="output_load_balancer_private_ip"></a> [load\_balancer\_private\_ip](#output\_load\_balancer\_private\_ip) | The Private IP address allocated for load balancer |
| <a name="output_load_balancer_rules_id"></a> [load\_balancer\_rules\_id](#output\_load\_balancer\_rules\_id) | The resource ID of the Load Balancer Rule |
<!-- END_TF_DOCS -->
