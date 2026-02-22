Extension { #name : #MCVariableDefinition }

{
	#category : #'*MethodMorseDomains-Code-comparing-override',
	#'squeak_changestamp' : 'ct 2/22/2026 01:01'
}
MCVariableDefinition >> = other [
	self flag: #(workaround yaros).
	^ ((self perform: #species) name = (other perform: #species) name)
		and: [self name = other name]
]
