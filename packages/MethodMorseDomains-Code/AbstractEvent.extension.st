Extension { #name : #AbstractEvent }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:05'
}
AbstractEvent >> asMorseCategoryChangesInProject: aCodeProject [

	self flag: #forLater. "could we emit separate changes for these to housekeep categories and changesets?"
	^ #()
]

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:05'
}
AbstractEvent >> asMorseChangesInProject: aCodeProject [

	| from to |
	(#(category protocol) includes: self itemKind) ifTrue:
		[^ self asMorseCategoryChangesInProject: aCodeProject].
	
	from := self asOldMorseItemIn: aCodeProject.
	to := self asNewMorseItemIn: aCodeProject.
	from = to ifTrue: [^ #()].
	^ {MorseCodeChange from: from to: to event: self}
]

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 18:59'
}
AbstractEvent >> asMorseItemIn: aCodeProject [

	^ self item asMorseItemIn: aCodeProject
]

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:06'
}
AbstractEvent >> asNewMorseItemIn: aCodeProject [

	^ self asMorseItemIn: aCodeProject
]

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:11'
}
AbstractEvent >> asOldMorseItemIn: aCodeProject [

	^ nil
]
