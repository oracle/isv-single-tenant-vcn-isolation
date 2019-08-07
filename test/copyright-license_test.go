package test

// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

import (
	"bufio"
	"os"
	"os/exec"
	"testing"

	"github.com/stretchr/testify/assert"
)

const (
	CopyrightStatement = "Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved."
	LicenseStatement   = "Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl."
)

// Check that all Terraform files contain the required copyright and license statement
func TestCopyrightLicenseForTerraform(t *testing.T) {
	t.Parallel()

	directories := []string{
		"../modules",
		"../examples",
	}

	testCopyrightLicense(t, ".tf", directories, "//", 1)

}

// Test Copyright and License are included in all Golang files
func TestCopyrightLicenseForGo(t *testing.T) {
	t.Parallel()

	directories := []string{
		"../test",
	}

	testCopyrightLicense(t, ".go", directories, "//", 3)
}

// Test Copyright and License are included in all Chef ruby scripts
func TestCopyrightLicenseForChef(t *testing.T) {
	t.Parallel()

	directories := []string{
		"../chef",
	}

	testCopyrightLicense(t, ".rb", directories, "#", 1)
}

// Generic fuction to look for the license and copyright comments is a file
func testCopyrightLicense(t *testing.T, filetype string, directories []string, commentPrefix string, startAt int) {

	for _, dir := range directories {
		cmd := exec.Command("find", dir, "-name", "*"+filetype, "-not", "-path", "*/test/vendor/*")

		stdout, err := cmd.StdoutPipe()
		assert.NoError(t, err)

		err = cmd.Start()
		assert.NoError(t, err)

		in := bufio.NewScanner(stdout)

		for in.Scan() {
			filename := in.Text()
			file, err := os.Open(filename)
			assert.NoError(t, err)
			defer file.Close()

			scanner := bufio.NewScanner(file)

			// skip non-header lines
			for startLine := 1; startLine <= startAt; startLine++ {
				scanner.Scan()
			}

			firstLine := scanner.Text()
			scanner.Scan()
			secondLine := scanner.Text()

			// Check first two lines are comments with the copyright and license statements
			assert.Equal(t, commentPrefix+" "+CopyrightStatement, firstLine, filename)
			assert.Equal(t, commentPrefix+" "+LicenseStatement, secondLine, filename)
		}
	}
}
