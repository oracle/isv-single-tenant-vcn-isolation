package test

// Copyright (c) 2020, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

import (
	"log"
	"os/exec"
	"testing"

	"github.com/stretchr/testify/assert"
)

// Check that all Terraform configuration module source files have been formatted with `terraform fmt`
func TestTerraformFmtModules(t *testing.T) {
	t.Parallel()

	terraformDirectory := "../modules"

	_, err := exec.LookPath("terraform")
	if err != nil {
		log.Fatalf("%s", err)
	}

	cmd := exec.Command("terraform", "fmt", "-write=false", "-list=true", "-recursive", terraformDirectory)
	out, err := cmd.Output()
	if assert.NoError(t, err) {
		assert.Empty(t, string(out))
	}
}

// Check that all Terraform configuration example source files have been formatted with `terraform fmt`
func TestTerraformFmtExamples(t *testing.T) {
	t.Parallel()

	terraformDirectory := "../examples"

	_, err := exec.LookPath("terraform")
	if err != nil {
		log.Fatalf("%s", err)
	}

	cmd := exec.Command("terraform", "fmt", "-write=false", "-list=true", "-recursive", terraformDirectory)
	out, err := cmd.Output()
	if assert.NoError(t, err) {
		assert.Empty(t, string(out))
	}
}
