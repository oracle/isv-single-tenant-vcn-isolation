Automated Integration Tests
===========================

These tests use the [Terratest](https://github.com/gruntwork-io/terratest) testing framwork.

## Prerequisites

Terratest is based on Go language test framwork.  The Go dependency managed `dep` is also required.  To run the tests the whole project directory must be located within your `$GOPATH`. 


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



