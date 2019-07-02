package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-west-1.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	codebuildProjectName := terraform.Output(t, terraformOptions, "codebuild_project_name")

	expectedCodebuildProjectName := "eg-test-cicd-test-build"
	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedCodebuildProjectName, codebuildProjectName)

	// Run `terraform output` to get the value of an output variable
	codebuildCacheS3BucketName := terraform.Output(t, terraformOptions, "codebuild_cache_bucket_name")

	expectedCodebuildCacheS3BucketName := "eg-test-cicd-test-build"
	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedCodebuildCacheS3BucketName, codebuildCacheS3BucketName)

	// Run `terraform output` to get the value of an output variable
	codepipelineId := terraform.Output(t, terraformOptions, "codepipeline_id")

	expectedCodepipelineId := "eg-test-cicd-test"
	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedCodepipelineId, codepipelineId)
}
