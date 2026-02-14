Class {
	#name : #MorseSpace,
	#superclass : #Object,
	#category : #'MethodMorse-Model'
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:37'
}
MorseSpace >> name [

	self flag: #subclassResponsibility.
	^ String streamContents: [:s | super printOn: s]
]

{
	#category : #printing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:05'
}
MorseSpace >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:49'
}
MorseSpace >> projectNamed: aString [

	^ self projects detect: [:ea | ea name = aString]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 03:51'
}
MorseSpace >> projects [

	^ self subclassResponsibility
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:10'
}
MorseSpace >> projectsWithAllNames: names [

	^ names collect: [:name |
		self projectNamed: name]
]
