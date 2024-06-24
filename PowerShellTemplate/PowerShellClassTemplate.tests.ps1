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


Describe "New-MyClass" {
	Context "Factory Exists" {
		BeforeAll {
			# Arrange
			$modulePath = Join-Path -Path $PWD -ChildPath PowerShellClassTemplate.psd1
			Import-Module -Name $modulePath -Verbose -Force
		}

		AfterAll {
			@('PowerShellClassTemplate') | ForEach-Object -Process {
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

		AfterAll {
			@('PowerShellClassTemplate') | ForEach-Object -Process {
				if (Get-Module -ListAvailable | Where-Object -Property Name -EQ $_) {
					Remove-Module -Name $_ -Verbose -Force
				}
			}
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