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
