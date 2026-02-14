Extension { #name : #Collection }

{
	#category : #'*MethodMorse-enumerating',
	#'squeak_changestamp' : 'ct 2/13/2026 23:43'
}
Collection >> morseConcurrentCollect: aBlock [ 

	| results states semaphores processes |
	self size < 2 ifTrue: [^ self collect: aBlock].
	
	results := Array new: self size.
	states := Array new: self size.
	processes := Array new: self size.
	semaphores := self asArray withIndexCollect: [:ea :index |
		| semaphore |
		semaphore := Semaphore new.
		processes at: index put:
			([[[results at: index put: (aBlock cull: ea).
			states at: index put: true]
				on: Error , Warning ", Halt" do: [:ex |
					states at: index put: ex]]
						ensure: [semaphore signal]]
							newProcess
								priority: Processor activePriority;
								environmentAt: #morseParentProcess put: Processor activeProcess;
								resume).
		semaphore].
	[semaphores do: [:semaphore | semaphore wait]]
		ifCurtailed: [processes do: #terminate].
	(states select: [:state | state ~~ true])
		ifNotEmpty: [:failedStates | self error: ('collect: failed for {1} elements ({2})' format: {failedStates size. (failedStates collect: #asString) asBag})].
	^ results as: self species
]
