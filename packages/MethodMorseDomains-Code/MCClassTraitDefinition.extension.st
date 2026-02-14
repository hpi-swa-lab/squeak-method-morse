Extension { #name : #MCClassTraitDefinition }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 18:59'
}
MCClassTraitDefinition >> asMorseItemIn: aCodeProject [

	^ MorseCodeItem
		forDefinition: self
		project: aCodeProject
]
