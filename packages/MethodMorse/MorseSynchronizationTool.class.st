Class {
	#name : #MorseSynchronizationTool,
	#superclass : #StringHolder,
	#traits : 'TMorseAspectDependencyGraph',
	#classTraits : 'TMorseAspectDependencyGraph classTrait',
	#instVars : [
		'task',
		'morser',
		'selectedDiff',
		'displayMode',
		'contentsSymbolQuint',
		'itemModel',
		'localItemModel',
		'remoteItemModel'
	],
	#category : #'MethodMorse-UI'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/11/2026 17:21'
}
MorseSynchronizationTool class >> on: aSynchronizationTask morser: aMorser [

	^ self new
		task: aSynchronizationTask;
		morser: aMorser;
		yourself
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/11/2026 17:21'
}
MorseSynchronizationTool class >> openOn: aSynchronizationTask withMorser: aMorser [

	^ (self on: aSynchronizationTask morser: aMorser) open
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'ct 2/10/2026 23:27'
}
MorseSynchronizationTool class >> themeProperties [

	^ super themeProperties,
		{ { #unresolvedItemAttributes. 'Colors' . 'Text attributes to use for unresolved diffs in Method Morse Synchronization.' }.
		{ #ignoredItemAttributes. 'Colors' . 'Text attributes to use for ignored diffs in Method Morse Synchronization.' } }
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 19:55'
}
MorseSynchronizationTool >> apply [

	self okToChange ifFalse: [^ self].
	
	self unresolvedDiffs ifNotEmpty: [:unresolvedDiffs |
		(self confirm: 'Ignore unresolved changes?') ifFalse: [^ self].
		unresolvedDiffs do: #ignore].
	
	((self diffs anySatisfy: [:diff | diff isIgnored and: [diff isEdit]]) ==>
		[self confirm: 'Some items have been edited but ignored. Continue and discard these edits?'])
			ifFalse: [^ self].
	
	self close.
	self task applyWith: self morser.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/2/2026 23:37'
}
MorseSynchronizationTool >> aspectDependencies [

	^ Dictionary new
		"Model"
		at: #windowTitle put: #(#labelString);
		
		at: #selectedDiffStrategy put: #(selectedDiff);
		yourself
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/3/2026 01:04'
}
MorseSynchronizationTool >> assureItemModelForSite: siteOrNil [

	siteOrNil ifNil: [^ self itemModel].
	siteOrNil = #local ifTrue: [^ self localItemModel].
	siteOrNil = #remote ifTrue: [^ self remoteItemModel].
	^ siteOrNil caseError
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/9/2026 18:41'
}
MorseSynchronizationTool >> basicEditDiff: diff with: newItem forSite: siteOrNil [

	siteOrNil ifNil: [^ diff edit: newItem].
	siteOrNil = #local ifTrue: [^ diff editLocal: newItem].
	siteOrNil = #remote ifTrue: [^ diff editRemote: newItem].
	^ siteOrNil caseError
]

{
	#category : #'actions - private',
	#'squeak_changestamp' : 'ct 2/11/2026 00:03'
}
MorseSynchronizationTool >> basicToggleChooseLocal: aDiff [

	(aDiff isEdit ==> [self confirmDiscardEdits]) ifFalse: [^ false].
	
	(self hasChosenLocal: aDiff)
		ifTrue: [^ self basicUnresolveDiff: aDiff]
		ifFalse: [self chooseLocal: aDiff].
	
	aDiff = self selectedDiff ifTrue:
		[self selectedDiffStrategyChanged].
	^ true
]

{
	#category : #'actions - private',
	#'squeak_changestamp' : 'ct 2/11/2026 00:03'
}
MorseSynchronizationTool >> basicToggleChooseRemote: aDiff [

	(aDiff isEdit ==> [self confirmDiscardEdits]) ifFalse: [^ false].
	
	(self hasChosenRemote: aDiff)
		ifTrue: [^ self basicUnresolveDiff: aDiff]
		ifFalse: [self chooseRemote: aDiff].
	
	aDiff = self selectedDiff ifTrue:
		[self selectedDiffStrategyChanged].
	^ true
]

{
	#category : #'actions - private',
	#'squeak_changestamp' : 'ct 2/10/2026 00:18'
}
MorseSynchronizationTool >> basicToggleIgnore: aDiff [

	aDiff isIgnored: aDiff isIgnored not.
	self changed: #diffStrategies.
	
	^ true
]

{
	#category : #'actions - private',
	#'squeak_changestamp' : 'ct 2/10/2026 20:36'
}
MorseSynchronizationTool >> basicUnresolveDiff: aDiff [

	(aDiff isEdit ==> [self confirmDiscardEdits]) ifFalse: [^ false].
	
	aDiff unresolve.
	
	self changed: #diffStrategies.
	aDiff = self selectedDiff ifTrue:
		[self selectedDiffStrategyChanged].
	
	^ true
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/21/2026 02:15'
}
MorseSynchronizationTool >> browseRemoteItem [

	^ (self remoteItemModel ifNil: [^ self changed: #flash]) browse
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 18:36'
}
MorseSynchronizationTool >> buildActualContentPaneWith: builder [

	^ builder pluggablePanelSpec new
		model: self;
		children: #buildContents;
		yourself
]

{
	#category : #'toolbuilder - private',
	#'squeak_changestamp' : 'ct 2/2/2026 23:38'
}
MorseSynchronizationTool >> buildButtonsWith: builder specs: specs [

	^ specs collect: [:spec |
		| buttonSpec |
		buttonSpec := builder pluggableActionButtonSpec new.
		buttonSpec model: self.
		buttonSpec label: spec first.
		buttonSpec action: spec second.
		spec size >= 3 ifTrue:
			[buttonSpec help: spec third.
			 spec size >= 4 ifTrue:
				[buttonSpec enabled: spec fourth.
				spec size >= 5 ifTrue:
					[buttonSpec state: spec fifth]]].
		buttonSpec]
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/9/2026 23:40'
}
MorseSynchronizationTool >> buildContentButtonRowWith: builder [

	^ builder pluggablePanelSpec new
		layout: #horizontal;
		children:
			(self
				buildButtonsWith: builder
				specs: self contentButtonSpecs)
					, (Array
						with: builder pluggableSpacerSpec new
						with:  (self buildDisplayButtonWith: builder));
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 18:39'
}
MorseSynchronizationTool >> buildContentPaneWith: builder [

	^ builder pluggablePanelSpec new
		children:
			(Array
				with:
					((self buildContentButtonRowWith: builder)
						frame: (LayoutFrame fullFrame bottomFraction: 0; bottomOffset: (self contentButtonRowHeightWith: builder); yourself))
				with:
					((self buildActualContentPaneWith: builder)
						frame: (LayoutFrame fullFrame topOffset: (self contentButtonRowHeightWith: builder); yourself)));
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 00:29'
}
MorseSynchronizationTool >> buildContentWith: builder [
	<uses: #(displayMode itemModels)>

	^ self
		perform: (self displayModeSpecs at: self displayMode) third
		with: builder
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 05:10'
}
MorseSynchronizationTool >> buildContents [
	<uses: #buildContentWith:>

	| builder spec |
	builder := Project uiManager toolBuilder.
	spec := self buildContentWith: builder.
	spec frame: LayoutFrame fullFrame.
	^ {builder build: spec}
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/10/2026 22:49'
}
MorseSynchronizationTool >> buildDiffTableWith: builder [

	^ builder pluggableMultiColumnListSpec new
		model: self;
		name: #diffTable;
		list: #diffColumns;
		menu: #diffMenu:shifted:;
		keyPress: #diffKey:from:;
		getIndex: #diffSelectionIndex;
		setIndex: #diffSelectionIndex:;
		columnResizings: #(rigid rigid rigid spaceFill);
		itemPaddings: {3 @ 0. 3 @ 0. 3 @ 0. 3 @ 0};
			flag: #todo; "should this (and PluggableMultiColumnListMorph>>#cellInsetAtColumn:) use #px, or should PluggableMultiColumnListMorph>>#updateColumns use #px?"
		itemAlignments: #(left center left left);
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 05:18'
}
MorseSynchronizationTool >> buildDisplayButtonWith: builder [

	^ builder pluggableActionButtonSpec new
		model: self;
		style: #menuButton;
		label: #displayLabel;
		action: #offerDisplayMenu;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/9/2026 23:39'
}
MorseSynchronizationTool >> buildHeaderRowWith: builder [

	^ builder pluggablePanelSpec new
		layout: #horizontal;
		children:
			(self
				buildButtonsWith: builder
				specs: self headerButtonSpecs);
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/3/2026 01:00'
}
MorseSynchronizationTool >> buildSingleContentWith: builder [

	^ self buildSingleContentWith: builder for: self itemModel
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 00:31'
}
MorseSynchronizationTool >> buildSingleContentWith: builder for: someItemModel [

	^ someItemModel
		ifNil: [self buildCodePaneWith: builder]
		ifNotNil: [someItemModel buildPaneWith: builder]
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/3/2026 00:02'
}
MorseSynchronizationTool >> buildSplitContentWith: builder [
	<uses: #(localItemModel remoteItemModel)>

	| panel |
	panel := builder pluggablePanelSpec new
		children: OrderedCollection new;
		wantsResizeHandles: true;
		yourself.
	^ self
		buildWindow: panel
		with: builder
		specs:
			(Array
				with:
					(LayoutFrame fullFrame rightFraction: 0.5; ->
						[self buildSingleContentWith: builder for: self localItemModel])
				with:
					(LayoutFrame fullFrame leftFraction: 0.5; ->
						[self buildSingleContentWith: builder for: self remoteItemModel]))
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/10/2026 21:31'
}
MorseSynchronizationTool >> buildWith: builder [

	| windowSpec window |
	windowSpec := self buildWindowWith: builder specs:
		{LayoutFrame new rightFraction: 1; bottomOffset: (self headerRowHeightWith: builder); ->
			[self buildHeaderRowWith: builder].
		LayoutFrame fullFrame topOffset: (self headerRowHeightWith: builder); bottomFraction: self tableFraction; ->
			[self buildDiffTableWith: builder].
		LayoutFrame new rightFraction: 1; topFraction: self tableFraction; bottomFraction: 1; ->
			[self buildContentPaneWith: builder]}.
	window := builder build: windowSpec.
	(builder widgetAt: #diffTable) in: [:table |
		self flag: #todo. "do not hardcode???"
		table listMorphs first width: (table listMorphs first font widthOfString: 'local: ABC 12/31/2026 12:34') + (table cellInsetAtColumn: 1) x.
		table listMorphs second width: (table listMorphs first font widthOfString: '(...)') + (table cellInsetAtColumn: 2) x.
		table listMorphs third width: (table listMorphs third font widthOfString: 'remote: ABC 12/31/2026 12:34') + (table cellInsetAtColumn: 3) x].
	^ window
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:49'
}
MorseSynchronizationTool >> canApply [
	<uses: #hasUnresolvedDiffs>

	^ self hasUnresolvedDiffs not
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/3/2026 01:00'
}
MorseSynchronizationTool >> changed: aspect [

	super changed: aspect.
	
	(#(selectedDiff displayMode) includes: aspect) ifTrue:
		[(self reinstallItemModelIfNeededForSite: nil)
			| (self reinstallItemModelIfNeededForSite: #local)
			| (self reinstallItemModelIfNeededForSite: #remote)
				ifTrue: [self changed: #itemModels]].
	
	(self dependentAspectsOn: aspect)
		do: [:dependentAspect | self changedDependent: dependentAspect].
]

{
	#category : #'actions - private',
	#'squeak_changestamp' : 'ct 2/10/2026 00:03'
}
MorseSynchronizationTool >> chooseLocal: aDiff [

	aDiff chooseLocal.
	
	self changed: #diffStrategies.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 22:29'
}
MorseSynchronizationTool >> chooseRemainingLocal [

	| changeSelected |
	changeSelected := self selectedDiff ifNotNil: [:diff | diff isUnresolved] ifNil: [false].
	changeSelected ==> [self okToChange] ifFalse: [^ self].
	
	self unresolvedDiffs do: [:ea |
		ea chooseLocal].
	
	self changed: #diffStrategies.
	changeSelected ifTrue:
		[self selectedDiffStrategyChanged].
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 21:44'
}
MorseSynchronizationTool >> chooseRemainingNewer [

	| changeSelected |
	changeSelected := self selectedDiff ifNotNil: [:diff | diff isUnresolved] ifNil: [false].
	changeSelected ==> [self okToChange] ifFalse: [^ self].
	
	self unresolvedDiffs do: [:ea |
		ea chooseNewer].
	
	self changed: #diffStrategies.
	changeSelected ifTrue:
		[self selectedDiffStrategyChanged].
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 22:29'
}
MorseSynchronizationTool >> chooseRemainingRemote [

	| changeSelected |
	changeSelected := self selectedDiff ifNotNil: [:diff | diff isUnresolved] ifNil: [false].
	changeSelected ==> [self okToChange] ifFalse: [^ self].
	
	self unresolvedDiffs do: [:ea |
		ea chooseRemote].
	
	self changed: #diffStrategies.
	changeSelected ifTrue:
		[self selectedDiffStrategyChanged].
]

{
	#category : #'actions - private',
	#'squeak_changestamp' : 'ct 2/10/2026 00:09'
}
MorseSynchronizationTool >> chooseRemote: aDiff [

	aDiff chooseRemote.
	
	self changed: #diffStrategies.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 16:59'
}
MorseSynchronizationTool >> close [

	self flag: #moveUpstream. "see Debugger"
	self topView
		ifNotNil: [self changed: #close]
		ifNil: [
			self okToClose ifTrue: [
				self windowIsClosing; release]].
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/9/2026 22:15'
}
MorseSynchronizationTool >> confirmDiscardEdits [

	^ self confirm: 'Version was edited. Discard edits?'
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 18:41'
}
MorseSynchronizationTool >> contentButtonRowHeightWith: builder [

	^ builder buttonRowHeight
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/10/2026 19:39'
}
MorseSynchronizationTool >> contentButtonSpecs [ 

	^ self strategySpecs
		select: [:spec |
			spec ~= #- and:
				[spec at: 5 ifPresent: [:roles | roles isEmpty] ifAbsent: [true]]]
		thenCollect: [:spec |
			{spec first.
			spec third asSimpleGetter.
			spec fourth ifNotNil: [:char | '{1} ({2})' format: {spec first. spec fourth}].
			#hasDiffSelected.
			spec second asSimpleGetter}]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 01:45'
}
MorseSynchronizationTool >> contentsSymbol [
	<uses: #contentsSymbolQuint>

	^ self contentsSymbolQuint first
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/10/2026 21:06'
}
MorseSynchronizationTool >> contentsSymbol: aSymbol [

	self contentsSymbolQuint:
		(self defaultContentsSymbolQuintFor: aSymbol).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 01:44'
}
MorseSynchronizationTool >> contentsSymbolQuint [

	^ contentsSymbolQuint
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 01:47'
}
MorseSynchronizationTool >> contentsSymbolQuint: quint [

	contentsSymbolQuint := quint.
	
	self itemModels do: [:model |
		model contentsSymbol = self contentsSymbol ifFalse:
			[model perform: self contentsSymbolSetter]].
	
	self changed: #contentsSymbolQuint.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 01:40'
}
MorseSynchronizationTool >> contentsSymbolSetter [

	^ self contentsSymbolQuint second
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/10/2026 21:03'
}
MorseSynchronizationTool >> defaultContentsSymbolQuint [

	^ self defaultDiffContentsSymbolQuint
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/10/2026 21:06'
}
MorseSynchronizationTool >> defaultContentsSymbolQuintFor: aSymbol [

	| dummy |
	dummy := CodeHolder new.
	^ dummy contentsSymbolQuints detect: [:quint | quint first = aSymbol]
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/10/2026 21:03'
}
MorseSynchronizationTool >> defaultDiffContentsSymbolQuint [

	| dummy |
	dummy := CodeHolder new.
	^ dummy contentsSymbolQuints detect: [:quint | quint first = dummy defaultDiffsSymbol]
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/3/2026 02:18'
}
MorseSynchronizationTool >> defaultDisplayMode [

	^ #split
]

{
	#category : #'toolbuilder - constants',
	#'squeak_changestamp' : 'ct 2/2/2026 17:54'
}
MorseSynchronizationTool >> defaultWindowColor [

	^ self uniformWindowColor
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/10/2026 23:24'
}
MorseSynchronizationTool >> diffColumnBlocks [

	| blocks |
	blocks := Array
		with: [:diff | | label |
			label := self diffItemLocalLabelFor: diff.
			diff isIgnored ifTrue:
				[label := '( ' asText , label].
			label]
		with: [:diff | | label |
			label := self strategyLabelFor: diff.
			label := self formatDiffColumnLabel: label for: diff.
			label]
		with: [:diff | self diffItemRemoteLabelFor: diff]
		with: [:diff | | label |
			label := diff name.
			diff isIgnored ifTrue:
				[label := label , ' )'].
			label].
	^ blocks withIndexCollect: [:block :index |
		[:diff | | label |
			label := block value: diff.
			label := self formatDiffColumnLabel: label for: diff.
			index = 2 "strategy label" ifTrue:
				[label isText ifTrue:
					[label removeAttributesThat: [:attr | attr isKindOf: TextEmphasis]]].
			label]]
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/10/2026 00:01'
}
MorseSynchronizationTool >> diffColumns [
	<uses: #diffStrategies>

	^ self diffColumnBlocks collect: [:block |
		self diffs collect: block]
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/10/2026 22:13'
}
MorseSynchronizationTool >> diffItemLocalLabelFor: aDiff [

	| label |
	label := ((aDiff isEditForLocal ifTrue: [aDiff newLocal] ifFalse: [aDiff local])
		ifNil: ['absent'] ifNotNil: [:item | item timeStamp])
			ifNil: ['local']
			ifNotNil: [:stamp | 'local ({1})' format: {stamp}].
	aDiff isEditForLocal ifTrue:
		[label := '* ' , label].
	^ label asText
		addAllAttributes: aDiff strategy attributesForLocalLabel;
		yourself
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/21/2026 02:14'
}
MorseSynchronizationTool >> diffItemMenu: menu shifted: aBoolean [
	<diffMenu>
	<menuPriority: 600>

	| builder |
	aBoolean ifTrue:
		[menu add: 'toggle split view (S)' action: #toggleSplitView].
	menu addLine.
	
	self hasDiffSelected ifFalse: [^ menu].
	
	builder := Project uiManager toolBuilder.
	(self itemModels first: 1) "local" do: [:model |
		| tmpMenu |
		tmpMenu := builder pluggableMenuSpec new.
		tmpMenu model: model.
		tmpMenu := model itemMenu: tmpMenu shifted: aBoolean.
		tmpMenu items removeAllSuchThat: [:item | item contents = 'more...'].
		menu addAllFrom: (builder buildPluggableMenu: tmpMenu)].
	
	aBoolean ifFalse:
		[menu addLine.
		menu add: 'browse remote' action: #browseRemoteItem].
	^ menu
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/10/2026 22:14'
}
MorseSynchronizationTool >> diffItemRemoteLabelFor: aDiff [

	| label |
	label := ((aDiff isEditForRemote ifTrue: [aDiff newRemote] ifFalse: [aDiff remote])
		ifNil: ['absent'] ifNotNil: [:item | item timeStamp])
			ifNil: ['remote']
			ifNotNil: [:stamp | 'remote ({1})' format: {stamp}].
	aDiff isEditForRemote ifTrue:
		[label := '* ' , label].
	^ label asText
		addAllAttributes: aDiff strategy attributesForRemoteLabel;
		yourself
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/10/2026 20:21'
}
MorseSynchronizationTool >> diffKey: aCharacter from: view [

	self diffKeyTable at: aCharacter ifPresent: [:action | ^ action value].
	^ self itemModels anySatisfy: [:model |
		(model itemKey: aCharacter from: view) ~~ false]
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/11/2026 19:55'
}
MorseSynchronizationTool >> diffKeyTable [

	^ ((self strategySpecs copyWithout: #-)
		collect: [:spec | spec fourth -> (MessageSend receiver: self selector: spec third asSimpleGetter)]
		as: Dictionary)
			at: $s put: [(self confirm: 'Apply changes now?') ifTrue: [self apply]];
			at: $S put: (MessageSend receiver: self selector: #toggleSplitView);
			yourself
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/10/2026 19:30'
}
MorseSynchronizationTool >> diffMenu: menu shifted: shifted [

	^ self menu: menu for: #(diffMenu diffMenuShifted:) shifted: shifted
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/21/2026 22:19'
}
MorseSynchronizationTool >> diffMenuMore: aMenu [
	<diffMenuShifted: false>
	<menuPriority: 1000>

	^ aMenu
		addLine;
		add: 'more...' action: #offerShiftedDiffMenu;
		yourself

]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/11/2026 16:47'
}
MorseSynchronizationTool >> diffMetaMenu: menu [
	<diffMenuShifted: true>

	self selectedDiff
		ifNotNil: [:diff |
			menu add: 'inspect diff' target: diff selector: #inspect]
		ifNil:
			[menu add: 'inspect synchronization task' target: self task selector: #inspect].
	^ menu
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/2/2026 04:28'
}
MorseSynchronizationTool >> diffSelectionIndex [
	<uses: #selectedDiff>

	^ self diffs indexOf: self selectedDiff
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/2/2026 04:24'
}
MorseSynchronizationTool >> diffSelectionIndex: anInteger [

	self selectDiff:
		(self diffs at: anInteger ifAbsent: [nil]).
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/11/2026 16:54'
}
MorseSynchronizationTool >> diffStrategyMenu: menu [
	<diffMenuShifted: false>
	<menuPriority: 400>

	self selectedDiff
		ifNotNil: [:diff |
			self
				strategyMenu: menu
				for: diff
				roles: #(menu mainMenu)
				showShortcuts: true]
		ifNil:
			[menu add: 'ignore all (I)' action: #toggleIgnoreAll].
	^ menu
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 04:09'
}
MorseSynchronizationTool >> diffs [
	<uses: #task>

	^ self task diffs
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/3/2026 01:44'
}
MorseSynchronizationTool >> displayLabel [
	<uses: #(contentsSymbol displayMode itemModels)>

	| displaySpec modelLabels |
	displaySpec := self displayModeSpecs at: self displayMode.
	modelLabels := (self itemModels collect: #codePaneProvenanceString) asSet.
	^ displaySpec second format:
		{modelLabels size = 1
			ifTrue: [modelLabels anyOne]
			ifFalse: [self contentsSymbolQuint fourth]}
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/10/2026 22:43'
}
MorseSynchronizationTool >> displayMenu: menu [

	self displayModeSpecs keysAndValuesDo: [:mode :spec |
		((self itemModels gather: #contentsSymbolQuints) withoutDuplicates)
			ifEmpty:
				[menu
					morseAdd: spec first
					getState: [self displayMode = mode]
					setState: [self displayMode: mode]]
			ifNotEmpty: [:quints |
				menu addLine.
				quints do: [:quint |
					quint = #- ifFalse:
						[menu
							morseAdd: (spec second format: {quint fourth})
							getState:
								[self displayMode = mode and:
									[self itemModels anySatisfy: [:model |
										model contentsSymbol = quint first]]]
							setState:
								[(self displayMode: mode) ifTrue:
									[self contentsSymbolQuint: quint]].
						menu balloonTextForLastItem: (spec fourth format: {quint fifth})]].
				menu addLine]].
	^ menu
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 05:25'
}
MorseSynchronizationTool >> displayMode [

	^ displayMode
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/9/2026 23:02'
}
MorseSynchronizationTool >> displayMode: aSymbol [

	self okToChange ifFalse: [^ false].
	
	displayMode := aSymbol.
	self changed: #displayMode.
	
	^ true
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/2/2026 19:30'
}
MorseSynchronizationTool >> displayModeSpecs [

	^ OrderedDictionary new
		at: #single put: #('single' '{1}' buildSingleContentWith: '{1}');
		at: #split put: #('split' 'split {1}' buildSplitContentWith: 'split view - {1}');
		yourself
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/10/2026 20:31'
}
MorseSynchronizationTool >> editDiff: diff with: newItem forSite: siteOrNil [

	self basicEditDiff: diff with: newItem forSite: siteOrNil.
	self changed: #diffStrategies.
	self selectedDiffStrategyChanged.
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/10/2026 23:22'
}
MorseSynchronizationTool >> formatDiffColumnLabel: aStringOrText for: aDiff [

	| label |
	label := aStringOrText.
	aDiff isUnresolved ifTrue:
		[label := label asText
			addAllAttributes:
				(self userInterfaceTheme unresolvedItemAttributes ifNil: [{TextEmphasis bold}]);
			yourself].
	aDiff isIgnored ifTrue:
		[label := label asText
			addAllAttributes:
				(self userInterfaceTheme ignoredItemAttributes ifNil: [{TextColor gray}]);
			yourself].
	^ label
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:52'
}
MorseSynchronizationTool >> hasAnyEdits [
	<uses: #(diffs diffStrategies)>

	^ self diffs anySatisfy: #isEdit
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 23:53'
}
MorseSynchronizationTool >> hasChosenLocal [
	<uses: #selectedDiffStrategy>

	^ self hasChosenLocal: (self selectedDiff ifNil: [^ false])
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 23:53'
}
MorseSynchronizationTool >> hasChosenLocal: aDiff [

	^ aDiff strategy isLocal
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 23:53'
}
MorseSynchronizationTool >> hasChosenRemote [
	<uses: #selectedDiffStrategy>

	^ self hasChosenRemote: (self selectedDiff ifNil: [^ false])
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 23:53'
}
MorseSynchronizationTool >> hasChosenRemote: aDiff [

	^ aDiff strategy isRemote
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 23:36'
}
MorseSynchronizationTool >> hasDiffSelected [
	<uses: #selectedDiff>

	^ self selectedDiff notNil
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 23:54'
}
MorseSynchronizationTool >> hasEdited [
	<uses: #selectedDiffStrategy>

	^ self hasEdited: (self selectedDiff ifNil: [^ false])
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 23:54'
}
MorseSynchronizationTool >> hasEdited: aDiff [

	^ aDiff strategy isEdit
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:52'
}
MorseSynchronizationTool >> hasUnresolvedDiffs [
	<uses: #(diffs diffStrategies)>

	^ self diffs anySatisfy: #isUnresolved
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 16:52'
}
MorseSynchronizationTool >> headerButtonSpecs [

	^ #(
		('Apply' apply nil canApply)
		('Choose remaining local' chooseRemainingLocal)
		('Choose remaining remote' chooseRemainingRemote)
		('Choose remaining newer' chooseRemainingNewer)
		('Ignore remaining' ignoreRemaining)
	)
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 03:53'
}
MorseSynchronizationTool >> headerRowHeightWith: builder [

	^ builder buttonRowHeight
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 16:53'
}
MorseSynchronizationTool >> ignoreRemaining [

	self unresolvedDiffs do: [:ea |
		ea ignore].
	
	self changed: #diffStrategies.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 05:59'
}
MorseSynchronizationTool >> initialExtent [

	^ 850 @ 450
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/10/2026 21:03'
}
MorseSynchronizationTool >> initialize [

	super initialize.
	
	self selectDiff: nil.
	self displayMode: self defaultDisplayMode.
	self contentsSymbolQuint: self defaultContentsSymbolQuint.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/10/2026 00:23'
}
MorseSynchronizationTool >> isIgnored: aDiff [

	^ aDiff isIgnored
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/3/2026 02:17'
}
MorseSynchronizationTool >> itemForItemModelForSite: siteOrNil [

	| diff |
	diff := self selectedDiff ifNil: [^ nil].
	siteOrNil ifNil: [^ diff newItem].
	siteOrNil = #local ifTrue: [^ diff newLocal].
	siteOrNil = #remote ifTrue: [^ diff newRemote].
	^ siteOrNil caseError
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 01:26'
}
MorseSynchronizationTool >> itemModel [

	^ itemModel ifNil: [itemModel := self newItemModelForSite: nil]
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/3/2026 00:53'
}
MorseSynchronizationTool >> itemModelForSite: siteOrNil [

	siteOrNil ifNil: [^ itemModel].
	siteOrNil = #local ifTrue: [^ localItemModel].
	siteOrNil = #remote ifTrue: [^ remoteItemModel].
	^ siteOrNil caseError
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 01:34'
}
MorseSynchronizationTool >> itemModels [ 

	^ (self visibleItemModelSites collect: [:site |
		self itemModelForSite: site])
			copyWithout: nil
]

{
	#category : #'toolbuilder - constants',
	#'squeak_changestamp' : 'ct 2/9/2026 22:54'
}
MorseSynchronizationTool >> labelString [

	^ '{1} Synchronization' format: {MethodMorserTool appName}
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 01:26'
}
MorseSynchronizationTool >> localItemModel [

	^ localItemModel ifNil: [localItemModel := self newItemModelForSite: #local]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 17:21'
}
MorseSynchronizationTool >> morser [

	^ morser
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 17:21'
}
MorseSynchronizationTool >> morser: aMorser [

	morser := aMorser.
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/22/2026 00:59'
}
MorseSynchronizationTool >> newItemModelForSite: siteOrNil [

	| diff model |
	diff := self selectedDiff ifNil: [^ nil].
	
	model := ((self itemForItemModelForSite: siteOrNil)
		ifNotNil: [:item | item = #divergent ifFalse: [diff project newItemContentModelFor: item]])
			ifNil: [diff project newItemContentModel].
	model siteName: siteOrNil.
	model
		when: #showSplitDiff send: #showSplitDiff to: self;
		when: #offerDisplayMenu send: #offerDisplayMenu to: self;
		when: #contentsSymbol send: #contentsSymbol: to: self.
	
	self updateItemModel: model forSite: siteOrNil.
	model contentsSymbol = self contentsSymbol ifFalse:
		[(model respondsTo: self contentsSymbolSetter) ifTrue:
			[model perform: self contentsSymbolSetter]].
	^ model
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/2/2026 05:21'
}
MorseSynchronizationTool >> offerDisplayMenu [

	^ self offerMenu: [:menu | self displayMenu: menu]
]

{
	#category : #'toolbuilder - private',
	#'squeak_changestamp' : 'ct 2/2/2026 05:21'
}
MorseSynchronizationTool >> offerMenu: menuBlock [

	| builder menu |
	builder := Project uiManager toolBuilder.
	menu := builder menuClass new.
	menu := menuBlock value: menu.
	^ builder runModal: (builder open: menu)
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/10/2026 20:05'
}
MorseSynchronizationTool >> offerShiftedDiffMenu [

	^ self offerMenuFrom: #diffMenu:shifted: shifted: true
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/9/2026 23:37'
}
MorseSynchronizationTool >> offerStrategyMenuFor: aDiff [

	^ self offerMenu: [:menu | self strategyMenu: menu for: aDiff]
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/10/2026 20:05'
}
MorseSynchronizationTool >> offerUnshiftedDiffMenu [

	^ self offerMenuFrom: #diffMenu:shifted: shifted: false
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/9/2026 22:12'
}
MorseSynchronizationTool >> okToChange [

	^ super okToChange and:
		[self itemModels allSatisfy: [:ea | ea okToChange]]
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/9/2026 22:20'
}
MorseSynchronizationTool >> okToClose [

	^ super okToClose and:
		[self okToDiscardEdits]
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/9/2026 22:20'
}
MorseSynchronizationTool >> okToDiscardEdits [

	^ self hasAnyEdits ==> [self confirm: 'Discard edited versions?']
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/3/2026 02:12'
}
MorseSynchronizationTool >> oldItemForItemModelForSite: siteOrNil [

	| diff |
	diff := self selectedDiff ifNil: [^ nil].
	siteOrNil ifNil: [^ diff oldItem].
	siteOrNil = #local ifTrue: [^ diff local].
	siteOrNil = #remote ifTrue: [^ diff remote].
	^ siteOrNil caseError
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 03:48'
}
MorseSynchronizationTool >> open [

	^ ToolBuilder open: self
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/3/2026 23:29'
}
MorseSynchronizationTool >> previewItemForItemModelForSite: siteOrNil [

	| diff |
	diff := self selectedDiff ifNil: [^ nil].
	siteOrNil ifNil: [^ nil].
	diff isResolved ifTrue: [^ nil].
	siteOrNil = #local ifTrue: [^ diff remote].
	siteOrNil = #remote ifTrue: [^ diff local].
	^ siteOrNil caseError
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/3/2026 01:00'
}
MorseSynchronizationTool >> reinstallItemModelIfNeededForSite: siteOrNil [

	| existingModel newModel |
	existingModel := (self itemModelForSite: siteOrNil) ifNil: [^ false].
	newModel := self newItemModelForSite: siteOrNil.
	newModel class = existingModel class ifTrue:
		[self updateItemModelForSite: siteOrNil.
		^ false].
	existingModel windowIsClosing; release.
	self setItemModelForSite: siteOrNil to: newModel.
	^ true
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 01:26'
}
MorseSynchronizationTool >> remoteItemModel [

	^ remoteItemModel ifNil: [remoteItemModel := self newItemModelForSite: #remote]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 01:09'
}
MorseSynchronizationTool >> selectDiff: aDiff [

	selectedDiff := aDiff.
	self changed: #selectedDiff.
	
	(self visibleItemModelSites
		select: [:site | (self itemModelForSite: site) isNil])
			do: [:site | self assureItemModelForSite: site];
			ifNotEmpty: [self changed: #itemModels].
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 21:53'
}
MorseSynchronizationTool >> selectNextDiff [

	^ self selectNextDiffThat: [:diff | true]
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 21:53'
}
MorseSynchronizationTool >> selectNextDiffThat: aBlock [

	| next |
	next := (self hasDiffSelected ifFalse: [self diffs] ifTrue: [self diffs copyAfter: self selectedDiff])
		detect: aBlock
		ifNone: [^ self].
	self selectDiff: next.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 21:54'
}
MorseSynchronizationTool >> selectNextUnresolvedDiff [

	^ self selectNextDiffThat: #isUnresolved
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 04:27'
}
MorseSynchronizationTool >> selectedDiff [

	^ selectedDiff
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/10/2026 00:01'
}
MorseSynchronizationTool >> selectedDiffStrategyChanged [

	self changed: #selectedDiffStrategy.
	
	self visibleItemModelSites do: [:site |
		self updateItemModelForSite: site].
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/3/2026 00:59'
}
MorseSynchronizationTool >> setItemModelForSite: siteOrNil to: newModel [

	siteOrNil ifNil: [itemModel := newModel. ^ self].
	siteOrNil = #local ifTrue: [localItemModel := newModel. ^ self].
	siteOrNil = #remote ifTrue: [remoteItemModel := newModel. ^ self].
	^ siteOrNil caseError
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/21/2026 22:19'
}
MorseSynchronizationTool >> shiftedDiffMenuMore: aMenu [
	<diffMenuShifted: true>
	<menuPriority: 1000>

	^ aMenu
		addLine;
		add: 'more...' action: #offerUnshiftedDiffMenu;
		yourself

]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 21:03'
}
MorseSynchronizationTool >> showSplitDiff [

	self
		displayMode: #split;
		contentsSymbolQuint: self defaultDiffContentsSymbolQuint.
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/9/2026 23:46'
}
MorseSynchronizationTool >> strategyLabelFor: aDiff [

	^ Text
		string: aDiff strategy shortLabel
		attribute:
			(PluggableTextAttribute evalBlock:
				[self offerStrategyMenuFor: aDiff])
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/10/2026 19:40'
}
MorseSynchronizationTool >> strategyMenu: menu for: aDiff [

	^ self
		strategyMenu: menu
		for: aDiff
		roles: #(menu)
		showShortcuts: false
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/10/2026 22:43'
}
MorseSynchronizationTool >> strategyMenu: menu for: aDiff roles: roles showShortcuts: aBoolean [

	self strategySpecs
		select: [:spec |
			spec at: 5 ifPresent: [:itemRoles | itemRoles includesAnyOf: roles] ifAbsent: [true]]
		thenDo: [:spec |
			spec = #-
				ifTrue: [menu addLine]
				ifFalse:
					[| label |
					label := spec first withFirstCharacterDownshifted.
					label = #edit ifTrue: [label := label , '...'].
					aBoolean ifTrue:
						[spec fourth ifNotNil: [:char |
							label := '{1} ({2})' format: {label. char}]].
					spec second
						ifNil: [menu add: label action: [self perform: spec third with: aDiff]]
						ifNotNil: [:enablementSelector |
							menu
								morseAdd: label
								getState:
									[aDiff isIgnored
										ifTrue: [spec second = #isIgnored:]
										ifFalse: [self perform: spec second with: aDiff]]
								setState:
									[self perform: spec third with: aDiff]]]].
	^ menu
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/10/2026 20:30'
}
MorseSynchronizationTool >> strategySpecs [ 

	^ #(
		('Choose local' hasChosenLocal: toggleChooseLocal: $l)
		('Choose remote' hasChosenRemote: toggleChooseRemote: $r)
		('Edit' hasEdited: toggleEdit: $e)
		('Reset choice' nil unresolveDiff: $z (mainMenu))
		-
		('Ignore' isIgnored: toggleIgnore: $I (menu))
	)
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 06:04'
}
MorseSynchronizationTool >> tableFraction [

	^ 0.42
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 03:48'
}
MorseSynchronizationTool >> task [

	^ task
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/3/2026 01:57'
}
MorseSynchronizationTool >> task: aSynchronizationTask [

	task := aSynchronizationTask.
	self changed: #task.
	
	self selectNextUnresolvedDiff.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 00:08'
}
MorseSynchronizationTool >> toggleChooseLocal [
	<sentFrom: #contentButtonSpecs>

	| diff |
	diff := self selectedDiff ifNil: [^ self changed: #flash].
	self okToChange ifFalse: [^ self].
	
	(self basicToggleChooseLocal: diff) ifTrue:
		[self selectNextUnresolvedDiff].
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 20:43'
}
MorseSynchronizationTool >> toggleChooseLocal: aDiff [

	self selectedDiff = aDiff ==> [self okToChange] ifFalse: [^ self].
	
	self basicToggleChooseLocal: aDiff.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 00:09'
}
MorseSynchronizationTool >> toggleChooseRemote [
	<sentFrom: #contentButtonSpecs>

	| diff |
	diff := self selectedDiff ifNil: [^ self changed: #flash].
	self okToChange ifFalse: [^ self].
	
	(self basicToggleChooseRemote: diff) ifTrue:
		[self selectNextUnresolvedDiff].
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 20:47'
}
MorseSynchronizationTool >> toggleChooseRemote: aDiff [

	self selectedDiff = aDiff ==> [self okToChange] ifFalse: [^ self].
	
	self basicToggleChooseRemote: aDiff.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/9/2026 18:53'
}
MorseSynchronizationTool >> toggleEdit [

	self itemModels anySatisfy: [:model |
		model edit.
		true].
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 22:31'
}
MorseSynchronizationTool >> toggleEdit: aDiff [

	self selectedDiff = aDiff ifFalse:
		[self selectedDiff notNil ==> [self okToChange] ifFalse: [^ self].
		self selectDiff: aDiff].
	
	self toggleEdit.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 21:54'
}
MorseSynchronizationTool >> toggleIgnore [
	<sentFrom: #(strategyMenu:for:roles:showShortcuts: diffKeyTable)>

	| diff |
	diff := self selectedDiff ifNil: [^ self toggleIgnoreAll].
	
	((self basicToggleIgnore: diff) and: [diff isResolved]) ifTrue:
		[self selectNextDiff].
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 22:32'
}
MorseSynchronizationTool >> toggleIgnore: aDiff [

	self basicToggleIgnore: aDiff.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 16:52'
}
MorseSynchronizationTool >> toggleIgnoreAll [

	(self diffs anySatisfy: #isIgnored)
		ifFalse:
			[self diffs do: #ignore]
		ifTrue:
			[self diffs do: #unignore].
	
	self changed: #diffStrategies.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 21:12'
}
MorseSynchronizationTool >> toggleSplitView [

	self displayMode:
		(self displayMode = #split ifTrue: [#single] ifFalse: [#split]).
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 20:37'
}
MorseSynchronizationTool >> unresolveDiff [
	<sentFrom: #(strategyMenu:for:roles:showShortcuts: diffKeyTable)>

	| diff |
	diff := self selectedDiff ifNil: [^ self changed: #flash].
	self okToChange ifFalse: [^ self].
	
	self basicUnresolveDiff: diff.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/10/2026 20:47'
}
MorseSynchronizationTool >> unresolveDiff: aDiff [

	self selectedDiff = aDiff ==> [self okToChange] ifFalse: [^ self].
	
	self basicUnresolveDiff: aDiff.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/10/2026 23:28'
}
MorseSynchronizationTool >> unresolvedDiffs [

	^ self task unresolvedDiffs
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/9/2026 18:41'
}
MorseSynchronizationTool >> updateItemModel: model forSite: siteOrNil [

	| diff |
	diff := self selectedDiff ifNil: [^ self].
	model
		item: (self itemForItemModelForSite: siteOrNil)
			oldItem: (self oldItemForItemModelForSite: siteOrNil);
		previewItem: (self previewItemForItemModelForSite: siteOrNil);
		diff: diff;
		editBlock: [:item | self editDiff: diff with: item forSite: siteOrNil].
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/3/2026 01:20'
}
MorseSynchronizationTool >> updateItemModelForSite: siteOrNil [

	^ self
		updateItemModel: (self itemModelForSite: siteOrNil)
		forSite: siteOrNil
]

{
	#category : #'private - item models',
	#'squeak_changestamp' : 'ct 2/3/2026 01:14'
}
MorseSynchronizationTool >> visibleItemModelSites [

	self hasDiffSelected ifFalse: [^ #()].
	^ self displayMode = #split
		ifFalse: [#(nil)]
		ifTrue: [#(local remote)]
]

{
	#category : #'toolbuilder - constants',
	#'squeak_changestamp' : 'ct 2/2/2026 17:56'
}
MorseSynchronizationTool >> windowColorToUse [

	^ self defaultWindowColor
]
