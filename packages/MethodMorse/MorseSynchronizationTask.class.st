Class {
	#name : #MorseSynchronizationTask,
	#superclass : #Object,
	#instVars : [
		'diffs'
	],
	#category : #'MethodMorse-Synchronization'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/2/2026 03:41'
}
MorseSynchronizationTask class >> newWithDiffs: diffs [

	^ self new
		diffs: diffs;
		yourself
]

{
	#category : #applying,
	#'squeak_changestamp' : 'ct 2/11/2026 19:42'
}
MorseSynchronizationTask >> applyWith: aMorser [

	| relevantDiffs localChanges remoteChanges failedChanges |
	relevantDiffs := self diffs reject: #isIgnored.
	localChanges := (relevantDiffs collect: [:ea | ea localChange]) reject: #isIdentical.
	remoteChanges := (relevantDiffs collect: [:ea | ea remoteChange]) reject: #isIdentical.
	
	failedChanges := aMorser
		trySyncIncomingChanges: localChanges
		outgoingChanges: remoteChanges.
	
	failedChanges ifNotEmpty:
		[(self confirm: 'Some changes could not be applied. Do manual sync again?') ifTrue:
			[aMorser doManualSync]].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 03:45'
}
MorseSynchronizationTask >> diffs [

	^ diffs
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 03:45'
}
MorseSynchronizationTask >> diffs: aSequenceableCollection [

	diffs := aSequenceableCollection.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/12/2026 00:17'
}
MorseSynchronizationTask >> isEmpty [

	^ self diffs isEmpty
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/11/2026 17:21'
}
MorseSynchronizationTask >> openWith: aMorser [

	^ MorseSynchronizationTool openOn: self withMorser: aMorser
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/10/2026 23:28'
}
MorseSynchronizationTask >> unresolvedDiffs [

	^ self diffs select: #isUnresolved
]
