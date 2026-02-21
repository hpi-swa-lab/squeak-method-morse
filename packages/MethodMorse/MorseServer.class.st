Class {
	#name : #MorseServer,
	#superclass : #Object,
	#instVars : [
		'morser'
	],
	#category : #MethodMorse
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 20:16'
}
MorseServer class >> allConnectionSpecs [

	^ (self withAllSubclasses
		reject: #isAbstract)
			sortedSafely collect: #connectionSpec
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/21/2026 22:38'
}
MorseServer class >> connectionSpec [

	^ self subclassResponsibility
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/14/2026 19:32'
}
MorseServer class >> editConnection [

	| spec |
	spec := Project uiManager request: 'edit connection' initialAnswer: self defaultConnectionSpec.
	spec isEmptyOrNil ifTrue: [^ nil].
	^ Compiler evaluate: spec
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/14/2026 19:33'
}
MorseServer class >> isAbstract [

	^ self class = thisContext methodClass
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/1/2026 01:53'
}
MorseServer >> connectionLabel [

	^ self subclassResponsibility
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/1/2026 01:53'
}
MorseServer >> connectionSpec [

	^ self
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 1/31/2026 22:52'
}
MorseServer >> connectionType [

	^ self subclassResponsibility
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 1/31/2026 22:49'
}
MorseServer >> editConnection [

	^ self inspect
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/1/2026 00:28'
}
MorseServer >> isRunning [

	^ self subclassResponsibility
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 21:07'
}
MorseServer >> morser [

	^ morser
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 21:07'
}
MorseServer >> morser: aMethodMorser [

	morser := aMethodMorser.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 00:26'
}
MorseServer >> remoteMorser [

	^ self subclassResponsibility
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 1/31/2026 22:52'
}
MorseServer >> start [

	^ self subclassResponsibility
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 1/31/2026 22:52'
}
MorseServer >> stop [

	^ self subclassResponsibility
]
