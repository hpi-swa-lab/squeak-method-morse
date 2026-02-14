Extension { #name : #MCClassDefinition }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 18:59'
}
MCClassDefinition >> asMorseItemIn: aCodeProject [

	^ MorseCodeItem
		forDefinition: self
		project: aCodeProject
]

{
	#category : #'*MethodMorseDomains-Code-initialize-release',
	#'squeak_changestamp' : 'ct 2/1/2026 22:02'
}
MCClassDefinition >> morseBasicCategory: categoryString [

	category := categoryString.
]

{
	#category : #'*MethodMorseDomains-Code-initialize-release',
	#'squeak_changestamp' : 'ct 2/1/2026 21:11'
}
MCClassDefinition >> morseBasicComment: commentString stamp: stampString [

	comment := commentString withSqueakLineEndings.
	commentStamp := stampString ifNil: [self defaultCommentStamp].
]

{
	#category : #'*MethodMorseDomains-Code-initialize-release',
	#'squeak_changestamp' : 'ct 2/1/2026 21:26'
}
MCClassDefinition >> morseBasicName: nameString [

	name := nameString asSymbol.
]

{
	#category : #'*MethodMorseDomains-Code-copying',
	#'squeak_changestamp' : 'ct 2/1/2026 22:01'
}
MCClassDefinition >> morseWithCategory: categoryString [

	^ self copy
		morseBasicCategory: categoryString;
		yourself
]

{
	#category : #'*MethodMorseDomains-Code-copying',
	#'squeak_changestamp' : 'ct 2/1/2026 21:12'
}
MCClassDefinition >> morseWithComment: commentString stamp: stampString [

	^ self copy
		morseBasicComment: commentString stamp: stampString;
		yourself
]

{
	#category : #'*MethodMorseDomains-Code-copying',
	#'squeak_changestamp' : 'ct 2/1/2026 21:26'
}
MCClassDefinition >> morseWithName: nameString [

	^ self copy
		morseBasicName: nameString;
		yourself
]

{
	#category : #'*MethodMorseDomains-Code-copying',
	#'squeak_changestamp' : 'ct 2/9/2026 19:44'
}
MCClassDefinition >> morseWithTimeStamp: stampString category: categoryString [

	^ self copy
		morseBasicCategory: categoryString;
		morseBasicComment: self comment stamp: stampString;
		yourself
]
