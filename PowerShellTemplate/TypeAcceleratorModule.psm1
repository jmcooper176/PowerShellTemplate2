<#
	Add-TypeAccelerator
#>
function Add-TypeAccelerator {
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[System.Type[]]
		$Type
	)

	BEGIN {
		if ($PSVersionTable.PSVersion.Major -gt 5) {
			Set-StrictMode -Version latest
		} elseif ($PSVersionTable.PSVersion.Major -ge 3) {
			Set-StrictMode -Version 3.0
		} else {
			Set-StrictMode -Version 2.0
		}

		Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name -WhatIf:$false

		$accelerators = [psobject].Assembly.GetType(
			'System.Management.Automation.TypeAccelerators'
		)
	}

	PROCESS {
		$Type | ForEach-Object -Process {
			if ($PSCmdlet.ShouldProcess($_.FullName, $CmdletName)) {
				if ($accelerators::Get.TryAdd($_.FullName, $_)) {
					$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
						Remove-TypeAccelerator -Name $_.FullName
					}.GetNewClosure()
				} else {
					$message = @(
						$CmdletName
						"Failed adding $($_.FullName) to [TypeAccelerators]"
					) -join ' : '

					$errorRecord = [System.Management.Automation.ErrorRecord]::new(
						[System.InvalidOperationException]::($message),
						"$($CmdletName)-InvalidOperationExceptin-$($MyInvocation.ScriptLineNumber)",
						'InvalidOperation'
						$_)

					Write-Error -ErrorRecord $errorRecord -ErrorAction Continue
					$PSCmdlet.ThrowTerminatingError($errorRecord)
				}
			}
		}
	}

	<#
		.SYNOPSIS
		.DESCRIPTION
		.PARAMETER Type
		.INPUTS
		.OUTPUTS
		.EXAMPLE
		.NOTES
		.LINK
		about_Advanced_Functions
		.LINK
		about_CommonParameters
	#>
}

<#
	Get-TypeAccelerator
