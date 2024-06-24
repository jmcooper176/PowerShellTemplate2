<#
    class : MyClass
#>
class MyClass
{
    <#
        Properties
    #>
    [ValidateNotNullOrEmpty()]
    [string]
    $MyProperty

    <#
        Public methods
    #>
    MyPublicMethod() {

    }

    <#
        Static methods
    #>
    static MyStaticMethod() {

    }

    <#
        Private methods
    #>
    hidden MyPrivateMethod() {

    }

    <#
        Constructors
    #>
    MyClass() {
        $this.MyProperty = 'MyValue'
    }
}

<#
    Factory Cmdlet
#>
function New-MyClass {
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

    if ($PSCmdlet.ShouldProcess('Default', $CmdletName)) {
        [MyClass]::new() | Write-Output
    }
}

# Define the type(s) to export with type accelerators.
$ExportableTypes = @(
    [MyClass]
)

# Get the internal TypeAccelerators class to use its static methods.
$TypeAcceleratorsClass = [psobject].Assembly.GetType(
    'System.Management.Automation.TypeAccelerators'
)

# Ensure none of the types would clobber an existing type accelerator.
# If a type accelerator with the same name exists, throw an exception.
$ExistingTypeAccelerators = $TypeAcceleratorsClass::Get

$ExportableTypes | ForEach-Object -Process {
    $Type = $_

    if ($Type.FullName -in $ExistingTypeAccelerators.Keys) {
        # ERROR:  Type accelerator already present
        $Message = @(
            $Type.Name
            "Unable to register type accelerator '$($Type.FullName)'"
            'Accelerator already exists.'
        ) -join ' : '

        $errorRecord = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($Message),
            "$($Type.Name)-InvalidOperation-$($MyInvocation.ScriptLineNumber)",
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $Type.FullName
        )

        Write-Error -ErrorRecord $errorRecord -ErrorAction Continue
        $PSCmdlet.ThrowTerminatingError($errorRecord)
    } else {
        # Add type accelerator
        $TypeAcceleratorsClass::Add($Type.FullName, $Type)
    }
}

# Register Removal of type accelerator(s) when the module is removed.
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    $ExportableTypes | ForEach-Object -Process {
        $Type = $_
        $TypeAcceleratorsClass::Remove($Type.FullName)
    }
}.GetNewClosure()