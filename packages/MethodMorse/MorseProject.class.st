Class {
	#name : #MorseProject,
	#superclass : #Object,
	#category : #'MethodMorse-Model'
}

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/11/2026 17:50'
}
MorseProject >> applyChanges: changes [

	^ self subclassResponsibility
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/17/2026 00:18'
}
MorseProject >> browse [

	^ self browse: self
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/21/2026 02:10'
}
MorseProject >> browse: aProject [

	^ self subclassResponsibility
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/21/2026 02:04'
}
MorseProject >> compare: local with: remote from: remoteProject [

	| localItems remoteItems additions modifications removals |
	localItems := local items collect: [:ea | ea name -> ea] as: Dictionary.
	remoteItems := remote items collect: [:ea | ea name -> ea] as: Dictionary.
	modifications := ((localItems keys intersection: remoteItems keys)
		collect: [:key |
			self newChangeFrom: (localItems at: key) to: (remoteItems at: key)])
				reject: #isIdentical.
	additions := (remoteItems keys copyWithoutAll: localItems keys)
		collect: [:key |
			self newChangeFrom: nil to: (remoteItems at: key)].
	removals := (localItems keys copyWithoutAll: remoteItems keys)
		collect: [:key |
			self newChangeFrom: (localItems at: key) to: nil].
	^ modifications , additions , removals
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 05:01'
}
MorseProject >> itemAt: key ifAbsent: absentBlock [

	^ self items
		detect: [:ea | ea key = key]
		ifNone: [absentBlock value]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 04:49'
}
MorseProject >> items [

	^ self subclassResponsibility
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:37'
}
MorseProject >> name [

	self flag: #subclassResponsibility.
	^ String streamContents: [:s | super printOn: s]
]

{
	#category : #comparing,
	#'squeak_changestamp' : 'ct 2/11/2026 17:07'
}
MorseProject >> newChangeFrom: oldItem to: newItem [

	^ MorseChange from: oldItem to: newItem
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 18:28'
}
MorseProject >> newItemContentModel [

	^ MorseItemHolder new
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/22/2026 00:59'
}
MorseProject >> newItemContentModelFor: anItem [

	^ self newItemContentModel
		item: anItem;
		yourself
]

{
	#category : #printing,
	#'squeak_changestamp' : 'ct 2/1/2026 03:54'
}
MorseProject >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $).
]

{
	#category : #converting,
	#'squeak_changestamp' : 'ct 2/2/2026 03:28'
}
MorseProject >> serialized [

	^ self
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:17'
}
MorseProject >> space [

	^ self subclassResponsibility
]

{
	#category : #sync,
	#'squeak_changestamp' : 'ct 2/11/2026 17:43'
}
MorseProject >> tryApplyChangesSilently: changes [

	^ self subclassResponsibility
]
