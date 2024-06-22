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