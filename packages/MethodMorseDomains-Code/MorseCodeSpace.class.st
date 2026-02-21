Class {
	#name : #MorseCodeSpace,
	#superclass : #MorseSpace,
	#instVars : [
		'environment',
		'name'
	],
	#category : #'MethodMorseDomains-Code'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 1/31/2026 22:01'
}
MorseCodeSpace class >> forEnvironment: anEnvironment [

	^ self new
		environment: anEnvironment;
		yourself
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:32'
}
MorseCodeSpace >> = anObject [

	self == anObject ifTrue: [^ true].
	self class = anObject class ifFalse: [^ false].
	^ self environment = anObject environment
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:01'
}
MorseCodeSpace >> environment [

	^ environment
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:01'
}
MorseCodeSpace >> environment: anEnvironment [

	environment := anEnvironment.
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:39'
}
MorseCodeSpace >> hash [

	^ self class hash hashMultiply bitXor: self environment hash
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/17/2026 00:12'
}
MorseCodeSpace >> name [

	^ name ifNil: [self environment name]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/21/2026 02:33'
}
MorseCodeSpace >> name: aStringOrNil [
	"Debugging convenience, mainly used for testing remote connections by mapping multiple environments in the same image to each other."

	name := aStringOrNil.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/1/2026 01:12'
}
MorseCodeSpace >> packageOrganizer [

	^ self environment info packages
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/1/2026 01:12'
}
MorseCodeSpace >> projectFor: aPackageInfo [

	^ MorseCodeProject forPackage: aPackageInfo inSpace: self
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:13'
}
MorseCodeSpace >> projectNamed: aString [

	^ self projectFor:
		(self packageOrganizer packageNamed: aString ifAbsent: [(KeyNotFound key: aString) signal])
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:28'
}
MorseCodeSpace >> projects [

	^ (self packageOrganizer packages collect: [:package |
		self projectFor: package])
			sorted: #name ascending
]
