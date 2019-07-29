package test

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/user"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/gruntwork-io/terratest/modules/retry"
)

// Tests the entire Terraform configuration using Terragrunt.
func TestTerragruntApplyAll(t *testing.T) {
	t.Parallel()

	terraformDirectory := "../examples/full-deployment"

	// start an SSH agent
	keyPair := getSSHKeyPair()
	sshAgent := ssh.SshAgentWithKeyPair(t, keyPair)
	defer sshAgent.Stop()

	terraformOptions := &terraform.Options{
		TerraformDir:    terraformDirectory,
		TerraformBinary: "terragrunt",

		// use the local SSH agent for testing
		SshAgent: sshAgent,
	}
	test_structure.SaveTerraformOptions(t, terraformDirectory, terraformOptions)

	// At the end of the test, run `terragrunt destry-all` to clean up any resources that were created
	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, terraformDirectory)
		terraform.TgDestroyAll(t, terraformOptions)
	})

	// This will run `terragrunt apply-all` and fail the test if there are any errors
	test_structure.RunTestStage(t, "deploy", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, terraformDirectory)
		terraform.TgApplyAll(t, terraformOptions)
	})

	// This will run `terragrunt plan-all` to check a second apply does not have any deltas
	test_structure.RunTestStage(t, "plan", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, terraformDirectory)
		exitCode := terraform.TgPlanAllExitCode(t, terraformOptions)

		// Confirm the plan has no changes
		assert.Equal(t, 0, exitCode)
	})

	// Run validation tests against the deployment
	test_structure.RunTestStage(t, "validate", func() {

		// Run a simple echo command to each server
		expectedText := "Hello, World"
		command := fmt.Sprintf("echo -n '%s'", expectedText)

		// TEST
		logger.Log(t, "TEST - public ssh connecton to bastion server.")
		bastionIP := getOutput(t, terraformDirectory+"/management/access", "bastion_ip")
		bastionHost := ssh.Host{
			Hostname:    bastionIP,
			SshUserName: "opc",
			SshKeyPair:  keyPair,
		}
		ssh.CheckSshConnection(t, bastionHost)
		response := ssh.CheckSshCommand(t, bastionHost, command)
		assert.Equal(t, expectedText, response)


		// TEST
		logger.Log(t, "TEST - private ssh connecton to management server via bastion.")
		{
			managementIP := getOutput(t, terraformDirectory+"/management/servers", "management_ip")
			managementHost := ssh.Host{
				Hostname:    managementIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			// check ssh connection through to management server
			response := ssh.CheckPrivateSshConnection(t, bastionHost, managementHost, command)
			assert.Equal(t, expectedText, response)
		}

		// TEST
		logger.Log(t, "TEST - private ssh connecton to routing instance 1 via bastion.")
		{
			routingIP := getOutput(t, terraformDirectory+"/peering/routing", "routing_instance_1_ip")
			routingHost := ssh.Host{
				Hostname:    routingIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			response := ssh.CheckPrivateSshConnection(t, bastionHost, routingHost, command)
			assert.Equal(t, expectedText, response)
		}

		// TEST
		logger.Log(t, "TEST - private ssh connecton to routing instance 2 via bastion.")
		{
			routingIP := getOutput(t, terraformDirectory+"/peering/routing", "routing_instance_2_ip")
			routingHost := ssh.Host{
				Hostname:    routingIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			response := ssh.CheckPrivateSshConnection(t, bastionHost, routingHost, command)
			assert.Equal(t, expectedText, response)
		}

		// TEST
		logger.Log(t, "TEST - private ssh connecton to tenant instance 1 via bastion.")
		{
			tenantIP := getOutput(t, terraformDirectory+"/tenant/servers", "tenant_1_private_ip")
			tenantHost := ssh.Host{
				Hostname:    tenantIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			response := ssh.CheckPrivateSshConnection(t, bastionHost, tenantHost, command)
			assert.Equal(t, expectedText, response)
		}

		// TEST
		logger.Log(t, "TEST - private ssh connecton to tenant instance 2 via bastion.")
		{
			tenantIP := getOutput(t, terraformDirectory+"/tenant/servers", "tenant_2_private_ip")
			tenantHost := ssh.Host{
				Hostname:    tenantIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			response := ssh.CheckPrivateSshConnection(t, bastionHost, tenantHost, command)
			assert.Equal(t, expectedText, response)
		}

		// TEST
		logger.Log(t, "TEST - private ssh connecton to tenant instance 3 via bastion.")
		{
			tenantIP := getOutput(t, terraformDirectory+"/tenant/servers", "tenant_3_private_ip")
			tenantHost := ssh.Host{
				Hostname:    tenantIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			response := ssh.CheckPrivateSshConnection(t, bastionHost, tenantHost, command)
			assert.Equal(t, expectedText, response)
		}

		// TEST
		logger.Log(t, "TEST - private ssh connecton to tenant instance 4 via bastion.")
		{
			tenantIP := getOutput(t, terraformDirectory+"/tenant/servers", "tenant_4_private_ip")
			tenantHost := ssh.Host{
				Hostname:    tenantIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			response := ssh.CheckPrivateSshConnection(t, bastionHost, tenantHost, command)
			assert.Equal(t, expectedText, response)
		}

		// TEST
		logger.Log(t, "TEST - file /usr/local/nagios/etc/servers/hosts.cfg exists on nagios server")
		{
			managementIP := getOutput(t, terraformDirectory+"/management/servers", "management_ip")
			managementHost := ssh.Host{
				Hostname:    managementIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			
			expectedFileExists := "1"
			command := fmt.Sprintf("ls /usr/local/nagios/etc/servers/hosts.cfg | wc -l | tr -d '\n'")
			maxRetries := 30
			timeBetweenRetries := 5 * time.Second
			description := fmt.Sprintf("SSH to management host %s", managementIP)
			retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
			    actualFileExists, err := ssh.CheckPrivateSshConnectionE(t, bastionHost, managementHost, command)
			    assert.Equal(t, expectedFileExists, actualFileExists)
			    return "", err
			})
		}

		// TEST NRPE agent on tenant server is configured with Nagios Host server as allowed host
		logger.Log(t, "TEST - file /etc/nagios/nrpe.cfg exists and configured on tenant servers")
		{
			tenantIP := getOutput(t, terraformDirectory+"/tenant/servers", "tenant_4_private_ip")
			managementIP := getOutput(t, terraformDirectory+"/management/servers", "management_ip")
			tenantHost := ssh.Host{
				Hostname:    tenantIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			
			command := fmt.Sprintf("cat /etc/nagios/nrpe.cfg | grep allowed_hosts | cut -d'=' -f2 | tr -d '\n'")
			maxRetries := 30
			timeBetweenRetries := 5 * time.Second
			description := fmt.Sprintf("SSH to tenant host %s", tenantIP)
			retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
			    actualText, err := ssh.CheckPrivateSshConnectionE(t, bastionHost, tenantHost, command)
			    assert.Equal(t, managementIP, actualText)
			    return "", err
			})
		}

		// TEST
		logger.Log(t, "TEST - Find out that NAGIOS process is running successfully")
		{
			managementIP := getOutput(t, terraformDirectory+"/management/servers", "management_ip")
			managementHost := ssh.Host{
				Hostname:    managementIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			
			expectedStatus := "active"
			command := fmt.Sprintf("systemctl is-active nagios | tr -d '\n'")
			maxRetries := 30
			timeBetweenRetries := 5 * time.Second
			description := fmt.Sprintf("Check nagios process on management host %s", managementIP)
			retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
			    actualStatus, err := ssh.CheckPrivateSshConnectionE(t, bastionHost, managementHost, command)
			    assert.Equal(t, expectedStatus, actualStatus)
			    return "", err
			})
		}

		// TEST
		logger.Log(t, "TEST - Find out that NRPE process is running successfully on tenant server")
		{
			tenantIP := getOutput(t, terraformDirectory+"/tenant/servers", "tenant_4_private_ip")
			tenantHost := ssh.Host{
				Hostname:    tenantIP,
				SshUserName: "opc",
				SshKeyPair:  keyPair,
			}
			
			expectedStatus := "active"
			command := fmt.Sprintf("systemctl is-active nrpe | tr -d '\n'")
			maxRetries := 30
			timeBetweenRetries := 5 * time.Second
			description := fmt.Sprintf("Check NRPE process on tenant host %s", tenantIP)
			retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
			    actualStatus, err := ssh.CheckPrivateSshConnectionE(t, bastionHost, tenantHost, command)
			    assert.Equal(t, expectedStatus, actualStatus)
			    return "", err
			})
		}

		// TEST
		logger.Log(t, "TEST - Curl to nagios instanceURL is working thru bastionHost.")
		{
			managementIP := getOutput(t, terraformDirectory+"/management/servers", "management_ip")
			command := fmt.Sprintf("curl -s http://%s", managementIP)
			
			expectedText := "<html>This is a placeholder for the home page.</html>"
			maxRetries := 30
			timeBetweenRetries := 5 * time.Second
			description := fmt.Sprintf("Curl to Nagios website on management host %s", managementIP)
			retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
			    actualText, err := ssh.CheckSshCommandE(t, bastionHost, command)
			    assert.Equal(t, expectedText, actualText)
			    return "", err
			})
		}
	})
}

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
