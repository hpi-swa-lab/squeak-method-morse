Class {
	#name : #MorseCodeProject,
	#superclass : #MorseProject,
	#instVars : [
		'package',
		'space'
	],
	#category : #'MethodMorseDomains-Code'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/1/2026 00:54'
}
MorseCodeProject class >> forPackage: aPackageInfo inSpace: aSpace [

	^ self new
		package: aPackageInfo;
		space: aSpace;
		yourself
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:50'
}
MorseCodeProject >> = anObject [

	self == anObject ifTrue: [^ true].
	self class = anObject class ifFalse: [^ false].
	^ self package = anObject package
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/1/2026 23:02'
}
MorseCodeProject >> actionMapChanged [
	"Optimization. We could also just watch always and send out changes into the void."

	self stopWatching.
	(self actionSequenceForEvent: #itemsChanged) ifNotEmpty:
		[self startWatching].
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/11/2026 17:50'
}
MorseCodeProject >> applyChanges: changes [

	^ self applyChanges: changes silently: false
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/21/2026 02:32'
}
MorseCodeProject >> applyChanges: changes silently: aBoolean [

	| loader patch applyBlock |
	patch := MCPatch operations:
		(changes gather: [:change |
			change asMCOperationsIn: self environment]).
	
	self flag: #yaros. "This is due to two reasons: (i) optimization - localize all operations + definitions with one network send; (ii) install changes in right environment - Yaros currently does not transmit exceptions for Environment>>beCurrentDuring:, and avoid storing remote CompiledMethods in the target class."
	patch := self makeLocalPatchFrom: patch.
	
	loader := MCPackageLoader new.
	patch applyTo: loader.
	
	applyBlock :=
		[self environment beCurrentDuring:
			[self disableWatchingDuring:
				[loader loadWithName: self changeSetNameForSync]]].
	aBoolean
		ifFalse:
			[applyBlock value.
			^ self]
		ifTrue:
			[| failedChanges |
			failedChanges := OrderedCollection new.
			applyBlock
				on: ProgressInitiationException do: [:ex |
					ex rearmHandlerDuring:
						[ex resumeSuppressingProgress]]
				on: Warning do: [:ex |
					ex messageText = loader dependencyWarning ifTrue:
						[failedChanges addAll: loader morseUnloadableDefinitions.
						ex resume].
					ex messageText = loader errorDefinitionWarning ifTrue:
						[failedChanges addAll: loader morseErrorDefinitions.
						ex resume].
					ex pass].
			^ failedChanges withoutDuplicates]
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/21/2026 02:09'
}
MorseCodeProject >> browse: aProject [

	| browserClass |
	self flag: #moveUpstream.
	browserClass := SystemBrowser default.
	(browserClass canUnderstand: #selectPackageNamed:) ifFalse:
		[browserClass := PackagePaneBrowser].
	^ browserClass new
		selectEnvironment: aProject environment;
		selectPackageNamed: aProject package name;
		buildAndOpenFullBrowser
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/13/2026 20:07'
}
MorseCodeProject >> changeSetNameForSync [

	^ 'synchronized'
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/1/2026 05:09'
}
MorseCodeProject >> classNamed: aSymbol [

	^ self environment beCurrentDuring:
		[self package classes
			detect: [:ea | ea name = aSymbol]
			ifNone: [nil]]
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/13/2026 19:02'
}
MorseCodeProject >> compare: localSnapshot with: remoteSnapshot from: remoteProject [

	^ ((remoteSnapshot patchRelativeToBase: localSnapshot) operations
		collect: [:operation |
			operation asMorseChangeFromProject: self to: remoteProject])
				copyWithout: nil
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/2/2026 01:07'
}
MorseCodeProject >> disableWatchingDuring: aBlock [

	| wasDisabled |
	wasDisabled := Processor activeProcess
		environmentAt: #morseSystemEventsDisabled
		ifAbsent: [nil].
	Processor activeProcess
		environmentAt: #morseSystemEventsDisabled
		put: thisContext.
	^ aBlock ensure:
		[wasDisabled
			ifNotNil:
				[Processor activeProcess
					environmentAt: #morseSystemEventsDisabled
					put: wasDisabled]
			ifNil:
				[Processor activeProcess environmentRemoveKey: #morseSystemEventsDisabled]]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 02:02'
}
MorseCodeProject >> environment [

	^ self space environment
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:50'
}
MorseCodeProject >> hash [

	^ self class hash hashMultiply bitXor: self package hash
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/2/2026 01:05'
}
MorseCodeProject >> isWatchingDisabled [

	^ (Processor activeProcess environmentAt: #morseSystemEventsDisabled ifAbsent: [nil])
		notNil
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/13/2026 19:01'
}
MorseCodeProject >> itemAt: key ifAbsent: absentBlock [

	| class classAndSelector |
	key isSymbol ifTrue:
		[^ (self classNamed: key)
			ifNil: [absentBlock value]
			ifNotNil: [:ea | ea asMorseItemIn: self]].
	
	classAndSelector := key splitBy: '>>'.
	class := (self classNamed: classAndSelector first) ifNil: [^ absentBlock value].
	^ (class compiledMethodAt: classAndSelector second asSymbol ifAbsent: [^ absentBlock value])
		asMorseItemIn: self
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/13/2026 19:01'
}
MorseCodeProject >> items [

	^ CurrentReadOnlySourceFiles cacheDuring:
		[(self environment beCurrentDuring:
			[self package classes , self package methods])
				collect: [:ea | ea asMorseItemIn: self]]
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/17/2026 01:36'
}
MorseCodeProject >> makeLocalPatchFrom: aMCPatch [

	| serialized |
	serialized := aMCPatch morseSerialized.
	^ MCPatch morseDeserialize: serialized
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:03'
}
MorseCodeProject >> name [

	^ self package name
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/11/2026 17:07'
}
MorseCodeProject >> newChangeFrom: oldItem to: newItem [

	^ MorseCodeChange from: oldItem to: newItem
]

{
	#category : #'*MethodMorseDomains-Code-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 18:29'
}
MorseCodeProject >> newItemContentModel [

	^ MorseCodeItemHolder new
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/13/2026 19:04'
}
MorseCodeProject >> noteSystemEvent: anEvent [

	| changes |
	anEvent itemClass ifNil: [^ self].
	anEvent itemClass environment = self environment ifFalse: [^ self].
	anEvent itemClass packageInfo = self package ifFalse: [^ self].
	
	self isWatchingDisabled ifTrue: [^ self].
	
	changes := (anEvent asMorseChangesInProject: self) ifEmpty: [^ self].
	self triggerEvent: #itemsChanged with: changes.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:03'
}
MorseCodeProject >> package [

	^ package
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:03'
}
MorseCodeProject >> package: aPackageInfo [

	package := aPackageInfo.
]

{
	#category : #printing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:21'
}
MorseCodeProject >> printOn: aStream [

	aStream nextPutAll:
		((String streamContents: [:stream |
			super printOn: stream])
				readStream upTo: $().
	aStream nextPut: $(.
	self space environment = Smalltalk environment ifFalse:
		[aStream
			nextPutAll: self space name;
			nextPut: $:].
	aStream
		nextPutAll: self name;
		nextPut: $).
]

{
	#category : #'System-Object Events-accessing-removing',
	#'squeak_changestamp' : 'ct 2/1/2026 03:37'
}
MorseCodeProject >> releaseActionMap [

	super releaseActionMap.
	self actionMapChanged.
]

{
	#category : #'System-Object Events-accessing-removing',
	#'squeak_changestamp' : 'ct 2/1/2026 03:38'
}
MorseCodeProject >> removeActionsForEvent: anEventSelector [

	super removeActionsForEvent: anEventSelector.
	self actionMapChanged.
]

{
	#category : #converting,
	#'squeak_changestamp' : 'ct 2/2/2026 03:34'
}
MorseCodeProject >> serialized [

	^ self environment beCurrentDuring:
		[self package mcPackage snapshot]
]

{
	#category : #'System-Object Events-accessing',
	#'squeak_changestamp' : 'ct 2/1/2026 03:38'
}
MorseCodeProject >> setActionSequence: actionSequence forEvent: anEventSelector [

	super setActionSequence: actionSequence forEvent: anEventSelector.
	self actionMapChanged.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 00:54'
}
MorseCodeProject >> space [

	^ space
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 00:54'
}
MorseCodeProject >> space: aSpace [

	space := aSpace.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/1/2026 04:10'
}
MorseCodeProject >> startWatching [

	self stopWatching.
	SystemChangeNotifier uniqueInstance notify: self ofAllSystemChangesUsing: #noteSystemEvent:.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/1/2026 03:41'
}
MorseCodeProject >> stopWatching [

	SystemChangeNotifier uniqueInstance noMoreNotificationsFor: self.
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/11/2026 17:42'
}
MorseCodeProject >> tryApplyChangesSilently: changes [

	^ self applyChanges: changes silently: true
]
