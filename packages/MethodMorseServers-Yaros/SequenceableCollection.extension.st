Extension { #name : #SequenceableCollection }

{
	#category : #'*MethodMorseServers-Yaros-comparing-override',
	#'squeak_changestamp' : 'ct 2/22/2026 00:58'
}
SequenceableCollection >> = otherCollection [ 
	"Answer true if the receiver is equivalent to the otherCollection.
	First test for identity, then rule out different class and sizes of
	collections. As a last resort, examine each element of the receiver
	and the otherCollection."

	self == otherCollection ifTrue: [^ true].
	self class = otherCollection class ifFalse:
		[| c |
		self flag: #(workaround yaros).
		((c := otherCollection perform: #class) isProxy and: [c class includesBehavior: YarosRemoteObject] and: [c name = self class name]) ifFalse: [^ false]].
	^ self hasEqualElements: otherCollection
]
