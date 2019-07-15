all: dep test

dep:
	dep ensure -v

test:
	go test -v -timeout 90m .

test-no-teardown:
	SKIP_teardown=true go test -v -timeout 90m .
