<#
	My Function
#>
function Get-Function {
	[CmdletBinding()]
	param ()

	if ($PSVersionTable.Major -gt 5) {
		Set-StrictMode -Version latest
	} elseif ($PSVersionTable -ge 3) {
		Set-StrictMode -Version 3.0
	} else {
		Set-StrictMode -Version 2.0
	}

	Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name
}