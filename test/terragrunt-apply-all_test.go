package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
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

	// At the end of the test, run `terragrunt destroy-all` to clean up any resources that were created
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
	test_structure.RunTestStage(t, "validate_connectivity", func() {

		// SSH Connectivity Tests
		// Bastion Test
		logger.Log(t, "TEST - public ssh connecton to bastion server.")
		bastionIP := getOutput(t, terraformDirectory+"/management/access", "bastion_ip")
		bastionHost := ssh.Host{
			Hostname:    bastionIP,
			SshUserName: "opc",
			SshKeyPair:  keyPair,
		}
		ssh.CheckSshConnection(t, bastionHost)
		// Run a simple echo command
		expectedText := "Hello, World"
		command := fmt.Sprintf("echo -n '%s'", expectedText)
		response := ssh.CheckSshCommand(t, bastionHost, command)
		assert.Equal(t, expectedText, response)

		// Ensure all deployed instances can be connected to through the bastion host
		testSSHConnectionToAllHosts(t, terraformDirectory, bastionHost, keyPair)
	})

	test_structure.RunTestStage(t, "validate_nagios", func() {
		bastionIP := getOutput(t, terraformDirectory+"/management/access", "bastion_ip")
		bastionHost := ssh.Host{
			Hostname:    bastionIP,
			SshUserName: "opc",
			SshKeyPair:  keyPair,
		}

		// Nagios Configuration Tests
		// Ensure Nagio Core is installed on Management server
		managementIP := getOutput(t, terraformDirectory+"/management/servers", "management_ip")
		testFileExistsOnHost(t, bastionHost, managementIP, keyPair, "/usr/local/nagios/etc/servers/hosts.cfg")
		testNagiosSeverRunning(t, bastionHost, managementIP, keyPair)
		testNagiosServerURL(t, bastionHost, managementIP)

		// Ensure Nagios Agent is installed and configured correctly on all Tenant instances
		for _, num := range []int{1, 3, 4} { // FIXME
			tenantIP := getOutput(t, terraformDirectory+"/tenant/servers", fmt.Sprintf("tenant_%d_private_ip", num))
			testNagiosAgentOnTenantInstance(t, terraformDirectory, bastionHost, tenantIP, keyPair)
			testNagiosAgentRunning(t, bastionHost, tenantIP, keyPair)
		}
	})

	test_structure.RunTestStage(t, "validate_routing", func() {
		bastionIP := getOutput(t, terraformDirectory+"/management/access", "bastion_ip")
		bastionHost := ssh.Host{
			Hostname:    bastionIP,
			SshUserName: "opc",
			SshKeyPair:  keyPair,
		}

		// HA Routing Instance
		// check routing to tenant1 currently goes through gateway1a
		tenantIP := getOutput(t, terraformDirectory+"/tenant/servers", "tenant_1_private_ip")
		testRoutingPathContains(t, bastionHost, tenantIP, "gateway1a")
		// move the floating IP to the secondary routing instance and check routing now goes through gateway1b
		testRoutingInstanceMoveVIP(t, bastionHost, "gateway1a.peering.isv.oraclevcn.com", keyPair, "gateway1b")
		time.Sleep(5 * time.Second)
		testRoutingPathContains(t, bastionHost, tenantIP, "gateway1b")
		// move the floating IP back to the primary routing instance and check routing now is back to gateway1a
		testRoutingInstanceMoveVIP(t, bastionHost, "gateway1a.peering.isv.oraclevcn.com", keyPair, "gateway1a")
		time.Sleep(5 * time.Second)
		testRoutingPathContains(t, bastionHost, tenantIP, "gateway1a")

		// Non-HA Routing Instance
		// check routing to tenant1 currently goes through gateway1a
		tenantIP = getOutput(t, terraformDirectory+"/tenant/servers", "tenant_3_private_ip")
		testRoutingPathContains(t, bastionHost, tenantIP, "gateway2")

	})
}

