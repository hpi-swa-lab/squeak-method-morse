Class {
	#name : #MorseIgnoreSynchronizationStrategy,
	#superclass : #MorseSynchronizationStrategy,
	#instVars : [
		'ignoredStrategy'
	],
	#category : #'MethodMorse-Synchronization'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/10/2026 00:21'
}
MorseIgnoreSynchronizationStrategy class >> newIgnore: aSynchronizationStrategy [

	^ self new
		ignoredStrategy: aSynchronizationStrategy;
		yourself
]

{
	#category : #converting,
	#'squeak_changestamp' : 'ct 2/10/2026 00:22'
}
MorseIgnoreSynchronizationStrategy >> ignored [

	^ self
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/10/2026 00:21'
}
MorseIgnoreSynchronizationStrategy >> ignoredStrategy [

	^ ignoredStrategy
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/10/2026 00:21'
}
MorseIgnoreSynchronizationStrategy >> ignoredStrategy: aSynchronizationStrategy [

	ignoredStrategy := aSynchronizationStrategy.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/10/2026 00:33'
}
MorseIgnoreSynchronizationStrategy >> isEdit [

	^ self ignoredStrategy isEdit
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/10/2026 00:19'
}
MorseIgnoreSynchronizationStrategy >> isIgnore [

	^ true
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/10/2026 00:33'
}
MorseIgnoreSynchronizationStrategy >> isLocal [

	^ self ignoredStrategy isLocal
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/10/2026 00:33'
}
MorseIgnoreSynchronizationStrategy >> isRemote [

	^ self ignoredStrategy isRemote
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/10/2026 00:31'
}
MorseIgnoreSynchronizationStrategy >> itemFor: aDiff [

	^ self ignoredStrategy itemFor: aDiff
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/10/2026 00:32'
}
MorseIgnoreSynchronizationStrategy >> localItemFor: aDiff [

	^ self ignoredStrategy localItemFor: aDiff
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/10/2026 00:32'
}
MorseIgnoreSynchronizationStrategy >> remoteItemFor: aDiff [

	^ self ignoredStrategy remoteItemFor: aDiff
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/10/2026 00:21'
}
MorseIgnoreSynchronizationStrategy >> shortLabel [

	^ self ignoredStrategy shortLabel
]

{
	#category : #converting,
	#'squeak_changestamp' : 'ct 2/10/2026 00:22'
}
MorseIgnoreSynchronizationStrategy >> unignored [

	^ self ignoredStrategy
]
