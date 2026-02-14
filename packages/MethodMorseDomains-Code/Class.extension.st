Extension { #name : #Class }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 18:59'
}
Class >> asMorseItemIn: aCodeProject [

	^ self asClassDefinition asMorseItemIn: aCodeProject
]
