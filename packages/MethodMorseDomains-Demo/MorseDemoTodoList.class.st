Class {
	#name : #MorseDemoTodoList,
	#superclass : #MorseProject,
	#instVars : [
		'items',
		'name',
		'book',
		'silentLevel'
	],
	#category : #'MethodMorseDomains-Demo-Todo'
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 01:51'
}
MorseDemoTodoList >> addItem: aDemoTodoItem [

	self items add: aDemoTodoItem.
	self reportChangeFrom: nil to: aDemoTodoItem.
	^ aDemoTodoItem
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:47'
}
MorseDemoTodoList >> addItemWithName: aString [

	^ self addItem: (self newItemWithName: aString)
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/12/2026 01:56'
}
MorseDemoTodoList >> applyChange: aChange [

	| item |
	aChange newItem ifNil:
		[^ self removeItem: aChange oldItem].
	
	item := aChange oldItem
		ifNil: [self newItemWithName: aChange newItem name]
		ifNotNil: [:old | self items detect: [:ea | ea name = old name]].
	item
		text: aChange newItem text copy;
		labels: aChange newItem labels copy.
	^ aChange oldItem ifNil:
		[self addItem: item]
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/12/2026 01:41'
}
MorseDemoTodoList >> applyChanges: changes [

	self beSilentDuring:
		[changes do: [:ea |
			self applyChange: ea]].
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/12/2026 01:41'
}
MorseDemoTodoList >> beSilentDuring: aBlock [

	silentLevel := (silentLevel ifNil: [0]) + 1.
	^ aBlock ensure:
		[silentLevel := silentLevel - 1]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:16'
}
MorseDemoTodoList >> book [

	^ book
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:16'
}
MorseDemoTodoList >> book: aDemoTodoBook [

	book := aDemoTodoBook.
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:30'
}
MorseDemoTodoList >> browse [

	^ self book openList: self
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/11/2026 22:55'
}
MorseDemoTodoList >> initialize [

	super initialize.
	
	items := OrderedCollection new.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:54'
}
MorseDemoTodoList >> items [

	^ items
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:52'
}
MorseDemoTodoList >> name [

	^ name
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:52'
}
MorseDemoTodoList >> name: aString [

	name := aString.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 23:47'
}
MorseDemoTodoList >> newItemWithName: aString [

	^ MorseDemoTodoItem new
		name: aString;
		list: self;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 01:51'
}
MorseDemoTodoList >> removeItem: aDemoTodoItem [

	self items remove: aDemoTodoItem.
	self reportChangeFrom: aDemoTodoItem to: nil.
	^ aDemoTodoItem
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/21/2026 02:05'
}
MorseDemoTodoList >> reportChangeFrom: oldItem to: newItem [

	oldItem name = newItem name ifFalse:
		[self changed].
	(silentLevel notNil and: [silentLevel > 0]) ifTrue: [^ self].
	self triggerEvent: #itemsChanged with:
		(oldItem name = newItem name
			ifTrue: [{self newChangeFrom: oldItem to: newItem}]
			ifFalse: [{self newChangeFrom: oldItem to: nil. self newChangeFrom: nil to: newItem} reject: #isIdentical "if one side was nil"]).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:16'
}
MorseDemoTodoList >> space [

	^ self book
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/12/2026 01:44'
}
MorseDemoTodoList >> tryApplyChangesSilently: changes [

	self applyChanges: changes.
	^ #()
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/12/2026 01:48'
}
MorseDemoTodoList >> update: what [

	(self items includes: what) ifTrue:
		[self reportChangeFrom: what to: what].
	^ super update: what
]
