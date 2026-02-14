Extension { #name : #MethodReference }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:00'
}
MethodReference >> asMorseItemIn: aCodeProject [

	^ self asMethodDefinition asMorseItemIn: aCodeProject
]
