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
	// TODO get ssh keys from variables
	usr, _ := user.Current()
	privateKeyFile := usr.HomeDir + "/.ssh/id_rsa"
	pubicKeyFile := usr.HomeDir + "/.ssh/id_rsa.pub"

	keyPair := ssh.KeyPair{
		PublicKey:  readFromFile(pubicKeyFile),
		PrivateKey: readFromFile(privateKeyFile),
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
