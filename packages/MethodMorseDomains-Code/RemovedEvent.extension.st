Extension { #name : #RemovedEvent }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:06'
}
RemovedEvent >> asNewMorseItemIn: aCodeProject [

	^ nil
]

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/15/2026 00:45'
}
RemovedEvent >> asOldMorseItemIn: aCodeProject [

	| morseItem |
	morseItem := self asMorseItemIn: aCodeProject.
	self itemKind = #method ifTrue:
		[morseItem := (morseItem definition morseWithCategory: self itemProtocol) asMorseItemIn: aCodeProject].
	^ morseItem
]
