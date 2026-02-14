Extension { #name : #SharedQueue2 }

{
	#category : #'*MethodMorse-accessing',
	#'squeak_changestamp' : 'ct 2/14/2026 19:09'
}
SharedQueue2 >> morseNextUpToBlocking [
	"Wait until at least one element is available, then answer it and all other available elements until the receiver blocks."

	| next |
	self flag: #moveUpstream.
	next := self next.
	^ Array streamContents: [:stream |
		[stream nextPut: next.
		(next := self nextOrNil) isNil] whileFalse]
]