#>
function Get-TypeAccelerator {
	[CmdletBinding()]
	param (
		[ValidateNotNullOrEmpty()]
		[string]
		$Key,

		[switch]
		$ListAvailable
	)

	if ($PSVersionTable.PSVersion.Major -gt 5) {
		Set-StrictMode -Version latest
	} elseif ($PSVersionTable.PSVersion.Major -ge 3) {
		Set-StrictMode -Version 3.0
	} else {
		Set-StrictMode -Version 2.0
	}

	Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name

	$accelerators = [psobject].Assembly.GetType(
		'System.Management.Automation.TypeAccelerators'

	if ($ListAvailable.IsPresent) {
		$accelerators::Get | Select-Object -ExpandProperty Keys | Write-Output
	} elseif ($PSBoundParameters.ContainsKey('Key')) {
		[ref]$acceleratorType = $null
		if ($accelerators::Get.TryGetValue($Key, $acceleratorType)) {
			$acceleratorType | Write-Output
		} else {
			$null | Write-Output
		}
	}

	<#
		.SYNOPSIS
		.DESCRIPTION
		.PARAMETER Type
		.INPUTS
		.OUTPUTS
		.EXAMPLE
		.NOTES
		.LINK
		about_Advanced_Functions
		.LINK
		about_CommonParameters
	#>
}

<#
	New-TypeAccelerators
#>
function New-TypeAccelerators {
	[CmdletBinding(SupportsShouldProcess)]
	param ()

	if ($PSVersionTable.PSVersion.Major -gt 5) {
		Set-StrictMode -Version latest
	} elseif ($PSVersionTable.PSVersion.Major -ge 3) {
		Set-StrictMode -Version 3.0
	} else {
		Set-StrictMode -Version 2.0
	}

	Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name -WhatIf:$false

	$typeAccelerators = [psobject].Assembly.GetType(
		'System.Management.Automation.TypeAccelerators'
	)

	Add-TypeAccelerator -Type $typeAccelerators | Write-Output

	<#
		.SYNOPSIS
		.DESCRIPTION
		.PARAMETER Type
		.INPUTS
		.OUTPUTS
		.EXAMPLE
		.NOTES
		.LINK
		about_Advanced_Functions
		.LINK
		about_CommonParameters
	#>
}

<#
	Remove-TypeAccelerator
#>
function Remove-TypeAccelerator {
	[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'UsingType')]
	[OutputType([bool])]
	param (
		[Parameter(Mandatory, ParameterSetName = 'UsingName', ValueFromPipelineByPropertyName)]
		[string[]]
		$Name,

		[Parameter(Mandatory, ParameterSetName = 'UsingType', ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[System.Type[]]
		$Type
	)

	BEGIN {
		if ($PSVersionTable.PSVersion.Major -gt 5) {
			Set-StrictMode -Version latest
		} elseif ($PSVersionTable.PSVersion.Major -ge 3) {
			Set-StrictMode -Version 3.0
		} else {
			Set-StrictMode -Version 2.0
		}

		Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name -WhatIf:$false

		$accelerators = [psobject].Assembly.GetType(
			'System.Management.Automation.TypeAccelerators'
	}

	PROCESS {
		if ($PSCmdlet.ParameterSetName -eq 'UsingName') {
			$Name | ForEach-Object -Process {
				if ($PSCmdlet.ShouldProcess($_, $CmdletName)) {
					$accelerators::Remove($_) | Write-Output
				}
			}
		} else {
			$Type | ForEach-Object -Process {
				Remove-TypeAccelerator -Name $_.FullName
			}
		}
	}

	<#
		.SYNOPSIS
		.DESCRIPTION
		.PARAMETER Type
		.INPUTS
		.OUTPUTS
		.EXAMPLE
		.NOTES
		.LINK
		about_Advanced_Functions
		.LINK
		about_CommonParameters
	#>
}

<#
	Test-TypeAccelerator
#>
function Test-TypeAccelerator {
	[CmdletBinding(DefaultParameterSetName = 'UsingType')]
	[OutputType([bool])]
	param (
		[Parameter(Mandatory, ParameterSetName = 'UsingName', ValueFromPipelineByPropertyName)]
		[string[]]
		$Name,

		[Parameter(Mandatory, ParameterSetName = 'UsingType', ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[System.Type[]]
		$Type
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

		$accelerators = [psobject].Assembly.GetType(
			'System.Management.Automation.TypeAccelerators'
		)
	}

	PROCESS {
		if ($PSCmdlet.ParameterSetName -eq 'UsingName') {
			$Name | ForEach-Object -Process {
				$accelerators::Get.ContainsKey($_) | Write-Output
			}
		} else {
			$Type | ForEach-Object -Process {
				$accelerators::Get.ContainsValue($_) | Write-Output
			}
		}
	}

	<#
		.SYNOPSIS
		Test `Name` or `Type` for whether there is a matching [TypeAccelerator]
		already created.

		.DESCRIPTION
		`Test-TypeAccerator` tests `Name` or `Type` for whether there is a
		matching [TypeAccelerator] already created.

		.PARAMETER Name
		Specifies the fully qualified dotted name for the [TypeAccelerator] to test
		for.  This parameter is mandatory and mutually-exclusive with `Type`.

		.PARAMETER Type
		Specifies the .NET type for the [TypeAccelerator] to test for.  This parameter
		is mandatory and mutually-exclusive with `Name`.

		.INPUTS
		[string] `Test-TypeAccelerator accepts [string] as input from the PowerShell
		pipeline.

		[type]  `Test-TypeAccelerator accepts [type] as input from the PowerShell
		pipeline.

		.OUTPUTS
		[bool] `Test-TypeAccelerator` outputs [bool] to the PowerShell pipeline.

		.EXAMPLE
		PS> Test-TypeAccelerator -Name 'System.XXX'

		False

		Type 'System.XXX' does not have a [TypeAccelerator] associated with it.

		.EXAMPLE
		PS> [int] | Test-TypeAccelerator

		True

		Type [int] does have a [TypeAccelerator] associated with it.

		.NOTES
		Copyright (c) 2024, John Merryweather Cooper.  All Rights Reserved.

		See LICENSE included with this script.

		.LINK
		about_Advanced_Functions

		.LINK
		about_CommonParameters

		.LINK
		ForEach-Object

		.LINK
		Set-StrictMode

		.LINK
		Set-Variable
	#>
}
