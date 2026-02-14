Class {
	#name : #MorseCodeChange,
	#superclass : #MorseChange,
	#instVars : [
		'systemEvent'
	],
	#category : #'MethodMorseDomains-Code'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/1/2026 04:01'
}
MorseCodeChange class >> from: oldItem to: newItem event: systemEvent [

	^ (self from: oldItem to: newItem)
		systemEvent: systemEvent;
		yourself
]

{
	#category : #converting,
	#'squeak_changestamp' : 'ct 2/1/2026 22:50'
}
MorseCodeChange >> asMCOperationsForClassRenameIn: anEnvironment [

	| class |
	class := (self newItem definition actualClassIn: anEnvironment)
		ifNil: [self oldItem definition actualClassIn: anEnvironment].
	^ {MCRemoval of: self oldItem definition. MCAddition of: self newItem definition} ,
		((class theNonMetaClass methodDict values , class theMetaClass methodDict values) collect: [:method |
			| oldMethod newMethod |
			newMethod := method morseAsMCDefinition morseWithClassName: self newItem name.
			oldMethod := method morseAsMCDefinition morseWithClassName: self oldItem name.
			MCModification of: oldMethod to: newMethod])
]

{
	#category : #converting,
	#'squeak_changestamp' : 'ct 2/1/2026 22:50'
}
MorseCodeChange >> asMCOperationsIn: anEnvironment [

	self oldItem ifNil: [^ {MCAddition of: self newItem definition}].
	self newItem ifNil: [^ {MCRemoval of: self oldItem definition}].
	
	(self anyItem definition isClassDefinition and: [self newItem name ~= self oldItem name]) ifTrue:
		[^ self asMCOperationsForClassRenameIn: anEnvironment].
	^ {MCModification of: self oldItem definition to: self newItem definition}
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:01'
}
MorseCodeChange >> systemEvent [

	^ systemEvent
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:02'
}
MorseCodeChange >> systemEvent: anEvent [

	systemEvent := anEvent.
]
