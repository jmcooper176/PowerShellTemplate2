{{-func isOnlySetter(member)
   ret member.isOnlySetter
end}}

{{-func isConstructorParameter(member)
   ret !member.isOnlySetter
end}}

{{-func hasConstructorParameters(members)
	ret (members | array.filter @isConstructorParameter | array.size) > 0
end}}

{{-func hasOnlySetters(members)
	ret (members | array.filter @isOnlySetter | array.size) > 0
end}}

{{- for namespace in usingNamespaces -}}
using {{namespace}};
{{~end~}}

namespace {{namespace}}
{
	public partial class {{className}}
	{{~for typeRestrictions in typeParameterRestrictions ~}}
		where {{typeRestrictions.name}} : {{for restriction in typeRestrictions.restrictions}}{{restriction}}{{if !for.last}}, {{end}}{{end}}
	{{~end~}}
	{
		{{~for member in members~}}
		private Func<{{member.type}}> _{{member.name.camelCase}};
		{{~end~}}

		public static implicit operator {{targetTypeName}}({{className}} builder) => builder.Build();

		public {{constructorName}}(
		{{~for member in members ~}}
			Func<{{member.type}}> {{member.name.camelCase}}{{if !for.last}},{{else}}){{end}}
		{{~end~}}
		{
		{{~for member in members ~}}
			_{{member.name.camelCase}} = {{member.name.camelCase}};
		{{~end~}}
		}

		public {{constructorName}}(
		{{~for member in members ~}}
			{{member.type}} {{member.name.camelCase}}{{if !for.last}},{{else}}){{end}}
		{{~end~}}
		{
		{{~for member in members ~}}
			_{{member.name.camelCase}} = () => {{member.name.camelCase}};
		{{~end~}}
		}

		public {{targetTypeName}} Build()
		{
			return new {{targetTypeName}}
			{{-if hasConstructorParameters members}}(
			{{~for member in members | array.filter @isConstructorParameter ~}}
				_{{member.name.camelCase}}()
				{{-if !for.last-}}
					,
				{{~else}}
					{{-if hasOnlySetters members-}}
						)
					{{-else}}
			);
					{{-end}}
				{{-end}}
			{{-end}}
			{{-end}}
			{{-if hasOnlySetters members}}
			{
			{{~for member in members | array.filter @isOnlySetter ~}}
				{{member.name.pascalCase}} = _{{member.name.camelCase}}(){{if !for.last}},{{end}}
			{{~end~}}
			};
			{{-end}}
		}
		{{~for member in members~}}

		public {{className}} With{{member.name.pascalCase}}(Func<{{member.type}}> value)
		{
			_{{member.name.camelCase}} = value;
			return this;
		}

		public {{className}} With{{member.name.pascalCase}}({{member.type}} value)
		{
			return With{{member.name.pascalCase}}(() => value);
		}
		{{~end~}}
	}
}