package test

import (
	"testing"
    "github.com/stretchr/testify/assert"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/azure"
	"fmt"
)

func TestTerraformVMSS(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples",
		VarFiles: []string{"terratest.tfvars"},
		Upgrade: true,
	}

	// Defer the destroy to cleanup all created resources
	defer terraform.Destroy(t, terraformOptions)

	// This will init and apply the resources and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// // Assert inputs with outputs
	outputs_vmss_name := terraform.Output(t, terraformOptions, "linux_virtual_machine_scale_set_name")
	assert.Equal(t, "tftestvmss", outputs_vmss_name)

	// Get secret name for Keyvault to check if secret exist
	testKeyVaultName := "KV-LAB-TFE-01"
	testKeyVaultSecretName := "ado--cpp-module-terraform-azurerm-vmss--mdv--vmss-ssh-private-key"
	_, err := azure.KeyVaultSecretExistsE(testKeyVaultName, testKeyVaultSecretName)
	if err == nil {
		fmt.Println("Key Vault secret exist")
	}

	// Get VMSS ID from azure and assert
	sliceSource := "/subscriptions/8cdb5405-7535-4349-92e9-f52bddc7833a/resourceGroups/RG-LAB-TF-TEST-VMSS-01-7d84ed390189a11c/providers/Microsoft.Compute/virtualMachineScaleSets/tftestvmss"
	sliceResult := "tftestvmss"
	resultSuccess := azure.GetNameFromResourceID(sliceSource)
	assert.Equal(t, sliceResult, resultSuccess)
}
