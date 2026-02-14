Extension { #name : #Process }

{
	#category : #'*MethodMorse-accessing',
	#'squeak_changestamp' : 'ct 2/13/2026 23:44'
}
Process >> morseRootProcess [

	^ (self environmentAt: #morseParentProcess ifAbsent: [^ self])
		morseRootProcess
]
