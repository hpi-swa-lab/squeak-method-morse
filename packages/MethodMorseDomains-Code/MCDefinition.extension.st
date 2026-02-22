Extension { #name : #MCDefinition }

{
	#category : #'*MethodMorseDomains-Code-comparing-override',
	#'squeak_changestamp' : 'ct 2/22/2026 01:00'
}
MCDefinition >> = aDefinition [
	self flag: #(workaround yaros).
	^("aDefinition isKindOf: MCDefinition"(Smalltalk classNamed: (aDefinition perform: #class) name) includesBehavior: MCDefinition) and: [self isRevisionOf: aDefinition]
]

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:00'
}
MCDefinition >> asMorseItemIn: aCodeProject [

	^ nil
]
