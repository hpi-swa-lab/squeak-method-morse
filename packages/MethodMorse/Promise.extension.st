Extension { #name : #Promise }

{
	#category : #'*MethodMorse-resolving',
	#'squeak_changestamp' : 'ct 2/23/2026 00:59'
}
Promise >> morseFulfillOrRejectIfCurtailedWith: aBlock [
	"Avoid stale promises if aBlock is curtailed without raising an error, e.g. when closing a debugger that shows a warning."

	^ [self fulfillWith: aBlock]
		ifCurtailed: [self rejectWith: #curtailed]
]

{
	#category : #'*MethodMorse-waiting',
	#'squeak_changestamp' : 'ct 2/23/2026 00:55'
}
Promise >> morseWaitOrTerminateIfCurtailed [

	self settle.
	^ self isResolved ifTrue: [ value ] ifFalse:
		[ self errorValue = #curtailed ifTrue: [ Processor terminateActive ].
		 self signalErrorValue ]
]
