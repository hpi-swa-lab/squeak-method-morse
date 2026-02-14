Extension { #name : #MorseLocalSynchronizationStrategy }

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 22:44'
}
MorseLocalSynchronizationStrategy >> attributesForLocalLabel [

	^ {TextEmphasis underlined}
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 22:44'
}
MorseLocalSynchronizationStrategy >> attributesForRemoteLabel [

	^ {TextEmphasis struckOut}
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/3/2026 02:53'
}
MorseLocalSynchronizationStrategy >> shortLabel [

	^ '->'
]
