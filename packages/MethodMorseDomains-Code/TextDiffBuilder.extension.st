Extension { #name : #TextDiffBuilder }

{
	#category : #'*MethodMorseDomains-Code-UI-creating patches',
	#'squeak_changestamp' : 'ct 2/4/2026 00:24'
}
TextDiffBuilder >> morseBuildNewOnlyPatchWithAttributes: useAttributes withPrefixes: usePrefixes [

	| stream result |
	stream := useAttributes ifFalse: [WriteStream on: String new] ifTrue: [AttributedTextStream new].
	
	self
		patchSequenceDoIfMatch: [:string |
			useAttributes ifTrue: [stream currentAttributes: self class normalTextAttributes].
			self print: string on: stream]
		ifInsert: [:string | | str |
			str := string.
			useAttributes ifTrue: [stream currentAttributes: self class morseNewTextAttributes].
			usePrefixes ifTrue: [str := '+ ' , str].
			self print: str on: stream]
		ifRemove: [:string | ].
	result := stream contents.
	
	(result notEmpty
		and: [result last = Character cr
		and: [(self lastIsCR: xLines) not
		and: [(self lastIsCR: yLines) not]]]) ifTrue:
			[result := result allButLast].
	
	^ result
]

{
	#category : #'*MethodMorseDomains-Code-UI-creating patches',
	#'squeak_changestamp' : 'ct 2/9/2026 21:45'
}
TextDiffBuilder >> morseBuildTwoSiteDisplayPatch [

	^ self morseBuildTwoSitePatchWithAttributes: true
]

{
	#category : #'*MethodMorseDomains-Code-UI-instance creation',
	#'squeak_changestamp' : 'ct 2/9/2026 21:43'
}
TextDiffBuilder class >> morseBuildTwoSiteDisplayPatchForLocal: aString remote: anotherString inClass: sourceClass prettyDiffs: prettyDiffs [

	^((sourceClass notNil and: [ prettyDiffs ])
		ifFalse: [self from: aString to: anotherString]
		ifTrue: [
			PrettyTextDiffBuilder
				from: aString
				to: anotherString
				inClass: sourceClass ]) morseBuildTwoSiteDisplayPatch
]

{
	#category : #'*MethodMorseDomains-Code-UI-creating patches',
	#'squeak_changestamp' : 'ct 2/9/2026 23:11'
}
TextDiffBuilder >> morseBuildTwoSitePatchWithAttributes: useAttributes [

	| stream result |
	stream := useAttributes ifFalse: [WriteStream on: String new] ifTrue: [AttributedTextStream new].
	
	self
		patchSequenceDoIfMatch: [:string |
			useAttributes ifTrue: [stream currentAttributes: self class normalTextAttributes].
			stream withAttributes: self class morseSiteLabelAttributes do:
				[stream nextPutAll: '		'].
			self print: string on: stream]
		ifInsert: [:string |
			useAttributes ifTrue: [stream currentAttributes: self class morseLocalTextAttributes].
			stream withAttributes: self class morseSiteLabelAttributes do:
				[stream nextPutAll:  'local:	'].
			self print: string on: stream]
		ifRemove: [:string |
			useAttributes ifTrue: [stream currentAttributes: self class morseRemoteTextAttributes].
			stream withAttributes: self class morseSiteLabelAttributes do:
				[stream nextPutAll:  'remote:	'].
			self print: string on: stream].
	result := stream contents.
	
	(result notEmpty
		and: [result last = Character cr
		and: [(self lastIsCR: xLines) not
		and: [(self lastIsCR: yLines) not]]]) ifTrue:
			[result := result allButLast].
	
	^ result
]

{
	#category : #'*MethodMorseDomains-Code-UI-preferences',
	#'squeak_changestamp' : 'ct 2/10/2026 23:20'
}
TextDiffBuilder class >> morseLocalTextAttributes [

	^ self userInterfaceTheme morseLocalTextAttributes
		ifNil: [{TextColor color: Color green}]
]

{
	#category : #'*MethodMorseDomains-Code-UI-preferences',
	#'squeak_changestamp' : 'ct 2/10/2026 23:20'
}
TextDiffBuilder class >> morseNewTextAttributes [

	^ self userInterfaceTheme morseNewTextAttributes
		ifNil: [{TextColor color: Color green darker. TextEmphasis underlined}]
]

{
	#category : #'*MethodMorseDomains-Code-UI-preferences',
	#'squeak_changestamp' : 'ct 2/10/2026 23:20'
}
TextDiffBuilder class >> morseRemoteTextAttributes [

	^ self userInterfaceTheme morseRemoteTextAttributes
		ifNil: [{TextColor color: Color magenta}]
]

{
	#category : #'*MethodMorseDomains-Code-UI-preferences',
	#'squeak_changestamp' : 'ct 2/10/2026 23:20'
}
TextDiffBuilder class >> morseSiteLabelAttributes [

	^ self userInterfaceTheme morseSiteLabelAttributes
		ifNil: [{TextFontReference toFont: Preferences standardButtonFont}]
]
