Extension { #name : #MenuMorph }

{
	#category : #'*MethodMorse-UI-menu construction',
	#'squeak_changestamp' : 'ct 2/10/2026 22:43'
}
MenuMorph >> morseAdd: label getState: getter setState: setter [

	| target |
	self flag: #moveUpstream.
	
	target := self defaultTarget.
	(getter respondsTo: #receiver) ifFalse: [^ self morseAdd: label getState: [getter value: target] setState: setter].
	(setter respondsTo: #receiver) ifFalse: [^ self morseAdd: label getState: getter setState: [:boolean | setter cull: target cull: boolean]].
	
	^ self addMorphBack: (UpdatingMenuItemMorph new
		target: [setter cull: getter value not];
		selector: #value;
		wordingProvider: ['<{1}>{2}' format: {getter value ifTrue: [#on] ifFalse: [#off]. label value}]
			wordingSelector: #value;
		arguments: #();
		yourself)
]
