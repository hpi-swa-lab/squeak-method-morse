Extension { #name : #MCPatch }

{
	#category : #'*MethodMorseDomains-Code-serializing',
	#'squeak_changestamp' : 'ct 2/17/2026 01:38'
}
MCPatch class >> morseDeserialize: aString [

	^ (DataStream on: aString asByteArray readStream) next
]

{
	#category : #'*MethodMorseDomains-Code-serializing',
	#'squeak_changestamp' : 'ct 2/17/2026 01:37'
}
MCPatch >> morseSerialized [

	^ ((DataStream on: (RWBinaryOrTextStream on: String new))
		nextPut: self; contents) asString
]
