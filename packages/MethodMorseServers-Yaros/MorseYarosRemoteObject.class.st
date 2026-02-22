Class {
	#name : #MorseYarosRemoteObject,
	#superclass : #YarosRemoteObject,
	#category : #'MethodMorseServers-Yaros'
}

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 2/22/2026 01:00'
}
MorseYarosRemoteObject class >> allCategory [

	self flag: #(workaround yaros). "#class is inlined so systemOrganizer class allCategory ends up here"
	^ SystemOrganizer allCategory
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 2/22/2026 01:00'
}
MorseYarosRemoteObject >> beCurrentDuring: aBlock [

	self flag: #(workaround yaros). "exceptions not propagated"
	^ aBlock on: CurrentEnvironment do: [:e | e resume: self]
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 2/17/2026 00:54'
}
MorseYarosRemoteObject >> printOn: aStream [

	aStream nextPutAll: '(Y)'.
	super printOn: aStream.
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 2/17/2026 00:52'
}
MorseYarosRemoteObject >> printString [

	^ '(Y)' , super printString
]
