Integration Tests
=================

These tests use the [Terratest](https://github.com/gruntwork-io/terratest) testing framwork.

## Prerequisites

Terratest is based on the Go language test framwork.  Prior to running the testing [Install Go](https://golang.org/doc/install) and [`dep` the Go dependency manager](https://golang.github.io/dep/docs/installation.html).  

To run the tests the whole project directory must be located within your `$GOPATH`. 

```
$ export GOPATH=~/go
$ cd $GOPATH/src
$ git clone <project_uri>
```

Run `dep` to install the terratest go modules and other dependnecies

```
$ cd $GOPATH/src/<project>/test
$ dep ensure -v
```

## Running Tests

Run all tests

```
$ go test -v -timeout 90m .
```

To run a single test

```
$ go test -v -timeout 90m -run=TestTerragruntApplyAll
```

Individual test stages can be skipped using the `SKIP_<stage_name>` environment variables. e.g. to skip the teardown stage

```
$ SKIP_teardown=true go test -v -timeout 90m -run=TestTerragruntApplyAll
```


