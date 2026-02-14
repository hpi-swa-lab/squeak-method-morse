Class {
	#name : #MorseNullSynchronizationStrategy,
	#superclass : #MorseSynchronizationStrategy,
	#category : #'MethodMorse-Synchronization'
}

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:36'
}
MorseNullSynchronizationStrategy >> isResolved [

	^ false
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/9/2026 22:38'
}
MorseNullSynchronizationStrategy >> itemFor: aDiff [

	^ #divergent
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/9/2026 22:37'
}
MorseNullSynchronizationStrategy >> localItemFor: aDiff [

	^ aDiff local
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/9/2026 22:37'
}
MorseNullSynchronizationStrategy >> remoteItemFor: aDiff [

	^ aDiff remote
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/9/2026 22:35'
}
MorseNullSynchronizationStrategy >> shortLabel [

	^ '(...)'
]
