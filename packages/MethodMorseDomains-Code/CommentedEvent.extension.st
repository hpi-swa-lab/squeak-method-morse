Extension { #name : #CommentedEvent }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/21/2026 01:24'
}
CommentedEvent >> asOldMorseItemIn: aCodeProject [

	| morseItem oldComment oldStamp |
	morseItem := self asMorseItemIn: aCodeProject.
	((ChangeSet scanClassCommentVersionsOf: self item) ifNil: [#()])
		at: 2
		ifPresent: [:record |
			oldComment := record text.
			oldStamp := record stamp]
		ifAbsent:
			[oldComment := ''.
			oldStamp := nil].
	morseItem definition:
		(morseItem definition
			morseWithComment: oldComment
			stamp: oldStamp).
	^ morseItem
]
