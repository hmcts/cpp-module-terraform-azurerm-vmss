resource_group_name = "RG-LAB-TF-TEST-VMSS-01"
location            = "uksouth"

subnet_config = {
  name                 = "SN-LAB-SBZ-01-test"
  resource_group_name  = "RG-LAB-INT-01"
  virtual_network_name = "VN-LAB-INT-01"
  address_prefixes     = "10.1.2.48/28"
}

key_vault_config = {
  name                = "KV-LAB-TFE-01"
  resource_group_name = "RG-LAB-TFE-01"
}

vmss_config = {
  name                    = "tftestvmss"
  linux_distribution_name = "ubuntu1804"
  source_image_id         = "/subscriptions/e6b5053b-4c38-4475-a835-a025aeb3d8c7/resourceGroups/RG-SHARED-AMI/providers/Microsoft.Compute/galleries/packer_shareimages/images/ado_image/versions/1.3.4"

}

tags = {
  domain      = "cpp.nonlive"
  platform    = "nlv"
  environment = "test"
  tier        = "compute"
  project     = "Azure DevOps"
}
