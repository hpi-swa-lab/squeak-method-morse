Extension { #name : #MCPatchOperation }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:03'
}
MCPatchOperation >> asMorseChangeFromProject: oldProject to: newProject [

	^ self subclassResponsibility
]
