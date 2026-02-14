Extension { #name : #Trait }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:01'
}
Trait >> asMorseItemIn: aCodeProject [

	^ self asClassDefinition asMorseItemIn: aCodeProject
]
