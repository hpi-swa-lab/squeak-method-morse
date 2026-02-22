Extension { #name : #MCTraitDefinition }

{
	#category : #'*MethodMorseDomains-Code-comparing-override',
	#'squeak_changestamp' : 'ct 2/22/2026 01:01'
}
MCTraitDefinition >> = aDefinition [
	self flag: #traits. "Ugly we harcoded the super superclass method.  We will have to refactor the definition hierarchy"
	
	^ ("aDefinition isKindOf: MCDefinition"(Smalltalk classNamed: (aDefinition perform: #class) name) includesBehavior: MCDefinition)
		and: [(self isRevisionOf: aDefinition)
		and: [self traitCompositionString = aDefinition traitCompositionString
		and: [category = aDefinition category
		and: [comment = aDefinition comment]]]]
]
