Extension { #name : #SharedQueue2 }

{
	#category : #'*MethodMorse-accessing',
	#'squeak_changestamp' : 'ct 2/15/2026 21:12'
}
SharedQueue2 >> morseNextUpToBlocking [
	"Wait until at least one element is available, then answer it and all other available elements until the receiver blocks."

	^monitor critical: [
		monitor waitWhile: [ items isEmpty ].
		items removeFirst: items size ]
]
