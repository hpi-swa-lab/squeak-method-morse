Class {
	#name : #MorseCodeItemHolder,
	#superclass : #CodeHolder,
	#instVars : [
		'item',
		'oldItem',
		'previewItem',
		'diff',
		'siteName',
		'editBlock'
	],
	#category : #'MethodMorseDomains-Code-UI'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/2/2026 05:14'
}
MorseCodeItemHolder class >> on: anItem [

	^ self new
		item: anItem;
		yourself
]

{
	#category : #'code pane',
	#'squeak_changestamp' : 'ct 2/10/2026 22:24'
}
MorseCodeItemHolder >> aboutToStyle: aStyler [

	self item ifNil: [^ false].
	self isDivergent ifTrue: [^ false].
	
	self isModeStyleable ifFalse: [^ false].
	
	aStyler parseAMethod: self isShowingMethod.
	aStyler classOrMetaClass: self localSelectedClassOrMetaClass.
	^ true
]

{
	#category : #'message list',
	#'squeak_changestamp' : 'ct 2/10/2026 00:46'
}
MorseCodeItemHolder >> addExtraShiftedItemsTo: aMenu [

	self flag: #moveUpstream. "!"
]

{
	#category : #annotation,
	#'squeak_changestamp' : 'ct 2/10/2026 22:24'
}
MorseCodeItemHolder >> annotation [

	| timeStamp |
	self item ifNil: [^ ''].
	self isDivergent ifTrue: [^ ''].
	
	timeStamp := (self item timeStamp ifNil: ['']) ifEmpty: [self noTimeStampLabel].
	^ timeStamp , self annotationSeparator , self definition category
]

