package test

// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

import (
	"bufio"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"io/ioutil"
	"log"
	"os"
	"os/user"
	"regexp"
	"strings"
	"testing"
)

// fetch the SSH keys for the test instance
func getSSHKeyPair(terraformDirectory string) *ssh.KeyPair {
	privateKeyFile := os.Getenv("TF_VAR_bastion_ssh_private_key_file")
	publicKeyFile := os.Getenv("TF_VAR_bastion_ssh_public_key_file")

	if len(privateKeyFile) != 0 && len(publicKeyFile) != 0 {
		log.Output(1, "took bastion key files from env vars")
	} else {
		log.Output(1, "looking for bastion key files in tfvars file")
		tfvarsFile := terraformDirectory + "/terraform.tfvars"

		file, err := os.Open(tfvarsFile)
		if err != nil {
			log.Fatal(err)
		}
		defer file.Close()

		scanner := bufio.NewScanner(file)
		space := regexp.MustCompile(`\s+`)
		for scanner.Scan() {
			line := space.ReplaceAllString(scanner.Text(), "")
			if strings.HasPrefix(line, "bastion_ssh_private_key_file=") && len(privateKeyFile) == 0 {
				privateKeyFile = strings.ReplaceAll(strings.Split(line, "=")[1], "\"", "")
			}

			if strings.HasPrefix(line, "bastion_ssh_public_key_file=") && len(publicKeyFile) == 0 {
				publicKeyFile = strings.ReplaceAll(strings.Split(line, "=")[1], "\"", "")
			}
		}

		if err := scanner.Err(); err != nil {
			log.Fatal(err)
		}

		if len(privateKeyFile) != 0 && len(publicKeyFile) != 0 {
			log.Output(1, "took bastion key files from tfvars file")
		}
	}

	usr, _ := user.Current()

	if len(privateKeyFile) == 0 {
		privateKeyFile = usr.HomeDir + "/.ssh/id_rsa"
	}

	if len(publicKeyFile) == 0 {
		publicKeyFile = usr.HomeDir + "/.ssh/id_rsa.pub"
	}

	keyPair := ssh.KeyPair{
		PublicKey:  readFromFile(publicKeyFile),
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
