Class {
	#name : #MethodMorser,
	#superclass : #Object,
	#instVars : [
		'server',
		'remoteMorser',
		'spaces',
		'projects',
		'autoSynchronizer',
		'lastSyncStamps',
		'currentSyncChanges',
		'strongDependents'
	],
	#category : #MethodMorse
}

{
	#category : #'dependents access',
	#'squeak_changestamp' : 'ct 2/21/2026 00:55'
}
MethodMorser >> addDependent: anObject [

	self flag: #(workaround yaros). "Yaros currently cannot keep weak referenced proxies"
	((thisContext objectClass: anObject) withAllSuperclasses anySatisfy: [:c | c name = #YarosRemoteObject]) ifFalse: [^ super addDependent: anObject].
	
	(self dependents includes: anObject) ifTrue: [^ anObject].
	strongDependents := strongDependents
		ifNil: [{anObject}]
		ifNotNil: [strongDependents copyWith: anObject].
	^ anObject
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/17/2026 00:10'
}
MethodMorser >> addProjects: someProjects [

	| newProjects |
	newProjects := someProjects copyWithoutAll: self projects.
	newProjects ifEmpty: [^ self].
	
	projects addAll: newProjects.
	self changed: #projects.
	
	self isConnected ifTrue:
		[self remoteMorser addProjects: (self remoteProjectsFor: newProjects)].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 23:29'
}
MethodMorser >> addSpace: aSpace [

	^ self spaces add: aSpace
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 1/31/2026 20:37'
}
MethodMorser >> autoSyncEnabled [

	^ self autoSyncOutgoingEnabled or: [self autoSyncIncomingEnabled]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 03:02'
}
MethodMorser >> autoSyncEnabled: aBoolean [

	aBoolean
		ifFalse: [self stopAutoSync]
		ifTrue: [self startAutoSync].
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 1/31/2026 20:38'
}
MethodMorser >> autoSyncIncomingEnabled [

	^ self remoteMorser ifNil: [false] ifNotNil: [:remote | remote autoSyncOutgoingEnabled]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 03:08'
}
MethodMorser >> autoSyncIncomingEnabled: aBoolean [

	aBoolean
		ifFalse: [self stopAutoSyncIncoming]
		ifTrue: [self startAutoSyncIncoming].
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:27'
}
MethodMorser >> autoSyncOutgoingEnabled [

	^ self autoSynchronizer notNil and:
		[self autoSynchronizer isRunning]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 03:08'
}
MethodMorser >> autoSyncOutgoingEnabled: aBoolean [

	aBoolean
		ifFalse: [self stopAutoSyncOutgoing]
		ifTrue: [self startAutoSyncOutgoing].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 19:00'
}
MethodMorser >> autoSynchronizer [

	^ autoSynchronizer
]

{
	#category : #'dependents access',
	#'squeak_changestamp' : 'ct 2/21/2026 00:57'
}
MethodMorser >> breakDependents [

	super breakDependents.
	strongDependents := nil.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 19:14'
}
MethodMorser >> currentSyncChanges: changesOrNil [

	currentSyncChanges := changesOrNil.
	
	self changed: #isSyncInProgress.
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/12/2026 00:18'
}
MethodMorser >> doManualSync [

	| task |
	task := self newSynchronizationTask.
	task isEmpty ifTrue: [^ self inform: 'Everything up to date!'].
	^ task openWith: self
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 02:20'
}
MethodMorser >> hasIncompleteAutoSyncIncoming [

	^ self remoteMorser ifNil: [false] ifNotNil: [:remote | remote hasIncompleteAutoSyncOutgoing]
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:37'
}
MethodMorser >> hasIncompleteAutoSyncOutgoing [

	^ self autoSynchronizer wasIncomplete
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/16/2026 23:25'
}
MethodMorser >> initialize [

	super initialize.
	
	spaces := OrderedCollection new.
	projects := OrderedCollection new.
	autoSynchronizer := MorseAutoSynchronizer newFor: self.
	autoSynchronizer addDependent: self.
	lastSyncStamps := Dictionary new.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/1/2026 20:08'
}
MethodMorser >> isAutoSyncIncomingInProgress [

	^ self remoteMorser ifNil: [false] ifNotNil: [:remote | remote isAutoSyncOutgoingInProgress]
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:43'
}
MethodMorser >> isAutoSyncOutgoingInProgress [

	^ self autoSynchronizer isProcessing
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/22/2026 19:05'
}
MethodMorser >> isConnected [

	^ self server ifNil: [false] ifNotNil: [self server isConnected]
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/22/2026 23:44'
}
MethodMorser >> isConnectedOrPending [

	^ self isConnected or: [self isConnectionPending]
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/22/2026 19:25'
}
MethodMorser >> isConnectionPending [

	^ self server notNil and: [self server isConnectionPending]
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/11/2026 19:14'
}
MethodMorser >> isSyncInProgress [

	^ currentSyncChanges notNil
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:49'
}
MethodMorser >> lastIncomingAutoSyncStamp [

	^ lastSyncStamps at: #autoIncoming ifAbsent: [nil]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:50'
}
MethodMorser >> lastIncomingAutoSyncStamp: aDateAndTime [

	lastSyncStamps at: #autoIncoming put: aDateAndTime.
	self changed: #lastIncomingAutoSyncStamp.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:50'
}
MethodMorser >> lastOutgoingAutoSyncStamp [

	^ lastSyncStamps at: #autoOutgoing ifAbsent: [nil]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:51'
}
MethodMorser >> lastOutgoingAutoSyncStamp: aDateAndTime [

	lastSyncStamps at: #autoOutgoing put: aDateAndTime.
	self changed: #lastOutgoingAutoSyncStamp.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 19:13'
}
MethodMorser >> lastSyncStamp [

	^ lastSyncStamps at: #sync ifAbsent: [nil]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 19:13'
}
MethodMorser >> lastSyncStamp: aDateAndTime [

	lastSyncStamps at: #sync put: aDateAndTime.
	self changed: #lastSyncStamp.
]

{
	#category : #'dependents access',
	#'squeak_changestamp' : 'ct 2/21/2026 00:56'
}
MethodMorser >> myDependents [

	^ strongDependents
		ifNil: [super myDependents]
		ifNotNil: [super myDependents , strongDependents]
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/14/2026 20:02'
}
MethodMorser >> newSynchronizationTask [

	| serializedProjects remoteSerializedProjects remoteProjects serializedPairs changes diffs |
	{[serializedProjects := self serializedProjects].
	[remoteSerializedProjects := self remoteMorser serializedProjects]}
		morseConcurrentCollect: #value.
	remoteProjects := remoteSerializedProjects keys
		collect: [:name | name -> (self remoteMorser projectWithName: name)]
		as: Dictionary.
	serializedPairs := serializedProjects
		with: remoteSerializedProjects
		collect: [:serialized :remoteSerialized | serialized -> remoteSerialized].
	changes := serializedPairs associations gather: [:projectNameAndPair |
		(self projectWithName: projectNameAndPair key)
			compare: projectNameAndPair value key
			with: projectNameAndPair value value
			from: (remoteProjects at: projectNameAndPair key)].
	diffs := changes collect: [:change |
		change asIncomingDiff
			localProject: (self projectWithName: change projectName);
			remoteProject: (remoteProjects at: change projectName);
			tryChooseAutomatically;
			yourself].
	^ MorseSynchronizationTask newWithDiffs:
		(diffs sorted: [:ea | ea isUnresolved] sortedFirst , [:ea | ea name] ascending)
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/22/2026 19:09'
}
MethodMorser >> noteServerConnected [

	self remoteMorser: self server remoteMorser.
	self changed: #isConnected.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/22/2026 19:08'
}
MethodMorser >> noteServerStarted [

	self changed: #isConnectionPending.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/22/2026 19:48'
}
MethodMorser >> noteServerStopped [

	self remoteMorser: nil.
	self changed: #isConnected.
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/1/2026 02:38'
}
MethodMorser >> open [

	^ MethodMorserTool openOn: self
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/2/2026 03:31'
}
MethodMorser >> projectWithName: aString [

	^ self projectWithName: aString ifAbsent: [(KeyNotFound key: aString) signal]
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/13/2026 19:37'
}
MethodMorser >> projectWithName: aString ifAbsent: aBlock [

	self flag: #todo. "discriminate by space name as well? and perhaps rename all lookups to keys."
	^ self projects
		detect: [:project | project name = aString]
		ifNone: [aBlock value]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:06'
}
MethodMorser >> projects [

	^ projects
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/11/2026 18:40'
}
MethodMorser >> release [

	self stopConnection.
	self server: nil.
	self remoteMorser removeDependent: self.
	self autoSynchronizer removeDependent: self.
	
	super release.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 20:38'
}
MethodMorser >> remoteMorser [

	^ remoteMorser
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/22/2026 23:42'
}
MethodMorser >> remoteMorser: aMethodMorser [

	remoteMorser := aMethodMorser.
	self remoteMorser ifNotNil:
		[self remoteMorser addDependent: self].
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/1/2026 02:01'
}
MethodMorser >> remoteProjectFor: aProject [

	^ (self remoteProjectsFor: {aProject}) first
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/14/2026 22:35'
}
MethodMorser >> remoteProjectsFor: projects [

	| groupedProjects mappedSpaces mappedProjects |
	groupedProjects := projects groupBy: #space.
	mappedSpaces := self remoteSpacesFor: groupedProjects keys.
	mappedProjects := Dictionary new.
	mappedSpaces with: groupedProjects values do: [:remoteSpace :group |
		mappedProjects morseAtAll: group putAll:
			(remoteSpace projectsWithAllNames: (group collect: #name))].
	^ mappedProjects morseAtAll: projects
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/16/2026 23:32'
}
MethodMorser >> remoteSpacesFor: spaces [

	^ self remoteMorser spacesWithNames: (spaces collect: #name)
]

{
	#category : #'dependents access',
	#'squeak_changestamp' : 'ct 2/21/2026 00:57'
}
MethodMorser >> removeDependent: anObject [

	self flag: #(workaround yaros). "Yaros currently cannot keep weak referenced proxies"
	((thisContext objectClass: anObject) withAllSuperclasses anySatisfy: [:c | c name = #YarosRemoteObject]) ifFalse: [^ super removeDependent: anObject].
	
	(self dependents includes: anObject) ifFalse: [^ anObject].
	strongDependents ifNotNil:
		[strongDependents := (strongDependents copyWithout: anObject) ifEmpty: [nil]].
	^ anObject
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/17/2026 00:13'
}
MethodMorser >> removeProjects: someProjects [

	| oldProjects |
	oldProjects := someProjects intersection: self projects.
	oldProjects ifEmpty: [^ self].
	
	projects removeAll: oldProjects.
	self changed: #projects.
	
	self isConnected ifTrue:
		[self remoteMorser removeProjects: (self remoteProjectsFor: oldProjects)].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 23:29'
}
MethodMorser >> removeSpace: aSpace [

	^ self spaces remove: aSpace
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 03:28'
}
MethodMorser >> serializedProjects [

	^ self projects
		collect: [:project | project name -> project serialized]
		as: OrderedDictionary
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 21:46'
}
MethodMorser >> server [

	^ server
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/22/2026 19:30'
}
MethodMorser >> server: aMorseServer [

	self server ifNotNil:
		[self server morser: nil.
		self stopConnection.
		self server removeActionsWithReceiver: self].
	
	server := aMorseServer.
	
	self server
		ifNil: [^ self];
		morser: self;
		when: #started send: #noteServerStarted to: self;
		when: #connected send: #noteServerConnected to: self;
		when: #stopped send: #noteServerStopped to: self.
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 2/21/2026 21:21'
}
MethodMorser >> setUpTodoExample [

	| localBook |
	localBook := MorseDemoTodoBook new.
	localBook addListNamed: 'Todo List #1'.
	self addSpace: localBook.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 23:25'
}
MethodMorser >> spaces [

	^ spaces
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 23:25'
}
MethodMorser >> spaces: aCollection [

	spaces := spaces.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 23:33'
}
MethodMorser >> spacesWithNames: names [

	^ names collect: [:name |
		self spaces detect: [:ea | ea name = name]]
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/1/2026 03:03'
}
MethodMorser >> startAutoSync [

	self
		startAutoSyncOutgoing;
		startAutoSyncIncoming.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/1/2026 03:04'
}
MethodMorser >> startAutoSyncIncoming [

	self remoteMorser startAutoSyncOutgoing.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/11/2026 18:59'
}
MethodMorser >> startAutoSyncOutgoing [

	self autoSynchronizer start.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/1/2026 02:40'
}
MethodMorser >> startConnection [

	self server start.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/1/2026 03:03'
}
MethodMorser >> stopAutoSync [

	self
		stopAutoSyncOutgoing;
		stopAutoSyncIncoming.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/2/2026 00:42'
}
MethodMorser >> stopAutoSyncIncoming [

	self remoteMorser ifNotNil: [:remote | remote stopAutoSyncOutgoing].
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/11/2026 18:59'
}
MethodMorser >> stopAutoSyncOutgoing [

	self autoSynchronizer stop.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/23/2026 00:01'
}
MethodMorser >> stopConnection [

	self stopAutoSync.
	self isConnectedOrPending ifFalse: [^ self].
	
	self stopRemoteConnection.
	self stopSingleConnection wait.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/23/2026 00:14'
}
MethodMorser >> stopRemoteConnection [

	self remoteMorser ifNotNil: [:remote |
		remote removeDependent: self.
		self removeDependent: remote.
		remote stopSingleConnection.
		Processor yield.
		[[self remoteMorser] whileNotNil:
			[0.5 seconds wait]]
				valueWithin: 5 seconds onTimeout: []].
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/22/2026 23:45'
}
MethodMorser >> stopSingleConnection [

	| promise |
	promise := Promise new.
	self server
		ifNil: [promise resolve]
		ifNotNil: [:it | [promise fulfillWith: [it stop]] fork].
	^ promise
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/13/2026 23:44'
}
MethodMorser >> tryApplyIncomingChanges: changes forSyncType: type [

	| changeProjects compatibleChanges failedChanges |
	Processor activeProcess morseRootProcess == Project current uiProcess ifFalse:
		[^ (self future tryApplyIncomingChanges: changes forSyncType: type) wait].
	
	changeProjects := changes
		collect: [:change |
			change -> (self projectWithName: change projectName ifAbsent: [nil])]
		as: OrderedDictionary.
	compatibleChanges := changes select: [:change |
		(changeProjects at: change)
			ifNil: [false]
			ifNotNil: [:project |
				change canBeAutoSyncedTo: project]].
	failedChanges := changes copyWithoutAll: compatibleChanges.
	failedChanges := failedChanges ,
		((compatibleChanges groupBy: [:change | changeProjects at: change])
			associations gather: [:projectAndChanges |
				type = #auto
					ifTrue: [projectAndChanges key tryApplyChangesSilently: projectAndChanges value]
					ifFalse:
						[projectAndChanges key applyChanges: projectAndChanges value.
						#()]]).
	
	^ failedChanges
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/13/2026 19:38'
}
MethodMorser >> tryAutoSyncIncomingChanges: changes [

	| failedChanges |
	failedChanges := self tryApplyIncomingChanges: changes forSyncType: #auto.
	self lastIncomingAutoSyncStamp: TimeStamp now.
	^ failedChanges
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/13/2026 19:38'
}
MethodMorser >> tryAutoSyncOutgoingChanges: changes [

	| failedChanges |
	failedChanges := self remoteMorser tryAutoSyncIncomingChanges: changes.
	self lastOutgoingAutoSyncStamp: TimeStamp now.
	^ failedChanges
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/11/2026 17:51'
}
MethodMorser >> trySyncIncomingChanges: changes [

	^ self tryApplyIncomingChanges: changes forSyncType: #manual
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/22/2026 00:59'
}
MethodMorser >> trySyncIncomingChanges: incomingChanges outgoingChanges: outgoingChanges [

	| failedChanges failedIncomingChanges failedRemoteChanges stamp block |
	self currentSyncChanges: {incomingChanges. outgoingChanges}.
	self remoteMorser currentSyncChanges: {incomingChanges. outgoingChanges}.
	block := [[({incomingChanges ifNotEmpty: [:changes |
		[failedIncomingChanges := self trySyncIncomingChanges: changes]].
	outgoingChanges ifNotEmpty: [:changes |
		[failedRemoteChanges := self trySyncOutgoingChanges: changes]]}
		copyWithout: nil)
			morseConcurrentCollect: #value]
				ensure:
					[self currentSyncChanges: nil.
					self remoteMorser currentSyncChanges: nil]].
	Processor activeProcess == Project current uiProcess
		ifTrue:
			[| promise |
			self flag: #(workaround yaros). "#morseRootProcess does not work across remote message sends"
			promise := Promise new.
			[promise fulfillWith: block] fork.
			[promise isSettled] whileFalse:
				[Project current world doOneCycle.
				Processor yield].
			promise value]
		ifFalse: [block value].
	
	failedChanges := (failedIncomingChanges ifNil: [#()])
		, (failedRemoteChanges ifNil: [#()]).
	stamp := TimeStamp now.
	self lastSyncStamp: stamp.
	self remoteMorser lastSyncStamp: stamp.
	
	^ failedChanges
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/11/2026 18:05'
}
MethodMorser >> trySyncOutgoingChanges: changes [

	^ self remoteMorser trySyncIncomingChanges: changes
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/11/2026 18:59'
}
MethodMorser >> update: what [

	"from autoSynchronizer"
	what = #isRunning ifTrue:
		[self changed: #autoSyncOutgoingEnabled].
	what = #currentChanges ifTrue:
		[self changed: #isAutoSyncOutgoingInProgress].
	what = #wasIncomplete ifTrue:
		[self changed: #hasIncompleteAutoSyncOutgoing].
	
	"from remoteMorser"
	what = #autoSyncOutgoingEnabled ifTrue:
		[self changed: #autoSyncIncomingEnabled].
	what = #isAutoSyncOutgoingInProgress ifTrue:
		[self changed: #isAutoSyncIncomingInProgress].
	what = #hasIncompleteAutoSyncOutgoing ifTrue:
		[self changed: #hasIncompleteAutoSyncIncoming].
]
