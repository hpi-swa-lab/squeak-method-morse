Extension { #name : #MethodMorserTool }

{
	#category : #'*MethodMorseDomains-Code-accessing-override',
	#'squeak_changestamp' : 'ct 2/22/2026 23:33'
}
MethodMorserTool >> environment: anEnvironment [

	self morser spaces removeAllSuchThat: [:ea |
		(ea isKindOf: MorseCodeSpace) and: [ea environment == self environment]].
	
	environment := anEnvironment.
	
	self morser addSpace: (MorseCodeSpace forEnvironment: self environment).
	
	self changed: #environment.
]
