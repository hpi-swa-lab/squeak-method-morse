Extension { #name : #MCModification }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:18'
}
MCModification >> asMorseChangeFromProject: oldProject to: newProject [

	| new old |
	old := self obsoletion asMorseItemIn: oldProject.
	new := self definition asMorseItemIn: newProject.
	(old isNil and: [new isNil]) ifTrue: [^ nil].
	^ MorseCodeChange
		from: old
		to: new
]
