Extension { #name : #Dictionary }

{
	#category : #'*MethodMorse-accessing',
	#'squeak_changestamp' : 'ct 2/14/2026 22:34'
}
Dictionary >> morseAtAll: keys [

	self flag: #moveUpstream.
	^ keys collect: [:key | self at: key]
]

{
	#category : #'*MethodMorse-accessing',
	#'squeak_changestamp' : 'ct 2/14/2026 22:34'
}
Dictionary >> morseAtAll: keys put: anObject [

	self flag: #moveUpstream.
	keys do: [:key | self at: key put: anObject].
	^ anObject
]

{
	#category : #'*MethodMorse-accessing',
	#'squeak_changestamp' : 'ct 2/14/2026 22:35'
}
Dictionary >> morseAtAll: keyArray putAll: valueArray [

	self flag: #moveUpstream.
	keyArray with: valueArray do: [:index :value | self at: index put: value].
	^ valueArray
]
