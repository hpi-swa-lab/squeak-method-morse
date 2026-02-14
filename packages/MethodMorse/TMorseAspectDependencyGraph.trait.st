Trait {
	#name : #TMorseAspectDependencyGraph,
	#category : #'MethodMorse-UI'
}

{
	#category : #'updating - private',
	#'squeak_changestamp' : 'ct 12/22/2024 01:09'
}
TMorseAspectDependencyGraph >> allAspectDependencies [

	^ self pragmaAspectDependencies , self aspectDependencies
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 12/22/2024 01:00'
}
TMorseAspectDependencyGraph >> aspectDependencies [

	^ Dictionary new
		"Model"
		at: #windowTitle put: #(#labelString);
		yourself
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/8/2022 14:49'
}
TMorseAspectDependencyGraph >> changed: aspect [

	super changed: aspect.
	
	(self dependentAspectsOn: aspect)
		do: [:dependentAspect | self changedDependent: dependentAspect].
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/8/2022 14:49'
}
TMorseAspectDependencyGraph >> changedDependent: aspect [
	"Hook for implementors to clear caches."
	
	self changed: aspect.
]

{
	#category : #'updating - private',
	#'squeak_changestamp' : 'ct 12/22/2024 01:15'
}
TMorseAspectDependencyGraph >> dependentAspectsOn: aspect [

	self flag: #todo. "Detect cyclic dependencies!"
	^ self allAspectDependencies associations
		select: [:assoc |
			assoc value isString ifTrue: [
				self notify: 'You probably missed an array here!' "aid for stupid devs"].
			assoc value includes: aspect]
		thenCollect: [:assoc | assoc key]
]

{
	#category : #'updating - private',
	#'squeak_changestamp' : 'ct 12/22/2024 01:09'
}
TMorseAspectDependencyGraph >> pragmaAspectDependencies [

	^ (Pragma allNamed: #uses: from: self class to: thisContext methodClass)
		collect: [:pragma |
			| uses |
			uses := pragma argumentAt: 1.
			uses isSymbol ifTrue: [uses := {uses}].
			pragma selector -> uses]
		as: Dictionary
]
