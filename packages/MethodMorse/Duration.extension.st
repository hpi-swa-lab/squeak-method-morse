Extension { #name : #Duration }

{
	#category : #'*MethodMorse-UI-printing',
	#'squeak_changestamp' : 'ct 2/16/2026 00:03'
}
Duration >> morseAsWordsAgo [

	^ Time humanWordsForSecondsAgo: self fullSeconds
]
