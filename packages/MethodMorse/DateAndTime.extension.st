Extension { #name : #DateAndTime }

{
	#category : #'*MethodMorse-UI-squeak protocol',
	#'squeak_changestamp' : 'ct 2/14/2026 19:08'
}
DateAndTime >> morseShortLocalPrintOn: aStream [

	| local |
	local := self asLocal.
	
	local printYMDOn: aStream.
	aStream space.
	local printHMSOn: aStream.
]

{
	#category : #'*MethodMorse-UI-squeak protocol',
	#'squeak_changestamp' : 'ct 2/14/2026 19:08'
}
DateAndTime >> morseShortLocalPrintString [
	"Print date and time truncated to seconds in the local time zone.
	Prints either:
		'YYYY-MM-DD hh:mm:ss' (for positive years) or '-YYYY-MM-DD hh:mm:ss' (for negative years)"

	self flag: #moveUpstream.
	^ String new: 19 streamContents: [:stream | self morseShortLocalPrintOn: stream]
]
