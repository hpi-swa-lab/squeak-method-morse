Extension { #name : #RecategorizedEvent }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:01'
}
RecategorizedEvent >> asOldMorseItemIn: aCodeProject [

	| morseItem |
	morseItem := self asMorseItemIn: aCodeProject.
	morseItem definition:
		(morseItem definition morseWithCategory: self oldCategory).
	^ morseItem
]
