Extension { #name : #MorseRemoteSynchronizationStrategy }

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/10/2026 23:24'
}
MorseRemoteSynchronizationStrategy >> attributesForLocalLabel [

	^ {TextEmphasis struckOut}
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 22:45'
}
MorseRemoteSynchronizationStrategy >> attributesForRemoteLabel [

	^ {TextEmphasis underlined}
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/3/2026 02:53'
}
MorseRemoteSynchronizationStrategy >> shortLabel [

	^ '<-'
]
