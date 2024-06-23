<#
	My Function
#>
function Get-Function {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]
		$Value
	)

	if ($PSVersionTable.PSVersion.Major -gt 5) {
		Set-StrictMode -Version latest
	} elseif ($PSVersionTable.PSVersion.Major -ge 3) {
		Set-StrictMode -Version 3.0
	} else {
		Set-StrictMode -Version 2.0
	}

	Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name

	$Value | Write-Output

	<#
		.SYNOPSIS
		Echoes 'Value' to the output pipeline.

		.DESCRIPTION
		`Get-Function` echoes 'Value' to the output pipeline.

		.PARAMETER Value
		Specifies the string value to be echoed.  This parameter is mandatory.
		This parameter cannot be null or an empty string.

		.INPUT
		None.  `Get-Function` receives no input from the pipeline.

		.OUTPUT
		[string]  `Get-Function outputs a string to the pipeline.

		.EXAMPLE
		PS> Get-Function 'Value'

		Value

		.NOTES
		None.

		.LINK
		about_Advanced_Functions

		.LINK
		about_CommonParameters

		.LINK
		Set-StrictMode

		.LINK
		Set-Variable

		.LINK
		Write-Output
	#>
}