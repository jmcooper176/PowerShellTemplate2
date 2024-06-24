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

	Set-Variable -Name CmdletName -Option ReadOnly -Value $MyInvocation.MyCommand.Name

	if ($PSCmdlet.ShouldProcess('Default', $CmdletName)) {
		[MyClass]::new() | Write-Output
	}
}