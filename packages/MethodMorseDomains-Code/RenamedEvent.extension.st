Extension { #name : #RenamedEvent }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:05'
}
RenamedEvent >> asMorseCategoryChangesInProject: aCodeProject [

	^ (super asMorseCategoryChangesInProject: aCodeProject)
		, (self asMorseCategoryElementChangesInProject: aCodeProject)
]

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:05'
}
RenamedEvent >> asMorseCategoryElementChangesInProject: aCodeProject [

	^ self morseAsCategoryElementEvents gather: [:event |
		event asMorseChangesInProject: aCodeProject]
]

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:01'
}
RenamedEvent >> asOldMorseItemIn: aCodeProject [

	| morseItem |
	self itemKind = #class ifFalse: [^ super asOldMorseItemIn: aCodeProject].
	
	morseItem := self asMorseItemIn: aCodeProject.
	morseItem definition:
		(morseItem definition morseWithName: self oldName).
	^ morseItem
]

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/2/2026 01:16'
}
RenamedEvent >> morseAsCategoryElementEvents [

	^ self itemKind
		caseOf:
			{[#category] ->
				[(self itemClass environment organization listAtCategoryNamed: self newName)
					collect: [:className |
						RecategorizedEvent
							class: (self itemClass environment at: className)
							recategorizedFrom: self oldName
							to: self newName]].
			[#protocol] ->
				[(self itemClass organization listAtCategoryNamed: self newName)
					collect: [:selector |
						RecategorizedEvent
							selector: selector
							method: (self itemClass compiledMethodAt: selector ifAbsent: [nil])
							protocol: self newName class: self itemClass oldProtocol: self oldName]]}
		otherwise: [#()]
]
