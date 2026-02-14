Class {
	#name : #MorseChange,
	#superclass : #Object,
	#instVars : [
		'oldItem',
		'newItem'
	],
	#category : #'MethodMorse-Model'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/1/2026 03:55'
}
MorseChange class >> from: oldItem to: newItem [

	^ self new
		oldItem: oldItem;
		newItem: newItem;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:07'
}
MorseChange >> anyItem [

	^ self newItem ifNil: [self oldItem]
]

{
	#category : #converting,
	#'squeak_changestamp' : 'ct 2/2/2026 03:44'
}
MorseChange >> asIncomingDiff [

	^ MorseDiff
		local: self oldItem
		remote: self newItem
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/1/2026 04:31'
}
MorseChange >> canBeAutoSyncedTo: aProject [

	^ self oldItem = (self currentItemIn: aProject)
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 21:33'
}
MorseChange >> currentItemIn: aProject [

	^ aProject itemAt: self key ifAbsent:
		[(self newItem notNil and: [self oldItem notNil] and: [self newItem name ~= self oldItem name])
			ifTrue: [aProject itemAt: self oldItem name ifAbsent: [nil]]
			ifFalse: [nil]]
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/11/2026 17:49'
}
MorseChange >> isIdentical [

	^ self oldItem = self newItem
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:54'
}
MorseChange >> key [

	^ self anyItem key
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:07'
}
MorseChange >> name [

	^ self anyItem name
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 03:55'
}
MorseChange >> newItem [

	^ newItem
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 03:55'
}
MorseChange >> newItem: anItem [

	newItem := anItem.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 03:55'
}
MorseChange >> oldItem [

	^ oldItem
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 03:55'
}
MorseChange >> oldItem: anItem [

	oldItem := anItem.
]

{
	#category : #printing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:07'
}
MorseChange >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' for ';
		nextPutAll: self name.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:33'
}
MorseChange >> projectName [

	^ self anyItem projectName
]
