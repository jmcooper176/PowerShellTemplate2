#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests.
# You can download Pester from https://go.microsoft.com/fwlink/?LinkID=534084
#

<#
	.SYNOPSIS
	Runs Pester unit tests.

	.DESCRIPTION
	`PowerShellTemplate.tests.ps1` runs Pester unit tests.

	.INPUT
	None.

	.OUTPUT
	None.

	.EXAMPLE
	PS> .\PowerShellTemplate.tests.ps1

	Starting discovery in 1 files.
	Discovery found 6 tests in 182ms.
	Running tests.
	VERBOSE: Loading module from path 'D:\GitHub\PowerShellTemplate\PowerShellTemplate\PowerShellTemplate.psd1'.
	VERBOSE: Loading module from path 'D:\GitHub\PowerShellTemplate\PowerShellTemplate\PowerShellClassTemplate.psm1'.
	VERBOSE: Loading module from path 'D:\GitHub\PowerShellTemplate\PowerShellTemplate\PowerShellEnumTemplate.psm1'.
	VERBOSE: Loading module from path 'D:\GitHub\PowerShellTemplate\PowerShellTemplate\PowerShellTemplate.psm1'.
	VERBOSE: Exporting function 'Get-Function'.
	VERBOSE: Importing function 'Get-Function'.
	VERBOSE: Loading module from path 'D:\GitHub\PowerShellTemplate\PowerShellTemplate\PowerShellTemplate.psd1'.
	VERBOSE: Removing the imported "Get-Function" function.
	VERBOSE: Loading module from path 'D:\GitHub\PowerShellTemplate\PowerShellTemplate\PowerShellClassTemplate.psm1'.
	VERBOSE: Loading module from path 'D:\GitHub\PowerShellTemplate\PowerShellTemplate\PowerShellEnumTemplate.psm1'.
	VERBOSE: Loading module from path 'D:\GitHub\PowerShellTemplate\PowerShellTemplate\PowerShellTemplate.psm1'.
	VERBOSE: Exporting function 'Get-Function'.
	VERBOSE: Importing function 'Get-Function'.
	[+] D:\GitHub\PowerShellTemplate\PowerShellTemplate\PowerShellTemplate.tests.ps1 741ms (233ms|358ms)
	Tests completed in 758ms
	Tests Passed: 6, Failed: 0, Skipped: 0, Inconclusive: 0, NotRun: 0

	.NOTES
	None.
#>


Describe "Get-Function" {
	Context "Function Exists" {
		BeforeAll {
			# Arrange
			$modulePath = Join-Path -Path $PWD -ChildPath PowerShellTemplate.psd1
			Import-Module -Name $modulePath -Verbose -Force
		}

		AfterAll {
			@('PowerShellTemplate') | ForEach-Object -Process {
				if (Get-Module -ListAvailable | Where-Object -Property Name -EQ $_) {
					Remove-Module -Name $_ -Verbose -Force
				}
			}
		}

		It "Module Path should exist" {
			# Act and Assert
			Test-Path -LiteralPath $modulePath -PathType Leaf | Should -BeTrue
		}

		It "Should Import" {
			# Arrange
			$functionPath = Join-Path -Path function: -ChildPath 'Get-Function'

			# Act and Assert
			Test-Path -LiteralPath $functionPath | Should -BeTrue
		}
	}

	Context "Function Performs as Designed" {
		BeforeAll {
			# Arrange
			$modulePath = Join-Path -Path $PWD -ChildPath PowerShellTemplate.psd1
			Import-Module -Name $modulePath -Verbose -Force
		}

		AfterAll {
			@('PowerShellTemplate') | ForEach-Object -Process {
				if (Get-Module -ListAvailable | Where-Object -Property Name -EQ $_) {
					Remove-Module -Name $_ -Verbose -Force
				}
			}
		}

		It "Should Return the Same 'Value' Passed as a Parameter" {
			# Arrange
			$expected = 'Test'

			# Act and Assert
			Get-Function -Value $expected | Should -BeExactly $expected
		}

		It "Should Return the Same 'Value' with spaces Passed as a Parameter" {
			# Arrange
			$expected = 'This is a Test'

			# Act and Assert
			Get-Function -Value $expected | Should -BeExactly $expected
		}

		It "Should throw on null" {
			# Arrange
			$test = $null

			# Act and Assert
			{ Get-Function -Value $test } | Should -Throw
		}

		It "Should throw on empty string" {
			# Arrange
			$test = ''

			# Act and Assert
			{ Get-Function -Value $test } | Should -Throw
		}
	}
}