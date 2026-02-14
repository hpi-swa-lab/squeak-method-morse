Class {
	#name : #MorseLocalServer,
	#superclass : #MorseServer,
	#instVars : [
		'isRunning',
		'remoteMorser',
		'remoteSpaces'
	],
	#category : #MethodMorse
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/14/2026 19:30'
}
MorseLocalServer class >> connectionSpec [

	^ self new
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/1/2026 00:24'
}
MorseLocalServer >> connectionLabel [

	^ #local
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 1/31/2026 22:52'
}
MorseLocalServer >> connectionType [

	^ #local
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/1/2026 01:02'
}
MorseLocalServer >> initialize [

	super initialize.
	
	self remoteSpaces: Dictionary new.
	isRunning := false.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/1/2026 00:29'
}
MorseLocalServer >> isRunning [

	^ isRunning
]

{
	#category : #support,
	#'squeak_changestamp' : 'ct 2/1/2026 02:45'
}
MorseLocalServer >> makeRemoteMorserFor: localMorser [

	| morser |
	morser := MethodMorser new.
	morser server:
		(self species new
			remoteMorser: localMorser;
			remoteSpaces: (self remoteSpaces associations collect: [:assoc | assoc value -> assoc key] as: Dictionary);
			yourself).
	self remoteMorser: morser.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 00:33'
}
MorseLocalServer >> remoteMorser [

	^ remoteMorser
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:24'
}
MorseLocalServer >> remoteMorser: aMethodMorser [

	remoteMorser := aMethodMorser.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/14/2026 22:35'
}
MorseLocalServer >> remoteProjectsFor: projects [

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
	#'squeak_changestamp' : 'ct 2/1/2026 02:41'
}
MorseLocalServer >> remoteServer [

	^ self remoteMorser ifNotNil: #server
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:02'
}
MorseLocalServer >> remoteSpaces [

	^ remoteSpaces
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 01:02'
}
MorseLocalServer >> remoteSpaces: aDictionary [

	remoteSpaces := aDictionary.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/14/2026 22:35'
}
MorseLocalServer >> remoteSpacesFor: spaces [

	self isRunning ifFalse: [self error: 'server not running'].
	self remoteServer isRunning ifFalse: [self error: 'remote server not running'].
	^ self remoteSpaces morseAtAll: spaces
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/1/2026 01:56'
}
MorseLocalServer >> start [

	self stop.
	isRunning := true.
	self triggerEvent: #started.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/1/2026 02:41'
}
MorseLocalServer >> stop [

	self isRunning ifFalse: [^ self].
	
	isRunning := false.
	self remoteServer ifNotNil: #stop.
	self triggerEvent: #stopped.
]
