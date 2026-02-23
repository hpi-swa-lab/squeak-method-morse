Class {
	#name : #MorseYarosServer,
	#superclass : #MorseServer,
	#instVars : [
		'yarosServer',
		'remoteMorser',
		'connectionProcess'
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
	#category : #private,
	#'squeak_changestamp' : 'ct 2/22/2026 23:53'
}
MorseYarosServer >> connect [

	| newRemoteMorser |
	[[newRemoteMorser := self getRemoteMorser]
		on: Error do: [:ex | ex messageText = 'timeout' ifFalse: [ex pass]. ex return: nil]]
			whileNil.
	connectionProcess := nil.
	self connectTo: newRemoteMorser.
	
	"optimization to avoid waiting until next timeout"
	self remoteMorser server connectTo: self morser.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/22/2026 21:51'
}
MorseYarosServer >> connectTo: aRemoteMorser [

	connectionProcess ifNotNil: #terminate.
	remoteMorser := aRemoteMorser.
	self triggerEvent: #connected.
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/22/2026 23:55'
}
MorseYarosServer >> connectionLabel [

	| label |
	label := self class connectionLabel.
	self yarosType ifNotNil: [:type |
		label := '{1} {2}' format: {label. type}].
	^ label
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/22/2026 23:55'
}
MorseYarosServer >> connectionType [

	| type |
	type := self class connectionType.
	type := (type , (self yarosType ifNil: [#other]) capitalized) asSymbol.
	^ type
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/22/2026 19:07'
}
MorseYarosServer >> getRemoteMorser [

	^ self yarosServer get: #methodMorser
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/22/2026 22:36'
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
		when: #stopped send: #noteYarosStopped to: self;
		when: #disconnected send: #noteYarosDisconnected to: self;
		when: #aboutToStop send: #removeActionsWithReceiver:forEvent: to: self yarosServer withArguments: {self. #disconnected}.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/22/2026 19:07'
}
MorseYarosServer >> isConnected [

	^ self remoteMorser notNil
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
	#'squeak_changestamp' : 'ct 2/22/2026 22:42'
}
MorseYarosServer >> noteYarosDisconnected [

	self isConnected ifTrue: [self stop].
 
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/22/2026 21:51'
}
MorseYarosServer >> noteYarosStarted [

	self triggerEvent: #started.
	self startConnecting.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/22/2026 22:36'
}
MorseYarosServer >> noteYarosStopped [

	remoteMorser := nil.
	self triggerEvent: #disconnected.
	self triggerEvent: #stopped.
	
	self yarosServer when: #disconnected send: #noteYarosDisconnected to: self.
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
	#'squeak_changestamp' : 'ct 2/22/2026 19:23'
}
MorseYarosServer >> remoteMorser [

	^ remoteMorser
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
	#category : #private,
	#'squeak_changestamp' : 'ct 2/22/2026 21:51'
}
MorseYarosServer >> startConnecting [

	connectionProcess := [[self connect]
		ensure: [connectionProcess := nil]]
			forkAt: Processor systemBackgroundPriority.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 2/22/2026 21:52'
}
MorseYarosServer >> stop [

	connectionProcess ifNotNil: #terminate.
	self yarosServer stop.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/16/2026 20:20'
}
MorseYarosServer >> yarosServer [

	^ yarosServer
]

{
	#category : #connection,
	#'squeak_changestamp' : 'ct 2/23/2026 01:40'
}
MorseYarosServer >> yarosType [

	^ #(client server)
		detect: [:subtype |
			self yarosServer printString includesSubstring: subtype caseSensitive: false]
		ifNone: [nil]
]
