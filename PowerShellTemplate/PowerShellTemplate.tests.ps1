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