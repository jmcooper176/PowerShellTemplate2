[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name
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

Set-Variable -Name ScriptName -Option ReadOnly -Value $MyInvocation.MyCommand.Name -WhatIf:$false

Write-Information -MessageData "$($ScriptName) : Post-Build Script for Name 'PowerShellEnumTemplate'" -InformationAction Continue
