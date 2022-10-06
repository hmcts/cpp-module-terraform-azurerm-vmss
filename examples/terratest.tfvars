resource_group_name = "RG-LAB-TF-TEST-VMSS-01"
location            = "uksouth"

subnet_config = {
  name                 = "SN-LAB-SBZ-01"
  resource_group_name  = "RG-LAB-INT-01"
  virtual_network_name = "VN-LAB-INT-01"
  address_prefixes     = "10.1.1.32/28"
}

key_vault_config = {
  name                = "KV-LAB-TFE-01"
  resource_group_name = "RG-LAB-TFE-01"
}

vmss_config = {
  name                    = "tftestvmss"
  linux_distribution_name = "ubuntu1804"
}

tags = {
  domain      = "cpp.nonlive"
  platform    = "nlv"
  environment = "test"
  tier        = "compute"
  project     = "Azure DevOps"
}
