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
	#'squeak_changestamp' : 'ct 2/13/2026 19:01'
}
RemovedEvent >> asOldMorseItemIn: aCodeProject [

	^ self asMorseItemIn: aCodeProject
]
