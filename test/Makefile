all: dep test

dep:
	dep ensure -v

test:
	go test -v -timeout 90m .

test-no-teardown:
	SKIP_teardown=true go test -v -timeout 90m .

test-fmt:
	go test -v -timeout 90m . -run="TestTerraformFmt.*"


.PHONY: all dep test test-no-teardown