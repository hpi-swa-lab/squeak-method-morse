Class {
	#name : #MorseYarosServer,
	#superclass : #MorseServer,
	#instVars : [
		'yarosServer'
	],
	#category : #'MethodMorseServers-Yaros'
}

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/1/2026 00:24'
}
MorseYarosServer class >> connectionLabel [

	^ #yaros
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/14/2026 19:32'
}
MorseYarosServer class >> connectionSpec [

	^ self
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/1/2026 00:23'
}
MorseYarosServer class >> connectionType [

	^ #yaros
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/16/2026 20:25'
}
MorseYarosServer class >> defaultConnectionSpecForPeerType: peerType [

	^ peerType caseOf:
		{[#server] -> [
'MorseYarosServer forYaros:
	(YarosServer new
		connector: (YarosWebSocketServerConnector remoteName: ''localhost'' port: 8082);
		yourself)'].
		[#client] -> [
'MorseYarosServer forYaros:
	(YarosServer new
		connector: (YarosWebSocketClientConnector remoteName: ''localhost'' port: 8082);
		yourself)']}
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/16/2026 20:23'
}
MorseYarosServer class >> editConnection [

	| peerType |
	peerType := Project uiManager
		chooseFromLabeledValues: (#(server client) collect: [:ea | ea asString -> ea] as: OrderedDictionary)
		title: 'Choose peer type'.
	peerType ifNil: [^ nil].
	^ self editConnectionForPeerType: peerType
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/16/2026 20:23'
}
MorseYarosServer class >> editConnectionForPeerType: peerType [

	| spec |
	spec := Project uiManager
		request: 'edit connection'
		initialAnswer: (self defaultConnectionSpecForPeerType: peerType).
	spec isEmptyOrNil ifTrue: [^ nil].
	^ Compiler evaluate: spec
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/16/2026 20:25'
}
MorseYarosServer class >> forYaros: aYarosServer [

	^ self new initializeWithYarosServer: aYarosServer
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 2/22/2026 00:59'
}
MorseYarosServer class >> todo [

	self systemNavigation browseAllCallsOn: #yaros and: #flag:.
	"main issues encountered so far:
	* yaros does not support weak references (weakly referenced proxies are gc'ed even if the original object on the other side still exists)
	* many comparisons/#isKindOf: assume identical classes, not equal (same-named?) classes
	* #class is inlined so class-side sends to proxies end up on proxy class side
	* exceptions are not propagated to the other side
	* non-local returns don't work
	* tools should open locally (eg #browse)"
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/16/2026 20:36'
}
MorseYarosServer >> connectionLabel [

	^ self class connectionLabel
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/16/2026 20:36'
}
MorseYarosServer >> connectionType [

	^ self class connectionType
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/17/2026 00:27'
}
MorseYarosServer >> initializeWithYarosServer: aYarosServer [

	yarosServer := aYarosServer.
	
	self yarosServer remoteObjectClass: MorseYarosRemoteObject.
	
	self yarosServer environment:
		(Environment new
			at: #methodMorser put: self morser;
			yourself).
	
	self yarosServer
		when: #started send: #noteYarosStarted to: self;
		when: #stopped send: #noteYarosStopped to: self.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/16/2026 20:26'
}
MorseYarosServer >> isRunning [

	^ self yarosServer isRunning
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 21:13'
}
MorseYarosServer >> morser: aMethodMorser [

	super morser: aMethodMorser.
	
	self yarosServer ifNotNil: [:yaros |
		yaros environment at: #methodMorser put: self morser].
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/16/2026 20:29'
}
MorseYarosServer >> noteYarosStarted [

	self triggerEvent: #started.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/16/2026 20:29'
}
MorseYarosServer >> noteYarosStopped [

	self triggerEvent: #stopped.
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/16/2026 20:28'
}
MorseYarosServer >> release [

	self yarosServer removeActionsWithReceiver: self.
	^ super release
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 20:37'
}
MorseYarosServer >> remoteMorser [

	self isRunning ifFalse: [^ nil].
	^ self yarosServer get: #methodMorser
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/16/2026 20:28'
}
MorseYarosServer >> start [

	self stop.
	self yarosServer start.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/16/2026 20:29'
}
MorseYarosServer >> stop [

	self yarosServer stop.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 20:20'
}
MorseYarosServer >> yarosServer [

	^ yarosServer
]