// test for successful ssh connection to a host through the bastion
func testSSHConnectionThroughBastion(t *testing.T, bastionHost ssh.Host, ipAddress string, keyPair *ssh.KeyPair) {

	host := ssh.Host{
		Hostname:    ipAddress,
		SshUserName: "opc",
		SshKeyPair:  keyPair,
	}
	// check ssh connection through to the host
	expectedText := "Hello, World"
	command := fmt.Sprintf("echo -n '%s'", expectedText)
	response := ssh.CheckPrivateSshConnection(t, bastionHost, host, command)
	assert.Equal(t, expectedText, response)
}

// validate ssh connectivity through bastion to all hosts
func testSSHConnectionToAllHosts(t *testing.T, terraformDirectory string, bastionHost ssh.Host, keyPair *ssh.KeyPair) {

	logger.Log(t, "TEST - private ssh connecton to management server via bastion.")
	managementIP := getOutput(t, terraformDirectory+"/management/servers", "management_ip")
	testSSHConnectionThroughBastion(t, bastionHost, managementIP, keyPair)

	logger.Log(t, "TEST - private ssh connecton to routing instance 1 via bastion.")
	routingIP := getOutput(t, terraformDirectory+"/peering/routing", "routing_instance_1_ip")
	testSSHConnectionThroughBastion(t, bastionHost, routingIP, keyPair)

	logger.Log(t, "TEST - private ssh connecton to routing instance 2 via bastion.")
	routingIP = getOutput(t, terraformDirectory+"/peering/routing", "routing_instance_2_ip")
	testSSHConnectionThroughBastion(t, bastionHost, routingIP, keyPair)

	logger.Log(t, "TEST - private ssh connecton to tenant instance 1 via bastion.")
	tenantIP := getOutput(t, terraformDirectory+"/tenant/servers", "tenant_1_private_ip")
	testSSHConnectionThroughBastion(t, bastionHost, tenantIP, keyPair)

	logger.Log(t, "TEST - private ssh connecton to tenant instance 2 via bastion.")
	tenantIP = getOutput(t, terraformDirectory+"/tenant/servers", "tenant_2_private_ip")
	testSSHConnectionThroughBastion(t, bastionHost, tenantIP, keyPair)

	logger.Log(t, "TEST - private ssh connecton to tenant instance 3 via bastion.")
	tenantIP = getOutput(t, terraformDirectory+"/tenant/servers", "tenant_3_private_ip")
	testSSHConnectionThroughBastion(t, bastionHost, tenantIP, keyPair)

	logger.Log(t, "TEST - private ssh connecton to tenant instance 4 via bastion.")
	tenantIP = getOutput(t, terraformDirectory+"/tenant/servers", "tenant_4_private_ip")
	testSSHConnectionThroughBastion(t, bastionHost, tenantIP, keyPair)
}

// ssh to host through bastion and check that a file exists
func testFileExistsOnHost(t *testing.T, bastionHost ssh.Host, ipAddress string, keyPair *ssh.KeyPair, filename string) {
	logger.Logf(t, "TEST - file %s exists on %s", filename, ipAddress)

	host := ssh.Host{
		Hostname:    ipAddress,
		SshUserName: "opc",
		SshKeyPair:  keyPair,
	}

	expectedFileExists := "1"
	// command := fmt.Sprintf("ls /usr/local/nagios/etc/servers/hosts.cfg | wc -l | tr -d '\n'")
	command := fmt.Sprintf("ls %s | wc -l | tr -d '\n'", filename)
	maxRetries := 30
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("SSH to host %s", ipAddress)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualFileExists, err := ssh.CheckPrivateSshConnectionE(t, bastionHost, host, command)
		assert.Equal(t, expectedFileExists, actualFileExists)
		return "", err
	})
}

