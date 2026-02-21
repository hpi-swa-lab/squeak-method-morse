Extension { #name : #Duration }

{
	#category : #'*MethodMorse-UI-accessing',
	#'squeak_changestamp' : 'ct 2/21/2026 02:27'
}
Duration >> morseAsExactSeconds [

	^ self asNanoSeconds / 1000000000
]

{
	#category : #'*MethodMorse-UI-printing',
	#'squeak_changestamp' : 'ct 2/21/2026 02:27'
}
Duration >> morseAsWordsAgo [

	^ Time humanWordsForSecondsAgo: self morseAsExactSeconds
]
