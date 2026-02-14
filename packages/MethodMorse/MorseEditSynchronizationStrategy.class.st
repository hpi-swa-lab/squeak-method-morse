Class {
	#name : #MorseEditSynchronizationStrategy,
	#superclass : #MorseSynchronizationStrategy,
	#instVars : [
		'newLocal',
		'newRemote'
	],
	#category : #'MethodMorse-Synchronization'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/9/2026 18:30'
}
MorseEditSynchronizationStrategy class >> newEdit: newItem [

	^ self new edit: newItem
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/9/2026 18:36'
}
MorseEditSynchronizationStrategy class >> newEditLocal: newLocalItem remote: newRemoteItem [

	^ self new
		newLocal: newLocalItem;
		newRemote: newRemoteItem;
		yourself
]

{
	#category : #editing,
	#'squeak_changestamp' : 'ct 2/9/2026 18:30'
}
MorseEditSynchronizationStrategy >> edit: newItem [

	self newLocal: newItem.
	self newRemote: newItem.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 18:50'
}
MorseEditSynchronizationStrategy >> isEdit [

	^ true
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/9/2026 22:09'
}
MorseEditSynchronizationStrategy >> itemFor: aDiff [

	^ self newLocal = self newRemote
		ifTrue: [self newLocal]
		ifFalse: [#divergent]
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/9/2026 18:45'
}
MorseEditSynchronizationStrategy >> localItemFor: aDiff [

	^ self newLocal
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 18:30'
}
MorseEditSynchronizationStrategy >> newLocal [

	^ newLocal
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 18:30'
}
MorseEditSynchronizationStrategy >> newLocal: anItem [

	newLocal := anItem.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 18:31'
}
MorseEditSynchronizationStrategy >> newRemote [

	^ newRemote
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 18:31'
}
MorseEditSynchronizationStrategy >> newRemote: anItem [

	newRemote := anItem.
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/9/2026 18:45'
}
MorseEditSynchronizationStrategy >> remoteItemFor: aDiff [

	^ self newRemote
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/9/2026 18:44'
}
MorseEditSynchronizationStrategy >> shortLabel [

	^ '|'
]