// check Nagios agent is installed an configured on the target host
func testNagiosAgentOnTenantInstance(t *testing.T, terraformDirectory string, bastionHost ssh.Host, ipAddress string, keyPair *ssh.KeyPair) {
	logger.Logf(t, "TEST - nagios agent configured on %s", ipAddress)

	managementIP := getOutput(t, terraformDirectory+"/management/servers", "management_ip")
	host := ssh.Host{
		Hostname:    ipAddress,
		SshUserName: "opc",
		SshKeyPair:  keyPair,
	}

	command := fmt.Sprintf("cat /etc/nagios/nrpe.cfg | grep allowed_hosts | cut -d'=' -f2 | tr -d '\n'")
	maxRetries := 30
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("SSH to tenant host %s", ipAddress)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualText, err := ssh.CheckPrivateSshConnectionE(t, bastionHost, host, command)
		assert.Equal(t, managementIP, actualText)
		return "", err
	})
}

// check the Nagios server is running
func testNagiosSeverRunning(t *testing.T, bastionHost ssh.Host, ipAddress string, keyPair *ssh.KeyPair) {
	logger.Logf(t, "TEST - Nagios server succesfully running on %s", ipAddress)
	host := ssh.Host{
		Hostname:    ipAddress,
		SshUserName: "opc",
		SshKeyPair:  keyPair,
	}

	expectedStatus := "active"
	command := fmt.Sprintf("systemctl is-active nagios | tr -d '\n'")
	maxRetries := 30
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("Check nagios process on host %s", ipAddress)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualStatus, err := ssh.CheckPrivateSshConnectionE(t, bastionHost, host, command)
		assert.Equal(t, expectedStatus, actualStatus)
		return "", err
	})
}

// test the Nagios NRPE agent is running
func testNagiosAgentRunning(t *testing.T, bastionHost ssh.Host, ipAddress string, keyPair *ssh.KeyPair) {
	logger.Logf(t, "TEST - Nagios agent succesfully running on %s", ipAddress)
	host := ssh.Host{
		Hostname:    ipAddress,
		SshUserName: "opc",
		SshKeyPair:  keyPair,
	}

	expectedStatus := "active"
	command := fmt.Sprintf("systemctl is-active nrpe | tr -d '\n'")
	maxRetries := 30
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("Check NRPE process on host %s", ipAddress)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualStatus, err := ssh.CheckPrivateSshConnectionE(t, bastionHost, host, command)
		assert.Equal(t, expectedStatus, actualStatus)
		return "", err
	})
}

// test the Nagios Server URL is accessable
func testNagiosServerURL(t *testing.T, bastionHost ssh.Host, ipAddress string) {
	logger.Logf(t, "TEST - Curl to Nagios Server URL is working thru bastion")

	command := fmt.Sprintf("curl -s http://%s", ipAddress)
	expectedText := "<html>This is a placeholder for the home page.</html>"
	maxRetries := 30
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("Curl to Nagios website on management host %s", ipAddress)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualText, err := ssh.CheckSshCommandE(t, bastionHost, command)
		assert.Equal(t, expectedText, actualText)
		return "", err
	})
}

// test connectivity is maintained after moving the floating IP for the routing instance HA cluster
func testRoutingInstanceMoveVIP(t *testing.T, bastionHost ssh.Host, ipAddress string, keyPair *ssh.KeyPair, target string) {
	logger.Logf(t, "TEST - move floating IP in HA cluster")
	host := ssh.Host{
		Hostname:    ipAddress,
		SshUserName: "opc",
		SshKeyPair:  keyPair,
	}

	// check ssh connection through to the host
	command := fmt.Sprintf("sudo pcs resource move Cluster_VIP %s", target)
	response := ssh.CheckPrivateSshConnection(t, bastionHost, host, command)
	assert.NotContains(t, response, "Error: error moving/banning/clearing resource")
}

// test the routing path from the bastion contains a specific host
func testRoutingPathContains(t *testing.T, bastionHost ssh.Host, toHost, containsHost string) {
	logger.Logf(t, "TEST - check traceroute to %s contains %s", toHost, containsHost)
	command := fmt.Sprintf("/usr/sbin/mtr --report -c 1 %s", toHost)
	response := ssh.CheckSshCommand(t, bastionHost, command)
	assert.Contains(t, response, containsHost)
}
