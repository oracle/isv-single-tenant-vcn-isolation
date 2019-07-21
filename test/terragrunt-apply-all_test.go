package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

// Tests the entire Terraform configuration using Terragrunt.
func TestTerragruntApplyAll(t *testing.T) {
	t.Parallel()

	terraformDirectory := "../examples/full-deployment"

	// At the end of the test, run `terragrunt destry-all` to clean up any resources that were created
	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, terraformDirectory)
		terraform.TgDestroyAll(t, terraformOptions)
	})

	// This will run `terragrunt apply-all` and fail the test if there are any errors
	test_structure.RunTestStage(t, "deploy", func() {

		terraformOptions := &terraform.Options{
			TerraformDir:    terraformDirectory,
			TerraformBinary: "terragrunt",
		}

		test_structure.SaveTerraformOptions(t, terraformDirectory, terraformOptions)

		terraform.TgApplyAll(t, terraformOptions)
	})

	// This will run `terragrunt plan-all` to check a second apply does not have any deltas
	test_structure.RunTestStage(t, "plan", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, terraformDirectory)
		exitCode := terraform.TgPlanAllExitCode(t, terraformOptions)

		assert.Equal(t, 0, exitCode)
	})

}
