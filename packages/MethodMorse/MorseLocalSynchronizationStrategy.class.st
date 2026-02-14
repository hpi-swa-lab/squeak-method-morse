Class {
	#name : #MorseLocalSynchronizationStrategy,
	#superclass : #MorseSynchronizationStrategy,
	#category : #'MethodMorse-Synchronization'
}

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 22:44'
}
MorseLocalSynchronizationStrategy >> attributesForLocalLabel [

	^ {TextEmphasis underlined}
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 22:44'
}
MorseLocalSynchronizationStrategy >> attributesForRemoteLabel [

	^ {TextEmphasis struckOut}
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:38'
}
MorseLocalSynchronizationStrategy >> isLocal [

	^ true
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/2/2026 22:38'
}
MorseLocalSynchronizationStrategy >> itemFor: aDiff [

	^ aDiff local
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/2/2026 22:38'
}
MorseLocalSynchronizationStrategy >> localItemFor: aDiff [

	^ self itemFor: aDiff
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/2/2026 22:39'
}
MorseLocalSynchronizationStrategy >> remoteItemFor: aDiff [

	^ self itemFor: aDiff
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/3/2026 02:53'
}
MorseLocalSynchronizationStrategy >> shortLabel [

	^ '->'
]
