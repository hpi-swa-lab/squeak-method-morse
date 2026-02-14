Extension { #name : #ModifiedEvent }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:00'
}
ModifiedEvent >> asOldMorseItemIn: aCodeProject [

	^ self oldItem asMorseItemIn: aCodeProject
]
