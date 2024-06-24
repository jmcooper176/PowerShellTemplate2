<#
    enum: Color
#>
enum Color
{
    Red
    Green
    Blue
}

# Define the type(s) to export with type accelerators.
$ExportableTypes = @(
    [Color]
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