<#
Copyright 2024, John Merryweather Cooper.  All Rights Reserved.

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