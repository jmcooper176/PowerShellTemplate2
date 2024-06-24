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


Describe "New-MyClass" {
	Context "Factory Exists" {
		BeforeAll {
			# Arrange
			$modulePath = Join-Path -Path $PWD -ChildPath PowerShellClassTemplate.psd1
			Import-Module -Name $modulePath -Verbose -Force
		}

		It "Module Path should exist" {
			# Act and Assert
			Test-Path -LiteralPath $modulePath -PathType Leaf | Should -BeTrue
		}

		It "Should Import" {
			# Arrange
			$functionPath = Join-Path -Path function: -ChildPath 'New-MyClass'

			# Act and Assert
			Test-Path -LiteralPath $functionPath | Should -BeTrue
		}
	}

	Context "Factory Performs as Designed" {
		BeforeAll {
			# Arrange
			$modulePath = Join-Path -Path $PWD -ChildPath PowerShellClassTemplate.psd1
			Import-Module -Name $modulePath -Verbose -Force
		}

		It "Property 'MyProperty' should be set to expected value" {
			# Arrange
			$instance = New-MyClass
			$expected = 'MyValue'

			# Act and Assert
			$instance.MyProperty | Should -BeExactly $expected
		}

	}
}