Class {
	#name : #MorseDemoTodoItem,
	#superclass : #MorseItem,
	#instVars : [
		'name',
		'text',
		'labels',
		'list'
	],
	#category : #'MethodMorseDomains-Demo-Todo'
}

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/21/2026 02:07'
}
MorseDemoTodoItem >> = anotherItem [

	self == anotherItem ifTrue: [^ true].
	self flag: #(workaround yaros).
	(self perform: #class) name = (anotherItem perform: #class) name ifFalse: [^ false].
	^ {self name. self text. self labels} = {anotherItem name. anotherItem text. anotherItem labels}
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 01:50'
}
MorseDemoTodoItem >> addLabel: aString [

	^ self doUpdate:
		[self labels add: aString]
]

{
	#category : #converting,
	#'squeak_changestamp' : 'ct 2/12/2026 00:13'
}
MorseDemoTodoItem >> asStringOrText [

	^ Text streamContents: [:stream |
		stream nextPutAll: self text.
		stream cr; cr.
		stream withAttribute: TextEmphasis italic do:
			[stream nextPutAll: 'Labels: '; nextPutAll: self labels asCommaString]]
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/12/2026 00:15'
}
MorseDemoTodoItem >> browse [

	^ self list browse
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/12/2026 16:13'
}
MorseDemoTodoItem >> doUpdate: aBlock [

	| oldItem result |
	oldItem := self copy.
	result := aBlock value.
	self changed.
	self list ifNotNil: [self list reportChangeFrom: oldItem to: self].
	^ result
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/12/2026 00:11'
}
MorseDemoTodoItem >> hash [

	^ {self class. self name. self text. self labels} hash
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/12/2026 00:04'
}
MorseDemoTodoItem >> initialize [

	super initialize.
	
	self text: ''.
	self labels: OrderedCollection new.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:51'
}
MorseDemoTodoItem >> key [

	^ self name
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:01'
}
MorseDemoTodoItem >> labels [

	^ labels
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 01:50'
}
MorseDemoTodoItem >> labels: aCollection [

	self doUpdate: [labels := aCollection].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:42'
}
MorseDemoTodoItem >> list [

	^ list
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 01:51'
}
MorseDemoTodoItem >> list: aDemoTodoList [

	list := aDemoTodoList.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:49'
}
MorseDemoTodoItem >> name [

	^ name
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 01:51'
}
MorseDemoTodoItem >> name: aString [

	self doUpdate: [name := aString].
]

{
	#category : #copying,
	#'squeak_changestamp' : 'ct 2/12/2026 16:10'
}
MorseDemoTodoItem >> postCopy [

	super postCopy.
	text := text copy.
	labels := labels copy.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:42'
}
MorseDemoTodoItem >> project [

	^ self list
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 01:51'
}
MorseDemoTodoItem >> removeLabel: aString [

	^ self doUpdate: [self labels remove: aString]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:01'
}
MorseDemoTodoItem >> text [

	^ text
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 01:51'
}
MorseDemoTodoItem >> text: aString [

	self doUpdate: [text := aString].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:51'
}
MorseDemoTodoItem >> timeStamp [

	^ nil
]
