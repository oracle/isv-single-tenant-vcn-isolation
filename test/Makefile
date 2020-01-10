all: dep test

dep:
	dep ensure -v

test:
	go test -v -timeout 90m .

test-no-teardown:
	SKIP_teardown=true go test -v -timeout 90m .

test-fmt:
	go test -v -timeout 30s . -run="TestTerraformFmt"

test-validate-only:
	SKIP_deploy=true SKIP_plan=true SKIP_teardown=true SKIP_validate_nagios=true go test -v -timeout 90m . --run="TestTerragruntApplyAll"

test-validate-only-with-nagios:
	SKIP_deploy=true SKIP_plan=true SKIP_teardown=true go test -v -timeout 90m . --run="TestTerragruntApplyAll"

test-copyright:
	go test -v -timeout 30s . -run="TestCopyrightLicense"

.PHONY: all dep test test-no-teardown test-fmt test-validate-only test-copyright
