<#
    Copyright (c) 2024, John Merryweather Cooper.  All Rights Reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are
    met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

    3. Neither the name of the copyright holder nor the names of its
       contributors may be used to endorse or promote products derived
       from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
    PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
    HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

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
        }
        elseif ($PSVersionTable.PSVersion.Major -ge 3) {
            Set-StrictMode -Version 3.0
        }
        else {
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
                }
                else {
                    $message = @(
                        $CmdletName
                        "Failed adding $($_.FullName) to [TypeAccelerators]"
                    ) -join ' : '

                    $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                        [System.InvalidOperationException]::($message),
                        "$($CmdletName)-InvalidOperationException-$($MyInvocation.ScriptLineNumber)",
                        'InvalidOperation',
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
    }
    elseif ($PSVersionTable.PSVersion.Major -ge 3) {
        Set-StrictMode -Version 3.0
    }
    else {
        Set-StrictMode -Version 2.0
    }

    Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name

    $accelerators = [psobject].Assembly.GetType(
        'System.Management.Automation.TypeAccelerators'
    )

    if ($ListAvailable.IsPresent) {
        $accelerators::Get | Select-Object -ExpandProperty Keys | Write-Output
    }
    elseif ($PSBoundParameters.ContainsKey('Key')) {
        [ref]$acceleratorType = $null
        if ($accelerators::Get.TryGetValue($Key, $acceleratorType)) {
            $acceleratorType | Write-Output
        }
        else {
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
    New-TypeAccelerator
#>
function New-TypeAccelerator {
    [CmdletBinding(SupportsShouldProcess)]
    param ()

    if ($PSVersionTable.PSVersion.Major -gt 5) {
        Set-StrictMode -Version latest
    }
    elseif ($PSVersionTable.PSVersion.Major -ge 3) {
        Set-StrictMode -Version 3.0
    }
    else {
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
        }
        elseif ($PSVersionTable.PSVersion.Major -ge 3) {
            Set-StrictMode -Version 3.0
        }
        else {
            Set-StrictMode -Version 2.0
        }

        Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name -WhatIf:$false

        $accelerators = [psobject].Assembly.GetType(
            'System.Management.Automation.TypeAccelerators'
        )
    }

    PROCESS {
        if ($PSCmdlet.ParameterSetName -eq 'UsingName') {
            $Name | ForEach-Object -Process {
                if ($PSCmdlet.ShouldProcess($_, $CmdletName)) {
                    $accelerators::Remove($_) | Write-Output
                }
            }
        }
        else {
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
        }
        elseif ($PSVersionTable.PSVersion.Major -ge 3) {
            Set-StrictMode -Version 3.0
        }
        else {
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
        }
        else {
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
