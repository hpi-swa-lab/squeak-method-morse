Extension { #name : #MorseProject }

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
