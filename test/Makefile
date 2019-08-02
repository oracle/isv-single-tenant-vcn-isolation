all: dep test

dep:
	dep ensure -v

test:
	go test -v -timeout 90m .

test-no-teardown:
	SKIP_teardown=true go test -v -timeout 90m .

test-fmt:
	go test -v -timeout 90m . -run="TestTerraformFmt.*"

test-validate-only:
	SKIP_deploy=true SKIP_plan=true SKIP_teardown=true go test -v -timeout 90m . --run="TestTerragruntApplyAll"

.PHONY: all dep test test-no-teardown test-fmt test-validate-only