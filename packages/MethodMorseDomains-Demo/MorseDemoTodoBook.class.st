Class {
	#name : #MorseDemoTodoBook,
	#superclass : #MorseSpace,
	#instVars : [
		'lists'
	],
	#classVars : [
		'Default'
	],
	#category : #'MethodMorseDomains-Demo-Todo'
}

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/11/2026 22:13'
}
MorseDemoTodoBook class >> cleanUp: aggressive [

	aggressive ifTrue:
		[Default := nil].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:13'
}
MorseDemoTodoBook class >> default [

	^ Default ifNil: [Default := self new]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:02'
}
MorseDemoTodoBook >> addList: aDemoTodoList [

	^ self lists add: aDemoTodoList
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:51'
}
MorseDemoTodoBook >> addListNamed: aString [

	^ self addList: (self newListWithName: aString)
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/11/2026 22:41'
}
MorseDemoTodoBook >> initialize [

	super initialize.
	
	lists := OrderedCollection new.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:41'
}
MorseDemoTodoBook >> lists [

	^ lists
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 23:16'
}
MorseDemoTodoBook >> newListWithName: aString [

	^ MorseDemoTodoList new
		name: aString;
		book: self;
		yourself
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:12'
}
MorseDemoTodoBook >> open [

	^ MorseDemoTodoTool openOn: self
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/21/2026 21:41'
}
MorseDemoTodoBook >> openItem: aDemoTodoItem [

	^ (MorseDemoTodoTool on: self)
		selectList: aDemoTodoItem list;
		selectItem: aDemoTodoItem;
		open
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:31'
}
MorseDemoTodoBook >> openList: aDemoTodoList [

	^ (MorseDemoTodoTool on: self)
		selectList: aDemoTodoList;
		open
]

{
	#category : #printing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:32'
}
MorseDemoTodoBook >> printOn: aStream [

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:15'
}
MorseDemoTodoBook >> projects [

	^ self lists
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:02'
}
MorseDemoTodoBook >> removeList: aDemoTodoList [

	^ self lists remove: aDemoTodoList
]
