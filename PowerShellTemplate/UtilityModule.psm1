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
    Format-ErrorId
#>
function Format-ErrorId {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Caller,

        [Parameter(Mandatory)]
        [System.Exception]
        $Exception,

        [Parameter(Mandatory)]
        [ValidateRange(1, 2147483647)]
        [int]
        $Line
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

    ('{0}-{1}-{2}' -f $Caller, $Exception.GetType().Name, $Line) | Write-Output
}

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
            'RootModule', 'Scripts', 'SessionState', 'Tags', 'Version')]
        [string[]]
        $Property
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
    }
    elseif ($PSVersionTable.PSVersion.Major -ge 3) {
        Set-StrictMode -Version 3.0
    }
    else {
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
        }
        elseif ($PSVersionTable.PSVersion.Major -ge 3) {
            Set-StrictMode -Version 3.0
        }
        else {
            Set-StrictMode -Version 2.0
        }

        Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name
    }

    PROCESS {
        $Name | ForEach-Object -Process {
            (Get-Module -ListAvailable | Where-Object -Property Name -EQ $_ | Measure-Object | Select-Object -ExpandProperty Count) -gt 0 | Write-Output
        }
    }
}

<#
    Write-Exception
#>
function Write-Exception {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Exception]
        $Exception,

        [Parameter(Mandatory)]
        [string]
        $ErrorId,

        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorCategory]
        $ErrorCategory,

        [Parameter(Mandatory)]
        [System.Object]
        [AllowNull()]
        $TargetObject
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
    }

    PROCESS {
        $Exception | ForEach-Object -Process { New-ErrorRecord -Exception $_ -ErrorId $ErrorId -ErrorCategory $ErrorCategory -TargetObject $TargetObject | Write-Output }
    }
}

<#
    Write-Fatal
#>
function Write-Fatal {
    [CmdletBinding(DefaultParameterSetName = 'UsingErrorRecord')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'UsingErrorRecord', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord,

        [Parameter(Mandatory, ParameterSetName = 'UsingException', ValueFromPipelineByPropertyName)]
        [System.Exception]
        $Exception,

        [Parameter(Mandatory, ParameterSetName = 'UsingMessage', ValueFromPipelineByPropertyName)]
        [string]
        $Message,

        [Parameter(Mandatory, ParameterSetName = 'UsingException')]
        [Parameter(Mandatory, ParameterSetName = 'UsingMessage')]
        [System.Management.Automation.ErrorCategory]
        $ErrorCategory
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

        if ($PSCmdlet.ParameterSetName -eq 'UsingErrorRecord') {
            $topError = $ErrorRecord
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'UsingException') {
            $topException = $Exception
        }
        else {
            $topException = [System.Exception]::new($Message)
        }
    }

    PROCESS {
        switch ($PSCmdlet.ParameterSetName) {
            'UsingException' {
                $errorId = Format-ErrorId -Caller $CmdletName -Exception $Exception -Line $MyInvocation.ScriptLineNumber
                $Exception | Write-Exception -ErrorId $errorId -ErrorCategory $ErrorCategory -TargetObject $Exception.Source | Write-Error -ErrorAction Continue
                break
            }

            'UsingMessage' {
                $errorId = Format-ErrorId -Caller $CmdletName -Exception [System.Exception]::new() -Line $MyInvocation.ScriptLineNumber
                $Message | Write-Message -ErrorId $errorId -ErrorCategory $ErrorCategory -TargetObject $Message | Write-Error Continue
                break
            }

            default {
                $ErrorRecord | Write-Error -ErrorAction Continue
                break
            }
        }
    }

    END {
        if (Test-Path -LiteralPath variable:topError) {
            $PSCmdlet.ThrowTerminatingError($topError)
        }
        else {
            throw $topException
        }
    }
}

<#
    Write-Message
#>
function Write-Message {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $Message,

        [Parameter(Mandatory)]
        [string]
        $ErrorId,

        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorCategory]
        $ErrorCategory,

        [Parameter(Mandatory)]
        [System.Object]
        [AllowNull()]
        $TargetObject
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
    }

    PROCESS {
        $Message | ForEach-Object -Process { New-ErrorRecord -Exception [System.Exception]::new($_) -ErrorId $ErrorId -ErrorCategory $ErrorCategory -TargetObject $TargetObject | Write-Output }
    }
}
