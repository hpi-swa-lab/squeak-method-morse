Extension { #name : #MorseSynchronizationStrategy }

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 22:44'
}
MorseSynchronizationStrategy >> attributesForLocalLabel [

	^ #()
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/2/2026 22:44'
}
MorseSynchronizationStrategy >> attributesForRemoteLabel [

	^ #()
]

{
	#category : #'*MethodMorse-UI',
	#'squeak_changestamp' : 'ct 2/10/2026 21:41'
}
MorseSynchronizationStrategy >> shortLabel [

	^ self subclassResponsibility
]
