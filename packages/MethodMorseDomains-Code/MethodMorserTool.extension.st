Extension { #name : #MethodMorserTool }

{
	#category : #'*MethodMorseDomains-Code-accessing-override',
	#'squeak_changestamp' : 'ct 2/17/2026 00:37'
}
MethodMorserTool >> environment: anEnvironment [

	self morser spaces removeAllSuchThat: [:ea |
		(ea isKindOf: MorseCodeSpace) and: [ea environment == self environment]].
	
	environment := anEnvironment.
	
	self morser addSpace: (MorseCodeSpace forEnvironment: self environment).
]
