Class {
	#name : #MorseYarosRemoteObject,
	#superclass : #YarosRemoteObject,
	#category : #'MethodMorseServers-Yaros'
}

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 2/17/2026 00:26'
}
MorseYarosRemoteObject >> beCurrentDuring: aBlock [

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
