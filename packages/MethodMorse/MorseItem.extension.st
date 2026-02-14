Extension { #name : #MorseItem }

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 18:28'
}
MorseItem >> newContentModel [

	^ self project newItemContentModel
		item: self;
		yourself
]
