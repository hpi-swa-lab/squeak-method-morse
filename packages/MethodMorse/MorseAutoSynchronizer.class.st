Class {
	#name : #MorseAutoSynchronizer,
	#superclass : #Object,
	#instVars : [
		'morser',
		'process',
		'pendingChanges',
		'currentChanges',
		'failedKeys'
	],
	#category : #'MethodMorse-Synchronization'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/11/2026 19:27'
}
MorseAutoSynchronizer class >> newFor: aMorser [

	^ self new
		morser: aMorser;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:44'
}
MorseAutoSynchronizer >> currentChanges [

	^ currentChanges
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:42'
}
MorseAutoSynchronizer >> currentChanges: changesOrNil [

	currentChanges := changesOrNil.
	
	self changed: #currentChanges.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:44'
}
MorseAutoSynchronizer >> failedKeys [

	^ failedKeys
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/11/2026 18:29'
}
MorseAutoSynchronizer >> initialize [

	super initialize.
	
	pendingChanges := SharedQueue2 new.
	failedKeys := OrderedCollection new.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:43'
}
MorseAutoSynchronizer >> isProcessing [

	^ self currentChanges notNil
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:28'
}
MorseAutoSynchronizer >> isRunning [

	^ process notNil and:
		[process isTerminated not]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 19:26'
}
MorseAutoSynchronizer >> morser [

	^ morser
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 19:27'
}
MorseAutoSynchronizer >> morser: aMorser [

	morser := aMorser.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/11/2026 18:45'
}
MorseAutoSynchronizer >> noteItemChanges: changes [

	self isRunning ifFalse: [^ self].
	pendingChanges nextPutAll: changes.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 19:26'
}
MorseAutoSynchronizer >> projects [

	^ self morser projects
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/12/2026 01:58'
}
MorseAutoSynchronizer >> resetFailedKeys [

	failedKeys removeAll.
	self changed: #wasIncomplete.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/14/2026 19:09'
}
MorseAutoSynchronizer >> run [

	[pendingChanges morseNextUpToBlocking ifNotEmpty: [:changes |
		self syncChanges: changes].
	Processor yield]
		repeat.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/12/2026 01:58'
}
MorseAutoSynchronizer >> start [

	self stop.
	self resetFailedKeys.
	
	process := [[self run] ifCurtailed: [self stop]]
		forkAt: Processor systemBackgroundPriority.
	self projects do: [:ea |
		ea when: #itemsChanged send: #noteItemChanges: to: self].
	
	self changed: #isRunning.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/11/2026 19:40'
}
MorseAutoSynchronizer >> stop [

	| p |
	self isRunning ifFalse: [^ self].
	
	self projects do: [:ea |
		ea removeActionsWithReceiver: self forEvent: #itemsChanged].
	
	p := process.
	process := nil.
	p terminate.
	
	self changed: #isRunning.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 18:44'
}
MorseAutoSynchronizer >> syncChanges: changes [

	| failedChanges newFailedKeys successfulKeys |
	self currentChanges: changes.
	[failedChanges := self morser tryAutoSyncOutgoingChanges: changes]
		ensure: [self currentChanges: nil].
	
	newFailedKeys := failedChanges collect: [:change | {change projectName. change key}].
	successfulKeys := (changes collect: [:change | {change projectName. change key}])
		copyWithoutAll: newFailedKeys.
	self failedKeys addAll: (newFailedKeys copyWithoutAll: self failedKeys).
	self failedKeys removeAllFoundIn: successfulKeys.
	self changed: #wasIncomplete.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:44'
}
MorseAutoSynchronizer >> wasIncomplete [

	^ self failedKeys notEmpty
]
