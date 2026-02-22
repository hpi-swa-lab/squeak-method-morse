Class {
	#name : #MorseItem,
	#superclass : #Object,
	#category : #'MethodMorse-Model'
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 21:40'
}
MorseItem >> ancestorVersionKeys [

	^ #()
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:54'
}
MorseItem >> key [

	^ self subclassResponsibility
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:54'
}
MorseItem >> name [

	^ self key
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 21:46'
}
MorseItem >> parsedTimeStamp [

	^ TimeStamp fromMethodTimeStamp: self timeStamp
]

{
	#category : #printing,
	#'squeak_changestamp' : 'ct 2/1/2026 03:54'
}
MorseItem >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 18:09'
}
MorseItem >> project [

	^ self subclassResponsibility
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 18:09'
}
MorseItem >> projectName [

	^ self project name
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 04:34'
}
MorseItem >> timeStamp [

	^ self subclassResponsibility
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 21:42'
}
MorseItem >> versionKey [

	^ self
]
