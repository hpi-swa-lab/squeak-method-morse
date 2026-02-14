Class {
	#name : #MorseRemoteSynchronizationStrategy,
	#superclass : #MorseSynchronizationStrategy,
	#category : #'MethodMorse-Synchronization'
}

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/10/2026 23:24'
}
MorseRemoteSynchronizationStrategy >> attributesForLocalLabel [

	^ {TextEmphasis struckOut}
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 22:45'
}
MorseRemoteSynchronizationStrategy >> attributesForRemoteLabel [

	^ {TextEmphasis underlined}
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:38'
}
MorseRemoteSynchronizationStrategy >> isRemote [

	^ true
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/2/2026 22:39'
}
MorseRemoteSynchronizationStrategy >> itemFor: aDiff [

	^ aDiff remote
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/2/2026 22:39'
}
MorseRemoteSynchronizationStrategy >> localItemFor: aDiff [

	^ self itemFor: aDiff
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/2/2026 22:39'
}
MorseRemoteSynchronizationStrategy >> remoteItemFor: aDiff [

	^ self itemFor: aDiff
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/3/2026 02:53'
}
MorseRemoteSynchronizationStrategy >> shortLabel [

	^ '<-'
]
