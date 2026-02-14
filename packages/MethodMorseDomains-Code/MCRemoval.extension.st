Extension { #name : #MCRemoval }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:03'
}
MCRemoval >> asMorseChangeFromProject: oldProject to: newProject [

	^ MorseCodeChange
		from: ((self definition asMorseItemIn: oldProject) ifNil: [^ nil])
		to: nil
]
