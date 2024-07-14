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