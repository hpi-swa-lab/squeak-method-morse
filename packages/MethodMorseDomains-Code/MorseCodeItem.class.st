Class {
	#name : #MorseCodeItem,
	#superclass : #MorseItem,
	#instVars : [
		'definition',
		'project'
	],
	#category : #'MethodMorseDomains-Code'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/13/2026 18:56'
}
MorseCodeItem class >> forDefinition: aMCDefinition project: aCodeProject [

	^ self new
		definition: aMCDefinition;
		project: aCodeProject;
		yourself
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/21/2026 01:11'
}
MorseCodeItem >> = anObject [

	self == anObject ifTrue: [^ true].
	self flag: #(workaround yaros).
	(self perform: #class) name = (anObject perform: #class) name ifFalse: [^ false].
	^ self definition = anObject definition
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 21:42'
}
MorseCodeItem >> ancestorVersionKeys [

	self definition isMethodDefinition ifTrue:
		[| class method |
		class := (self definition actualClassIn: self environment)
			ifNil: [^ #()].
		method := (class lookupSelector: self definition selector)
			ifNil: [^ #()].
		^ (ChangeSet scanVersionsOf: method class: class meta: self definition classIsMeta category: self definition category selector: self definition selector)
			collect: [:record | record asMethodDefinition]].
	
	self flag: #todo. "should we return comment stamp for classes here or would this be confusing because older than class definition?"
	
	^ #()
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:09'
}
MorseCodeItem >> definition [

	^ definition
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:09'
}
MorseCodeItem >> definition: aMCDefinition [

	definition := aMCDefinition.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 18:11'
}
MorseCodeItem >> environment [

	^ self project environment
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/1/2026 05:14'
}
MorseCodeItem >> hash [

	^ self class hash hashMultiply bitXor: self definition hash
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:55'
}
MorseCodeItem >> key [

	^ self definition summary
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:23'
}
MorseCodeItem >> name [

	^ self definition summaryAndRevision
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 18:09'
}
MorseCodeItem >> project [

	^ project
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 18:09'
}
MorseCodeItem >> project: aCodeProject [

	project := aCodeProject.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 05:41'
}
MorseCodeItem >> source [

	^ self definition source
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 22:52'
}
MorseCodeItem >> timeStamp [

	self definition isMethodDefinition ifTrue: [^ self definition timeStamp].
	self flag: #todo. "should we return comment stamp for classes here or would this be confusing because older than class definition?"
	^ nil
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 21:42'
}
MorseCodeItem >> versionKey [

	self definition isMethodDefinition ifTrue: [^ self definition].
	self flag: #todo. "should we return comment stamp for classes here or would this be confusing because older than class definition?"
	^ nil
]
