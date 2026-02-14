Extension { #name : #CompiledMethod }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 18:59'
}
CompiledMethod >> asMorseItemIn: aCodeProject [

	^ self morseAsMCDefinition asMorseItemIn: aCodeProject
]

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/1/2026 04:05'
}
CompiledMethod >> morseAsMCDefinition [

	| methodClass selector |
	methodClass := self methodClass.
	selector := self selector.
	^ MCMethodDefinition new
		initializeWithClassName: methodClass theNonMetaClassName
		classIsMeta: methodClass isMeta
		selector: selector
		category: (methodClass whichCategoryIncludesSelector: selector)
		timeStamp: self timeStamp
		source: self getSource
]
