Class {
	#name : #MorseSynchronizationStrategy,
	#superclass : #Object,
	#category : #'MethodMorse-Synchronization'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/9/2026 18:30'
}
MorseSynchronizationStrategy class >> newEdit: newItem [

	^ MorseEditSynchronizationStrategy newEdit: newItem
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/9/2026 18:35'
}
MorseSynchronizationStrategy class >> newEditLocal: newLocalItem remote: newRemoteItem [

	^ MorseEditSynchronizationStrategy newEditLocal: newLocalItem remote: newRemoteItem
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/10/2026 00:20'
}
MorseSynchronizationStrategy class >> newIgnore: aSynchronizationStrategy [

	^ MorseIgnoreSynchronizationStrategy newIgnore: aSynchronizationStrategy
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/2/2026 22:18'
}
MorseSynchronizationStrategy class >> newLocal [

	^ MorseLocalSynchronizationStrategy new
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/9/2026 22:34'
}
MorseSynchronizationStrategy class >> newNull [

	^ MorseNullSynchronizationStrategy new
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/2/2026 22:37'
}
MorseSynchronizationStrategy class >> newRemote [

	^ MorseRemoteSynchronizationStrategy new
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 22:44'
}
MorseSynchronizationStrategy >> attributesForLocalLabel [

	^ #()
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 22:44'
}
MorseSynchronizationStrategy >> attributesForRemoteLabel [

	^ #()
]

{
	#category : #converting,
	#'squeak_changestamp' : 'ct 2/10/2026 00:20'
}
MorseSynchronizationStrategy >> ignored [

	^ self class newIgnore: self
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:38'
}
MorseSynchronizationStrategy >> isEdit [

	^ false
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/10/2026 00:19'
}
MorseSynchronizationStrategy >> isIgnore [

	^ false
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:37'
}
MorseSynchronizationStrategy >> isLocal [

	^ false
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:38'
}
MorseSynchronizationStrategy >> isRemote [

	^ false
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:36'
}
MorseSynchronizationStrategy >> isResolved [

	^ true
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:36'
}
MorseSynchronizationStrategy >> isUnresolved [

	^ self isResolved not
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/10/2026 21:41'
}
MorseSynchronizationStrategy >> itemFor: aDiff [

	^ self subclassResponsibility
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/2/2026 22:20'
}
MorseSynchronizationStrategy >> localItemFor: aDiff [

	^ self subclassResponsibility
]

{
	#category : #selecting,
	#'squeak_changestamp' : 'ct 2/2/2026 22:39'
}
MorseSynchronizationStrategy >> remoteItemFor: aDiff [

	^ self subclassResponsibility
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/10/2026 21:41'
}
MorseSynchronizationStrategy >> shortLabel [

	^ self subclassResponsibility
]

{
	#category : #converting,
	#'squeak_changestamp' : 'ct 2/10/2026 00:22'
}
MorseSynchronizationStrategy >> unignored [

	^ self
]
