<#
Copyright (c) 2024, John Merryweather Cooper.  All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
   may be used to endorse or promote products derived from this software without
   specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests.
# You can download Pester from https://go.microsoft.com/fwlink/?LinkID=534084
#

<#
	.SYNOPSIS
	Runs Pester unit tests.

	.DESCRIPTION
	`PowerShellClassTemplate.tests.ps1` runs Pester unit tests.

	.INPUT
	None.

	.OUTPUT
	None.

	.EXAMPLE
	PS> .\PowerShellClassTemplate.tests.ps1

	Starting discovery in 1 files.
	Discovery found 3 tests in 102ms.
	Running tests.
	[+] D:\GitHub\PowerShellTemplate\PowerShellTemplate\PowerShellClassTemplate.tests.ps1 741ms (233ms|358ms)
	Tests completed in 758ms
	Tests Passed: 3, Failed: 0, Skipped: 0, Inconclusive: 0, NotRun: 0

	.NOTES
	None.
#>

Describe "Color Enumeration" {
    Context "Type Accelerator" {
        BeforeAll {
            # Arrange
            $modulePath = Join-Path -Path $PWD -ChildPath PowerShellEnumTemplate.psd1
            Import-Module -Name $modulePath -Verbose -Force
        }

        AfterAll {
            @('PowerShellEnumTemplate') | ForEach-Object -Process {
                if (Get-Module -ListAvailable | Where-Object -Property Name -EQ $_) {
                    Remove-Module -Name $_ -Verbose -Force
                }
            }
        }

        It "Module Path should exist" {
            # Act and Assert
            Test-Path -LiteralPath $modulePath -PathType Leaf | Should -BeTrue
        }
    }
}