{
	#category : #annotation,
	#'squeak_changestamp' : 'ct 2/9/2026 19:38'
}
MorseCodeItemHolder >> annotation: aStringOrText [

	| newTimeStamp newCategory |
	aStringOrText ifEmpty: [^ self changed: #flash].
	
	(aStringOrText splitBy: self annotationSeparator) in: [:parts |
		parts size = 2 ifFalse: [^ self changed: #flash].
		newTimeStamp := parts first.
		newTimeStamp = self noTimeStampLabel ifTrue: [newTimeStamp := nil].
		newCategory := parts second].
	
	"validate"
	newTimeStamp ifNotNil:
		[([TimeStamp fromMethodTimeStamp: newTimeStamp] ifError: [nil]) ifNil:
			[(self confirm: 'entered timestamp is invalid, continue anyway?') ifFalse: [^ false]]].
	
	self edit:
		(self definition
			morseWithTimeStamp: newTimeStamp
			category: newCategory).
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/10/2026 21:20'
}
MorseCodeItemHolder >> buildMessageListSingletonWith: builder [

	^ builder pluggableListSpec new
		model: self;
		list: #messageListSingleton; 
		getIndex: #singletonIndex; 
		menu: #messageListMenu:shifted:;
		keyPress: #messageListKey:from:;
		hScrollBarPolicy: #never;
		vScrollBarPolicy: #never;
		minimumHeight: 0;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/10/2026 22:05'
}
MorseCodeItemHolder >> buildPaneWith: builder [

	self hasSiteName ifFalse: [^ self buildCodePaneWith: builder].
	
	^ builder pluggablePanelSpec new
		model: self;
		children:
			(Array
				with:
					((self buildMessageListSingletonWith: builder)
						frame:
							(LayoutFrame fullFrame
								bottomFraction: 0;
								bottomOffset: (self messageListSingletonHeightWith: builder);
								yourself);
						yourself)
				with:
					((self buildCodePaneWith: builder)
						frame:
							(LayoutFrame fullFrame
								topOffset: (self messageListSingletonHeightWith: builder);
								yourself);
						yourself));
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/10/2026 20:53'
}
MorseCodeItemHolder >> classCommentIndicated [

	^ self isShowingClass
]

{
	#category : #'code pane',
	#'squeak_changestamp' : 'ct 2/10/2026 21:26'
}
MorseCodeItemHolder >> compileMessage: aStringOrText notifying: requestor [

	| class messageName selector |
	self isShowingClass ifTrue:
		[self flag: #todo. "support this via temporary environments (see note below)"
		^ self inform: 'cannot edit classes'].
	
	aStringOrText ifEmpty: [^ self edit: nil].
	
	messageName := self selectedMessageName.
	class := self selectedClassOrMetaClass.
	messageName ifNotNil:
		[selector := (class ifNotNil: [class newParser] ifNil: [Parser new]) parseSelector: aStringOrText.
		selector = messageName ifFalse: [^ self inform: 'cannot change selector here']].
	
	"validate"
	self flag: #forLater. "validate by compiling against actual temporal environment"
	[(class ifNotNil: [class newCompiler] ifNil: [Compiler new])
		compile: aStringOrText
		in: (class ifNil: [Object])
		environment: self environment
		notifying: requestor
		ifFail: [^ false]]
			on: UndeclaredVariable
			do: [:exception | exception resume: UndeclaredVariableNode new].
	
	self edit:
		(self editableDefinition
			morseWithSource: aStringOrText asString
			timeStamp: Utilities changeStamp).
]

{
	#category : #controls,
	#'squeak_changestamp' : 'ct 2/2/2026 19:34'
}
MorseCodeItemHolder >> contentsSymbolQuints [

	^ self sourceAndDiffsQuintsOnly
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/10/2026 22:25'
}
MorseCodeItemHolder >> definition [

	self item ifNil: [^ nil].
	self isDivergent ifTrue: [^ nil].
	
	^ self item definition
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 22:58'
}
MorseCodeItemHolder >> diff [

	^ diff
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/10/2026 22:25'
}
MorseCodeItemHolder >> diff: aDiff [

	diff := aDiff.
	
	self isDivergent ifTrue: [self itemChanged].
	self changed: #messageListSingleton; changed: #singletonIndex.
]

{
	#category : #diffs,
	#'squeak_changestamp' : 'ct 2/10/2026 22:01'
}
MorseCodeItemHolder >> diffFromPriorSourceFor: sourceCode [ 

	| prior diffBuilderClass |
	prior := self priorSourceOrNil ifNil: [^ sourceCode].
	diffBuilderClass := self isShowingClass ifTrue: [ClassDiffBuilder] ifFalse: [TextDiffBuilder].
	self previewItem ifNil:
		[^ diffBuilderClass
			buildDisplayPatchFrom: prior
			to: sourceCode
			inClass: self selectedClass
			prettyDiffs: (self showingPrettyDiffs and: [self isShowingClass not])].
	
	^ (diffBuilderClass from: sourceCode to: prior)
		morseBuildNewOnlyPatchWithAttributes: true withPrefixes: false
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:11'
}
MorseCodeItemHolder >> divergentContents [

	^ Text streamContents: [:stream |
		stream
			nextPutAll: self divergentHeader;
			cr; cr;
			nextPutAll: self divergentDiff]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 23:13'
}
MorseCodeItemHolder >> divergentDiff [

	| diffBuilderClass localSource remoteSource |
	localSource := self diff newLocal ifNotNil: #source ifNil: [''].
	remoteSource := self diff newRemote ifNotNil: #source ifNil: [''].
	
	((#(prettyPrint prettyDiffs) includes: self contentsSymbol) and: [self isShowingMethod])
		ifTrue:
			[localSource := self localSelectedClass prettyPrinterClass
				format: localSource
				in: self localSelectedClass
				notifying: nil.
			remoteSource := self localSelectedClass prettyPrinterClass
				format: remoteSource
				in: self localSelectedClass
				notifying: nil].
	
	diffBuilderClass := self isShowingClass ifTrue: [ClassDiffBuilder] ifFalse: [TextDiffBuilder].
	^ diffBuilderClass
		morseBuildTwoSiteDisplayPatchForLocal: localSource
		remote: remoteSource
		inClass: self selectedClass
		prettyDiffs: (self showingPrettyDiffs and: [self isShowingClass not])
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:11'
}
MorseCodeItemHolder >> divergentHeader [

	^ 'Divergent versions. View {1} or {2}?' asText
		addAttribute: TextEmphasis italic;
		format:
			{'split diff' asText
				addAttribute: (PluggableTextAttribute evalBlock: [self triggerEvent: #showSplitDiff]);
				yourself.
			'sources' asText
				addAttribute: (PluggableTextAttribute evalBlock: [self triggerEvent: #offerDisplayMenu]);
				yourself}
]

{
	#category : #'code pane',
	#'squeak_changestamp' : 'ct 2/9/2026 18:53'
}
MorseCodeItemHolder >> edit [

	self changed: #inputRequested with: #contents.
]

{
	#category : #'code pane',
	#'squeak_changestamp' : 'ct 2/13/2026 19:00'
}
MorseCodeItemHolder >> edit: newDefinition [

	self editBlock value:
		(newDefinition ifNotNil:
			[newDefinition asMorseItemIn: self project]).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 18:44'
}
MorseCodeItemHolder >> editBlock [

	^ editBlock
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 18:44'
}
MorseCodeItemHolder >> editBlock: aBlock [

	editBlock := aBlock.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/10/2026 21:57'
}
MorseCodeItemHolder >> editableDefinition [

	^ self definition
		ifNil: [self diff anyItem definition]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 02:33'
}
MorseCodeItemHolder >> environment [

	^ (self oldItem ifNil: [self project ifNil: [self item]]) environment
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 19:20'
}
MorseCodeItemHolder >> hasEdited [

	^ self diff isEdit
		and: [self siteName = #local ==> [self diff isEditForLocal]]
		and: [self siteName = #remote ==> [self diff isEditForRemote]]
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 19:46'
}
MorseCodeItemHolder >> hasSiteName [

	^ self siteName notNil
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/10/2026 22:24'
}
MorseCodeItemHolder >> isDivergent [

	^ self item = #divergent
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/4/2026 00:03'
}
MorseCodeItemHolder >> isShowingClass [

	^ (self definition ifNil: [^ false]) isClassDefinition
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 20:09'
}
MorseCodeItemHolder >> isShowingMethod [

	^ (self definition ifNil: [^ false]) isMethodDefinition
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 05:14'
}
MorseCodeItemHolder >> item [

	^ item
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 21:57'
}
MorseCodeItemHolder >> item: aCodeItem [

	item := aCodeItem.
	
	self itemChanged.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 21:56'
}
MorseCodeItemHolder >> item: aCodeItem oldItem: anotherCodeItem [

	item := aCodeItem.
	oldItem := anotherCodeItem.
	
	self itemChanged.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/10/2026 21:24'
}
MorseCodeItemHolder >> itemChanged [

	self setContentsToForceRefetch.
	currentCompiledMethod := self isShowingMethod ifTrue:
		[(self definition actualClassIn: self environment)
			ifNotNil: [:class | class compiledMethodAt: self definition selector ifAbsent: [nil]]].
	self changed: #relabel.
	self contentsChanged.
	self changed: #messageListSingleton; changed: #singletonIndex.
	self decorateButtons.
]

{
	#category : #'item list',
	#'squeak_changestamp' : 'ct 2/10/2026 21:49'
}
MorseCodeItemHolder >> itemKey: aCharacter from: view [

	^ self messageListKey: aCharacter from: view
]

{
	#category : #'item list',
	#'squeak_changestamp' : 'ct 2/10/2026 19:56'
}
MorseCodeItemHolder >> itemMenu: menu shifted: shifted [

	^ self menu: menu for: #(itemMenu itemMenuShifted:) shifted: shifted
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 20:14'
}
MorseCodeItemHolder >> localEnvironment [

	^ self project environment
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 20:11'
}
MorseCodeItemHolder >> localSelectedClass [

	^ self localSelectedClassOrMetaClass ifNotNil: [:cls | cls theNonMetaClass]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 20:15'
}
MorseCodeItemHolder >> localSelectedClassOrMetaClass [

	^ self definition ifNotNil: [:definition | definition actualClassIn: self localEnvironment]
]

{
	#category : #'item menu',
	#'squeak_changestamp' : 'ct 2/10/2026 19:56'
}
MorseCodeItemHolder >> mainItemMenu: menu shifted: shifted [
	<itemMenu>

	^ self messageListMenu: menu shifted: shifted
]

{
	#category : #'message list menu',
	#'squeak_changestamp' : 'ct 2/9/2026 19:53'
}
MorseCodeItemHolder >> mainMessageListMenu: aMenu [
	<messageListMenuShifted: false>

	self flag: #moveUpstream. "!"
	^ aMenu
		addTranslatedList: #(
			('what to show...'			offerWhatToShowMenu));
		add: (self isBreakOnEntry ifTrue: ['<on>'] ifFalse: ['<off>']) , 'break on entry' translated
			action: #toggleBreakOnEntry;
		addTranslatedList: #(
			-
			('browse full (b)' 			browseMethodFull)
			('browse hierarchy (h)'		browseClassHierarchy)
			('browse protocol (p)'			browseFullProtocol)
			-
			('fileOut'					fileOutMessage)
			('printOut'					printOutMessage)
			('copy selector (c)'			copySelector)
			('copy reference (C)'		copyReference)
			-
			('senders of... (n)'			browseSendersOfMessages)
			('implementors of... (m)'		browseMessages)
			('inheritance (i)'			methodHierarchy)
			('versions (v)'				browseVersions)
			-
			('references... (r)'			browseVariableReferences)
			('assignments... (a)'			browseVariableAssignments)
			('class refs (N)'			browseClassRefs)
			-
			('remove method (x)'			removeMessage)
			('explore method'			exploreMethod)
			('inspect method'			inspectMethod));
		yourself
]

{
	#category : #'message list',
	#'squeak_changestamp' : 'ct 2/9/2026 19:51'
}
MorseCodeItemHolder >> messageListMenu: aMenu shifted: shifted [ 

	self flag: #moveUpstream.
	^ self menu: aMenu for: #(messageListMenu messageListMenuShifted:) shifted: shifted
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/10/2026 21:25'
}
MorseCodeItemHolder >> messageListSingleton [

	| label |
	label := self selectedClassOrMetaClassName ifNotNil: [:className |
		self selectedMessageName
			ifNil: [className]
			ifNotNil: [:messageName |
				'{1}>>{2}' format: {className. messageName}]].
	self siteName
		ifNil: [label ifNil: [^ #()]]
		ifNotNil: [:name |
			label := label
				ifNil: [name]
				ifNotNil: ['{1}: {2}' format: {name. label}]].
	self item ifNil:
		[label := label
			ifNil: ['absent']
			ifNotNil: ['{1} (absent)' format: {label}]].
	self hasEdited ifTrue:
		[label := label
			ifNil: ['*']
			ifNotNil: ['* ' , label]].
	^ {label}
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/10/2026 21:22'
}
MorseCodeItemHolder >> messageListSingletonHeightWith: builder [

	^ builder listHeight
]

{
	#category : #annotation,
	#'squeak_changestamp' : 'ct 2/9/2026 19:35'
}
MorseCodeItemHolder >> noTimeStampLabel [

	^ 'no timeStamp' translated
]

{
	#category : #misc,
	#'squeak_changestamp' : 'ct 2/9/2026 18:07'
}
MorseCodeItemHolder >> okayToAccept [

	(self showingAnyKindOfDiffs and: [self previewItem notNil]) ifTrue: [^ true].
	
	^ super okayToAccept
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 20:29'
}
MorseCodeItemHolder >> oldItem [

	^ oldItem
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 20:31'
}
MorseCodeItemHolder >> oldItem: aCodeItem [

	oldItem := aCodeItem.
	
	self changed: #oldItem.
	self showingAnyKindOfDiffs ifTrue:
		[self setContentsToForceRefetch; contentsChanged].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 23:30'
}
MorseCodeItemHolder >> previewItem [

	^ previewItem
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 23:31'
}
MorseCodeItemHolder >> previewItem: aCodeItem [

	previewItem := aCodeItem.
	
	self showingAnyKindOfDiffs ifTrue:
		[self setContentsToForceRefetch; contentsChanged].
]

{
	#category : #misc,
	#'squeak_changestamp' : 'ct 2/3/2026 01:16'
}
MorseCodeItemHolder >> priorSourceOrNil [

	^ (self oldItem ifNil: [^ '']) source
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 02:34'
}
MorseCodeItemHolder >> project [

	self diff ifNil: [^ nil].
	self siteName = #local ifTrue: [^ self diff localProject].
	self siteName = #remote ifTrue: [^ self diff remoteProject].
	^ self diff project
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:01'
}
MorseCodeItemHolder >> selectedClassName [

	^ (self definition ifNil: [(self diff anyItem ifNil: [^ nil]) definition]) className
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/10/2026 21:54'
}
MorseCodeItemHolder >> selectedClassOrMetaClass [

	^ super selectedClassOrMetaClass ifNil:
		[(self definition ifNil: [(self diff anyItem ifNil: [^ nil]) definition])
			actualClassIn: self environment]
]

{
	#category : #'message list',
	#'squeak_changestamp' : 'ct 2/10/2026 22:04'
}
MorseCodeItemHolder >> selectedMessage [

	| message |
	contents ifNotNil: [^ contents copy].
	
	self showingDecompile ifTrue: [^ self decompiledSourceIntoContents].
	
	currentCompiledMethod := self isShowingMethod ifTrue:
		[(self definition actualClassIn: self environment) ifNotNil: [:class |
			class compiledMethodAt: self definition selector ifAbsent: [nil]]].
	
	message := (self showingDocumentation
		ifFalse: [self sourceStringPrettifiedAndDiffed]
		ifTrue: [self commentContents])
			copy.
	self isShowingMethod ifTrue:
		[self localSelectedClassOrMetaClass ifNotNil: [:class |
			message := message asText makeSelectorBoldIn: class]].
	^ contents := message
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/10/2026 22:25'
}
MorseCodeItemHolder >> selectedMessageName [

	self isDivergent ifTrue: [^ self diff anyItem definition selector].
	^ super selectedMessageName
]

{
	#category : #'message list menu',
	#'squeak_changestamp' : 'ct 2/10/2026 00:44'
}
MorseCodeItemHolder >> shiftedMessageListMenu: aMenu [
	<messageListMenuShifted: true>
	"Fill aMenu with the items appropriate when the shift key is held down"

	self flag: #moveUpstream. "!"
	aMenu addStayUpItem.
	aMenu addList: #(
		('toggle diffing (D)'						toggleDiffing)
		('implementors of sent messages'			browseAllMessages)
		-
		('local senders of...'						browseLocalSendersOfMessages)
		('local implementors of...'				browseLocalImplementors)
		-
		('spawn sub-protocol'					spawnProtocol)
		('spawn full protocol'					spawnFullProtocol)
		-
		('sample instance'						makeSampleInstance)
		('inspect instances'						inspectInstances)
		('inspect subinstances'					inspectSubInstances)).

	self addExtraShiftedItemsTo: aMenu.
	aMenu addList: #(
		-
		('change category...'					changeCategory)).

	self canShowMultipleMessageCategories ifTrue: [aMenu addList:
		 #(('toggle category selection (Y)'						showHomeCategory))].
	aMenu addList: #(
		-
		('change sets with this method'			findMethodInChangeSets)
		('revert to previous version'				revertToPreviousVersion)
		('delete from current change set'		removeFromCurrentChanges)
		('revert & remove from changes'		revertAndForget)
		('add to current change set'				adoptMessageInCurrentChangeset)
		('move to other change set...'			moveMessageToOtherChangeSet)
		('copy to other change set...'			copyMessageToOtherChangeSet)
		('copy up or copy down...'				copyUpOrCopyDown)).
	^ aMenu
]

{
	#category : #diffs,
	#'squeak_changestamp' : 'ct 2/10/2026 22:25'
}
MorseCodeItemHolder >> showingAnyKindOfDiffs [

	^ super showingAnyKindOfDiffs or: [self isDivergent]
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/2/2026 18:47'
}
MorseCodeItemHolder >> singletonIndex [

	^ 1
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 19:46'
}
MorseCodeItemHolder >> siteName [

	^ siteName
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 19:46'
}
MorseCodeItemHolder >> siteName: aStringOrNil [

	siteName := aStringOrNil.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/10/2026 22:25'
}
MorseCodeItemHolder >> sourceStringPrettifiedAndDiffed [ 

	| sourceItem sourceString |
	self isDivergent ifTrue: [^ self divergentContents].
	
	sourceItem := (self showingAnyKindOfDiffs ifTrue: [self previewItem])
		ifNil: [self item].
	sourceString := sourceItem
		ifNotNil: [:codeItem | codeItem source]
		ifNil: [''].
	
	((#(prettyPrint prettyDiffs) includes: self contentsSymbol) and: [self isShowingMethod])
		ifTrue:
			[sourceString := self localSelectedClass prettyPrinterClass
				format: sourceString
				in: self localSelectedClass
				notifying: nil].
	
	self showingAnyKindOfDiffs ifTrue:
		[sourceString := self diffFromPriorSourceFor: sourceString.
		"sourceItem ~= self item ifTrue:
			[sourceString := ('diff ({1} to {2}):' asText
				addAttribute: TextEmphasis italic;
				format: {self siteName. self otherSiteName})
					, String cr , sourceString]"].
	^ sourceString
]

{
	#category : #diffs,
	#'squeak_changestamp' : 'ct 2/10/2026 22:03'
}
MorseCodeItemHolder >> toggleDiffing [

	| symbol |
	symbol := self contentsSymbol.
	
	super toggleDiffing.
	
	self contentsSymbol ~= symbol ifTrue:
		["let my owner know"
		self triggerEvent: #contentsSymbol with: self contentsSymbol].
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 18:49'
}
MorseCodeItemHolder >> wantsOptionalButtons [

	^ false
]
