package test

// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

import (
	"io/ioutil"
	"log"
	"os"
	"os/user"
	"testing"

	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// fetch the SSH keys for the test instance
func getSSHKeyPair() *ssh.KeyPair {
	// https://stackoverflow.com/questions/51918473/terraform-error-parsing-tfvars-file-when-using-the-var-file-flag
	// look for TF_VAR_bastion_ssh_public_key_file and TF_VAR_bastion_ssh_private_key_file environment variables
	// look for the bastion_ssh_public_key_file and bastion_ssh_private_key_file values set in examples/full-deployment/terraform.tfvars
	// privateKeyFile := usr.HomeDir + "/.ssh/id_rsa"
	// pubicKeyFile := usr.HomeDir + "/.ssh/id_rsa.pub"
	var privateKeyFile, publicKeyFile string
	var err, err2 error

	usr, _ := user.Current()

	privateKeyFile = os.Getenv("TF_VAR_bastion_ssh_private_key_file")
	publicKeyFile = os.Getenv("TF_VAR_bastion_ssh_public_key_file")
	if len(privateKeyFile) == 0 || len(publicKeyFile) == 0 {
		log.Println("TF_VAR_bastion_ssh_private_key_file or TF_VAR_bastion_ssh_public_key_file environment variables not defined")
	}

	dir := os.Getenv("GOPATH") + "/src/isv-single-tenant-vcn-isolation/examples/full-deployment"
	privateKeyFile, err = getOutputE(t, dir, "bastion_ssh_private_key_file")
	publicKeyFile, err2 = getOutputE(t, dir, "bastion_ssh_public_key_file")

	if err != nil || err2 != nil {
		log.Println("Error parsing terraform output...")
	}

	if len(privateKeyFile) == 0 || len(publicKeyFile) == 0 {
		privateKeyFile = usr.HomeDir + "/.ssh/id_rsa"
		publicKeyFile = usr.HomeDir + "/.ssh/id_rsa.pub"
	}

	keyPair := ssh.KeyPair{
		PrivateKey: readFromFile(privateKeyFile),
		PublicKey:  readFromFile(publicKeyFile),
	}

	return &keyPair
}

// read content from a local file to string
func readFromFile(filename string) string {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	b, err := ioutil.ReadAll(file)
	return string(b)
}

// fetch an output value from a specific Terraform configuration
func getOutput(t *testing.T, terraformDirctory, key string) string {
	options := &terraform.Options{
		TerraformDir:    terraformDirctory,
		TerraformBinary: "terraform",
	}
	value := terraform.Output(t, options, key)
	return value
}

// OutputRequired calls terraform output for the given variable and return its value. If the value is empty, fail the test.
func getOutputE(t *testing.T, terraformDir, key string) (string, error) {
	options := &terraform.Options{
		TerraformDir:    terraformDir,
		TerraformBinary: "terraform",
	}
	value, err := terraform.OutputRequiredE(t, options, key)
	return value, err
}
