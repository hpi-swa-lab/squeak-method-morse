Extension { #name : #MCAddition }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:03'
}
MCAddition >> asMorseChangeFromProject: oldProject to: newProject [

	^ MorseCodeChange
		from: nil
		to: ((self definition asMorseItemIn: newProject) ifNil: [^ nil])
]
