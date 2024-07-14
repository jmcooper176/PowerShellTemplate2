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
	Get-ModuleManifest
#>
function Get-ModuleManifest {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
		[SupportsWildcards()]
		[string]
		$Path,

		[Parameter(Mandatory)]
		[ValidateSet(
			'AccessMode', 'Author', 'ClrVersion', 'CompanyName', 'CompatiblePSEditions',
			'Copyright', 'Definition', 'Description', 'DotNetFrameworkVersion',
			'ExperimentalFeatures', 'ExportedAliases', 'ExportedCmdlets', 'ExportedCommands',
			'ExportedDscResources', 'ExportedFormatFiles', 'ExportedFunctions',
			'ExportedTypeFiles', 'ExportedVariables', 'FileList', 'Guid',
			'HelpInfoUri', 'IconUri', 'ImplementingAssembly', 'LicenseUri',
			'LogPipelineExecutionDetails', 'ModuleBase', 'ModuleList', 'ModuleType', 'Name',
			'NestedModules', 'OnRemove', 'Path', 'PowerShellHostName',
			'PowerShellHostVersion', 'PowerShellVersion', 'Prefix', 'PrivateData',
			'ProcessorArchitecture', 'ProjectUri', 'ReleaseNotes',
			'RepositorySourceLocation', 'RequiredAssemblies', 'RequiredModules',
			'RootModule', 'Scripts', 'SessionState', 'Tags', 'Version'
		[string[]]
		$Property
	)

	BEGIN {
		if ($PSVersionTable.PSVersion.Major -gt 5) {
			Set-StrictMode -Version latest
		} elseif ($PSVersionTable.PSVersion.Major -ge 3) {
			Set-StrictMode -Version 3.0
		} else {
			Set-StrictMode -Version 2.0
		}

		Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name
	}

	PROCESS {
		$Path | Resolve-Path | ForEach-Object -Process {
			Write-Verbose -Message "$($CmdletName):  Path '$($_)'"
			Test-ModuleManifest -Path $_ | Select-Object -Property $Property | Write-Output
		}
	}
}

<#
	New-ErrorRecord
#>
function New-ErrorRecord {
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[Parameter(Mandatory)]
		[System.Exception]
		$Exception,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]
		$ErrorId,

		[Parameter(Mandatory)]
		[ValidateSet()]
		[System.Management.Automation.ErrorCategory]
		$ErrorCategory,

		[Parameter(Mandatory)]
		[AllowNull()]
		[System.Object]
		$TargetObject
	)

	if ($PSVersionTable.PSVersion.Major -gt 5) {
		Set-StrictMode -Version latest
	} elseif ($PSVersionTable.PSVersion.Major -ge 3) {
		Set-StrictMode -Version 3.0
	} else {
		Set-StrictMode -Version 2.0
	}

	Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name -WhatIf:$false

	$argumentList = New-Object -TypeName System.Collections.ArrayList | Out-Null
	$argumentList.Add($Exception) | Out-Null
	$argumentList.Add($ErrorId) | Out-Null
	$argumentList.Add($ErrorCategory) | Out-Null
	$argumentList.Add($TargetObject) | Out-Null

	if ($PSCmdlet.ShouldProcess($Exception.GetType().Name, $CmdletName)) {
		New-Object -TypeName System.Management.Automation.ErrorRecord -ArgumentList $argumentList.ToArray() | Write-Output
	}
}

<#
	Write-Exception
#>
function Write-Exception {

}

<#
	Test-Module
#>
function Test-Module {
	[CmdletBinding()]
	[OutputType([bool])]
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[string[]]
		$Name
	)

	BEGIN {
		if ($PSVersionTable.PSVersion.Major -gt 5) {
			Set-StrictMode -Version latest
		} elseif ($PSVersionTable.PSVersion.Major -ge 3) {
			Set-StrictMode -Version 3.0
		} else {
			Set-StrictMode -Version 2.0
		}

		Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name
	}

	PROCESS {
		$Name | ForEach-Object -Process {
			(Get-Module -ListAvailable |
				Where-Object -Property Name -EQ $_ |
					Measure-Object |
						Select-Object -ExpandProperty Count) -gt 0 | Write-Output
		}
	}
}
