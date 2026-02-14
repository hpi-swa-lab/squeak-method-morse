Class {
	#name : #MorseDiff,
	#superclass : #Object,
	#instVars : [
		'local',
		'remote',
		'strategy',
		'localProject',
		'remoteProject'
	],
	#category : #'MethodMorse-Model'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/2/2026 03:45'
}
MorseDiff class >> local: localOrNil remote: remoteOrNil [

	^ self new
		local: localOrNil;
		remote: remoteOrNil;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 04:32'
}
MorseDiff >> anyItem [

	^ self local ifNil: [self remote]
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/11/2026 21:40'
}
MorseDiff >> automaticStrategy [

	self flag: #todo. "detect voluntary removals?"
	self remote ifNil: [^ MorseSynchronizationStrategy newLocal].
	self local ifNil: [^ MorseSynchronizationStrategy newRemote].
	
	(self local ancestorVersionKeys includes: self remote versionKey) ifTrue: [^ MorseSynchronizationStrategy newLocal].
	(self remote ancestorVersionKeys includes: self local versionKey) ifTrue: [^ MorseSynchronizationStrategy newRemote].
	^ nil
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/2/2026 22:18'
}
MorseDiff >> chooseLocal [

	self strategy: MorseSynchronizationStrategy newLocal.
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/11/2026 21:48'
}
MorseDiff >> chooseNewer [

	self strategy: (self newerStrategy ifNil: [^ self unresolve]).
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/2/2026 22:37'
}
MorseDiff >> chooseRemote [

	self strategy: MorseSynchronizationStrategy newRemote.
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/9/2026 18:29'
}
MorseDiff >> edit: newItem [

	self strategy: (MorseSynchronizationStrategy newEdit: newItem).
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/9/2026 18:34'
}
MorseDiff >> editLocal: newItem [

	self strategy:
		(MorseSynchronizationStrategy
			newEditLocal: newItem
			remote: self newRemote).
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/9/2026 18:48'
}
MorseDiff >> editRemote: newItem [

	self strategy:
		(MorseSynchronizationStrategy
			newEditLocal: self newLocal
			remote: newItem).
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/10/2026 00:20'
}
MorseDiff >> ignore [

	self strategy: self strategy ignored.
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/9/2026 22:34'
}
MorseDiff >> initialize [

	super initialize.
	self unresolve.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:38'
}
MorseDiff >> isEdit [

	^ self strategy isEdit
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:38'
}
MorseDiff >> isEditForLocal [

	^ self strategy isEdit and: [self newLocal ~= self local]
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:38'
}
MorseDiff >> isEditForRemote [

	^ self strategy isEdit and: [self newRemote ~= self remote]
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/10/2026 00:18'
}
MorseDiff >> isIgnored [

	^ self strategy isIgnore
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/10/2026 00:19'
}
MorseDiff >> isIgnored: aBoolean [

	aBoolean
		ifTrue: [self ignore]
		ifFalse: [self unignore].
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:35'
}
MorseDiff >> isResolved [

	^ self strategy isResolved
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:36'
}
MorseDiff >> isUnresolved [

	^ self strategy isUnresolved
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 03:45'
}
MorseDiff >> local [

	^ local
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 03:45'
}
MorseDiff >> local: anItemOrNil [

	local := anItemOrNil.
]

{
	#category : #applying,
	#'squeak_changestamp' : 'ct 2/11/2026 17:07'
}
MorseDiff >> localChange [

	^ self localProject newChangeFrom: self local to: self newLocal
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:07'
}
MorseDiff >> localProject [

	^ localProject
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:07'
}
MorseDiff >> localProject: aProject [

	localProject := aProject.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 04:32'
}
MorseDiff >> name [

	^ self anyItem key
]

{
	#category : #'accessing - resolution',
	#'squeak_changestamp' : 'ct 2/9/2026 22:39'
}
MorseDiff >> newItem [

	^ self strategy itemFor: self
]

{
	#category : #'accessing - resolution',
	#'squeak_changestamp' : 'ct 2/9/2026 22:39'
}
MorseDiff >> newLocal [

	^ self strategy localItemFor: self
]

{
	#category : #'accessing - resolution',
	#'squeak_changestamp' : 'ct 2/9/2026 22:39'
}
MorseDiff >> newRemote [

	^ self strategy remoteItemFor: self
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/11/2026 21:49'
}
MorseDiff >> newerStrategy [

	self remote ifNil: [^ MorseSynchronizationStrategy newLocal].
	self local ifNil: [^ MorseSynchronizationStrategy newRemote].
	([self local parsedTimeStamp] ifError: [^ nil]) <=> ([self remote parsedTimeStamp] ifError: [^ nil]) in: [:cmp |
		cmp strictlyPositive ifTrue: [^ MorseSynchronizationStrategy newLocal].
		cmp negative ifTrue: [^ MorseSynchronizationStrategy newRemote]].
	^ nil
]

{
	#category : #'accessing - resolution',
	#'squeak_changestamp' : 'ct 2/10/2026 21:55'
}
MorseDiff >> oldItem [

	self local = self newItem ifTrue: [^ self remote].
	self remote = self newItem ifTrue: [^ self local].
	^ #divergent
]

{
	#category : #printing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:07'
}
MorseDiff >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' for ';
		nextPutAll: self name.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:07'
}
MorseDiff >> project [

	^ self localProject
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 03:45'
}
MorseDiff >> remote [

	^ remote
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 03:45'
}
MorseDiff >> remote: anItemOrNil [

	remote := anItemOrNil.
]

{
	#category : #applying,
	#'squeak_changestamp' : 'ct 2/11/2026 17:07'
}
MorseDiff >> remoteChange [

	^ self remoteProject newChangeFrom: self remote to: self newRemote
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:07'
}
MorseDiff >> remoteProject [

	^ remoteProject
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:07'
}
MorseDiff >> remoteProject: aProject [

	remoteProject := aProject.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 04:19'
}
MorseDiff >> strategy [

	^ strategy
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 22:19'
}
MorseDiff >> strategy: aSynchronizationStrategy [

	strategy := aSynchronizationStrategy.
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/2/2026 23:20'
}
MorseDiff >> tryChooseAutomatically [

	self automaticStrategy ifNotNil: [:strat |
		self strategy: strat].
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/10/2026 00:20'
}
MorseDiff >> unignore [

	self strategy: self strategy unignored.
]

{
	#category : #strategies,
	#'squeak_changestamp' : 'ct 2/9/2026 22:34'
}
MorseDiff >> unresolve [

	self strategy: MorseSynchronizationStrategy newNull.
]
