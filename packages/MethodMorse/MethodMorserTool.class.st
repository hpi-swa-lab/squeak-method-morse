Class {
	#name : #MethodMorserTool,
	#superclass : #Model,
	#traits : 'TMorseAspectDependencyGraph',
	#classTraits : 'TMorseAspectDependencyGraph classTrait',
	#instVars : [
		'morser',
		'environment',
		'extraSpaces',
		'selectedProjectIndex',
		'allSelectedProjects'
	],
	#category : #'MethodMorse-UI'
}

{
	#category : #constants,
	#'squeak_changestamp' : 'ct 2/10/2026 01:02'
}
MethodMorserTool class >> appName [

	^ 'Method Morse'
]

{
	#category : #constants,
	#'squeak_changestamp' : 'ct 2/14/2026 19:12'
}
MethodMorserTool class >> githubRepositoryParams [

	^ {'hpi-swa-lab'. 'squeak-method-morse'. 'packages'}
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/13/2026 20:05'
}
MethodMorserTool class >> initialize [

	self registerInWorldMenu.
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/1/2026 02:39'
}
MethodMorserTool class >> on: aMethodMorser [

	^ self new
		morser: aMethodMorser;
		yourself
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 1/31/2026 20:22'
}
MethodMorserTool class >> open [

	^ self new open
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/1/2026 02:39'
}
MethodMorserTool class >> openOn: aMethodMorser [

	^ (self on: aMethodMorser)
		open
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/13/2026 20:05'
}
MethodMorserTool class >> registerInWorldMenu [

	TheWorldMenu registerOpenCommand: {self appName. {self. #open}}.
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'ct 2/13/2026 19:31'
}
MethodMorserTool class >> themeProperties [

	^ super themeProperties,
		{ { #ongoingSyncColor. 'Colors' . 'Button color to indicate ongoing sync in Method Morse.' }.
		{ #incompleteSyncColor. 'Colors' . 'Button color to indicate incomplete sync in Method Morse.' }.
		{ #recentSyncColor. 'Colors' . 'Button color to indicate recent successful sync in Method Morse.' } }
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/13/2026 20:05'
}
MethodMorserTool class >> unload [

	self unregisterFromWorldMenu.
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/13/2026 20:05'
}
MethodMorserTool class >> unregisterFromWorldMenu [

	TheWorldMenu unregisterOpenCommand: self appName.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/16/2026 00:12'
}
MethodMorserTool >> addModelItemsToWindowMenu: menu [

	super addModelItemsToWindowMenu: menu.
	
	(self class respondsTo: #appMenu:) ifTrue:
		[menu addLine.
		self class appMenu: menu].
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 1/31/2026 22:00'
}
MethodMorserTool >> addProjects [

	| allProjects newProjects |
	allProjects := self allSpaces gather: [:space | space projects].
	newProjects := Project uiManager
		chooseMultipleFrom: (allProjects collect: #name)
		values: allProjects.
	newProjects isEmptyOrNil ifTrue: [^ self].
	self addProjects: newProjects.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/1/2026 02:27'
}
MethodMorserTool >> addProjects: someProjects [

	self morser addProjects: someProjects.
	self changed: #projects.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/14/2026 19:32'
}
MethodMorserTool >> allConnectionSpecs [

	^ MorseServer allConnectionSpecs
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:13'
}
MethodMorserTool >> allSelectedProjects [

	^ allSelectedProjects
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 23:14'
}
MethodMorserTool >> allSpaces [

	^ {MorseCodeSpace forEnvironment: self environment} , (self extraSpaces ifNil: [#()])
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/2/2026 04:29'
}
MethodMorserTool >> aspectDependencies [

	^ Dictionary new
		at: #autoSyncEnabled put: #(autoSyncOutgoingEnabled autoSyncIncomingEnabled);
		at: #windowTitle put: #(labelString);
		yourself
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/1/2026 02:39'
}
MethodMorserTool >> autoSyncEnabled [

	^ self morser autoSyncEnabled
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/13/2026 19:28'
}
MethodMorserTool >> autoSyncIncomingColor [
	<uses: #(hasIncompleteAutoSyncIncoming incomingAutoSyncRecency isAutoSyncIncomingInProgress)>

	self isAutoSyncIncomingInProgress ifTrue: [^ self ongoingSyncColor].
	self hasIncompleteAutoSyncIncoming ifTrue: [^ self incompleteSyncColor].
	
	self incomingAutoSyncRecency ifNotNil: [:recency |
		recency <= self buttonFadingMaxRecency ifTrue:
			[(self future: self buttonFadingStepTime) changed: #autoSyncIncomingColor.
			^ self defaultButtonColor
				mixed: recency / self buttonFadingMaxRecency
				with: self recentSyncColor]].
	^ self defaultButtonColor
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/1/2026 02:39'
}
MethodMorserTool >> autoSyncIncomingEnabled [

	^ self morser autoSyncIncomingEnabled
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/2/2026 02:23'
}
MethodMorserTool >> autoSyncIncomingHelp [
	<uses: #basicAutoSyncIncomingHelp>

	^ self updatingHelpText: [self basicAutoSyncIncomingHelp]
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/1/2026 20:07'
}
MethodMorserTool >> autoSyncIncomingLabel [
	<uses: #isAutoSyncIncomingInProgress>

	self isAutoSyncIncomingInProgress ifFalse: [^ '(incoming)'].
	^ '(incoming...)'
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/13/2026 19:28'
}
MethodMorserTool >> autoSyncOutgoingColor [
	<uses: #(hasIncompleteAutoSyncOutgoing isAutoSyncOutgoingInProgress outgoingAutoSyncRecency)>

	self isAutoSyncOutgoingInProgress ifTrue: [^ self ongoingSyncColor].
	self hasIncompleteAutoSyncOutgoing ifTrue: [^ self incompleteSyncColor].
	
	self outgoingAutoSyncRecency ifNotNil: [:recency |
		recency <= self buttonFadingMaxRecency ifTrue:
			[(self future: self buttonFadingStepTime) changed: #autoSyncOutgoingColor.
			^ self defaultButtonColor
				mixed: recency / self buttonFadingMaxRecency
				with: self recentSyncColor]].
	^ self defaultButtonColor
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/1/2026 02:39'
}
MethodMorserTool >> autoSyncOutgoingEnabled [

	^ self morser autoSyncOutgoingEnabled
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/2/2026 02:16'
}
MethodMorserTool >> autoSyncOutgoingHelp [
	<uses: #basicAutoSyncOutgoingHelp>

	^ self updatingHelpText: [self basicAutoSyncOutgoingHelp]
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/1/2026 19:47'
}
MethodMorserTool >> autoSyncOutgoingLabel [
	<uses: #isAutoSyncOutgoingInProgress>

	self isAutoSyncOutgoingInProgress ifFalse: [^ '(outgoing)'].
	^ '(outgoing...)'
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 21:44'
}
MethodMorserTool >> autoSyncPaneHeightWith: builder [

	^ builder buttonRowHeight
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/16/2026 00:03'
}
MethodMorserTool >> basicAutoSyncIncomingHelp [
	<uses: #(lastIncomingAutoSyncStamp hasIncompleteAutoSyncIncoming incomingAutoSyncRecency)>

	| stamp |
	stamp := self lastIncomingAutoSyncStamp ifNil: [^ 'Not incoming auto sync so far'].
	^ (self hasIncompleteAutoSyncIncoming
		ifFalse: ['Last incoming auto sync completed at {1} ({2})']
		ifTrue: ['Last incoming auto sync was INCOMPLETE at {1} ({2}).\\Run full sync to fix.' withCRs])
			format:
				{stamp date = Date today
					ifTrue: [stamp time printMinutes]
					ifFalse: [stamp morseShortLocalPrintString].
				self incomingAutoSyncRecency morseAsWordsAgo}
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/16/2026 00:03'
}
MethodMorserTool >> basicAutoSyncOutgoingHelp [
	<uses: #(lastOutgoingAutoSyncStamp hasIncompleteAutoSyncOutgoing outgoingAutoSyncRecency)>

	| stamp |
	stamp := self lastOutgoingAutoSyncStamp ifNil: [^ 'No outgoing auto sync so far'].
	^ (self hasIncompleteAutoSyncOutgoing
		ifFalse: ['Last outgoing auto sync completed at {1} ({2})']
		ifTrue: ['Last outgoing auto sync was INCOMPLETE at {1} ({2}).\\Run full sync to fix.' withCRs])
			format:
				{stamp date = Date today
					ifTrue: [stamp time printMinutes]
					ifFalse: [stamp morseShortLocalPrintString].
				self outgoingAutoSyncRecency morseAsWordsAgo}
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/16/2026 00:03'
}
MethodMorserTool >> basicManualSyncButtonHelp [ 
	<uses: #(lastManualSyncStamp manualSyncRecency)>

	| stamp |
	stamp := self lastManualSyncStamp ifNil: [^ 'No full sync so far'].
	^ 'Last full sync completed at {1} ({2})' format:
		{stamp date = Date today
			ifTrue: [stamp time printMinutes]
			ifFalse: [stamp morseShortLocalPrintString].
		self manualSyncRecency morseAsWordsAgo}
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 1/31/2026 22:20'
}
MethodMorserTool >> browseProject [

	^ (self selectedProject ifNil: [^ self changed: #flash])
		browse
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/1/2026 19:48'
}
MethodMorserTool >> browseProjectRemote [

	^ (self morser server remoteProjectFor: (self selectedProject ifNil: [^ self changed: #flash]))
		browse
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/1/2026 03:00'
}
MethodMorserTool >> buildAutoSyncButtonWith: builder [

	^ builder pluggableButtonSpec new
		model: self;
		label: 'auto sync';
		state: #autoSyncEnabled;
		action: #toggleAutoSync;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 02:26'
}
MethodMorserTool >> buildAutoSyncIncomingButtonWith: builder [

	^ builder pluggableButtonSpec new
		model: self;
		label: #autoSyncIncomingLabel;
		state: #autoSyncIncomingEnabled;
		action: #toggleAutoSyncIncoming;
		color: #autoSyncIncomingColor;
		help: #autoSyncIncomingHelp;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 01:36'
}
MethodMorserTool >> buildAutoSyncOutgoingButtonWith: builder [

	^ builder pluggableButtonSpec new
		model: self;
		label: #autoSyncOutgoingLabel;
		state: #autoSyncOutgoingEnabled;
		action: #toggleAutoSyncOutgoing;
		color: #autoSyncOutgoingColor;
		help: #autoSyncOutgoingHelp;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 00:26'
}
MethodMorserTool >> buildAutoSyncPaneWith: builder [

	^ builder pluggablePanelSpec new
		layout: #horizontal;
		children:
			(Array
				with: (self buildAutoSyncButtonWith: builder)
				with: (self buildAutoSyncOutgoingButtonWith: builder)
				with: (self buildAutoSyncIncomingButtonWith: builder));
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 22:33'
}
MethodMorserTool >> buildConnectButtonWith: builder [

	^ builder pluggableButtonSpec new
		model: self;
		label: #connectLabel;
		action: #toggleConnection;
		state: #isConnected;
		color: #connectionColor;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 22:35'
}
MethodMorserTool >> buildConnectionBarWith: builder [

	^ builder pluggablePanelSpec new
		layout: #horizontal;
		children:
			(Array
				with: (self buildConnectButtonWith: builder)
				with: (self buildEditConnectionButtonWith: builder));
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 22:36'
}
MethodMorserTool >> buildEditConnectionButtonWith: builder [

	^ builder pluggableActionButtonSpec new
		model: self;
		label: 'edit connection';
		action: #editConnection;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 03:01'
}
MethodMorserTool >> buildManualSyncPaneWith: builder [

	^ builder pluggableActionButtonSpec new
		model: self;
		label: 'full sync';
		color: #manualSyncButtonColor;
		help: #manualSyncButtonHelp;
		action: #doManualSync;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 21:53'
}
MethodMorserTool >> buildProjectButtonBarWith: builder [

	^ builder pluggablePanelSpec new
		layout: #horizontal;
		children:
			(Array
				with:
					(builder pluggableActionButtonSpec new
						model: self;
						label: 'add...';
						action: #addProjects;
						yourself)
				with:
					(builder pluggableActionButtonSpec new
						model: self;
						label: 'remove';
						action: #removeProjects;
						yourself));
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 22:11'
}
MethodMorserTool >> buildProjectListWith: builder [

	^ builder pluggableMultiSelectionListSpec new
		model: self;
		list: #projectNames;
		getIndex: #selectedProjectIndex;
		setIndex: #selectedProjectIndex:;
		getSelectionList: #isProjectSelectedAt:;
		setSelectionList: #projectAt:select:;
		menu: #projectListMenu:shifted:;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 20:31'
}
MethodMorserTool >> buildSyncPaneWith: builder [

	^ builder pluggablePanelSpec new
		layout: #vertical;
		children:
			(Array
				with: (self buildManualSyncPaneWith: builder)
				with: (self buildAutoSyncPaneWith: builder));
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/1/2026 02:44'
}
MethodMorserTool >> buildWith: builder [

	| windowSpec |
	windowSpec := self buildWindowWith: builder specs:
		{LayoutFrame new rightFraction: 1; bottomOffset: (self connectionBarHeightWith: builder); ->
			[self buildConnectionBarWith: builder].
		LayoutFrame fullFrame topOffset: (self connectionBarHeightWith: builder); bottomOffset: (self syncPaneHeightWith: builder) negated; ->
			[self buildProjectListWith: builder].
		LayoutFrame new rightFraction: 1; topFraction: 1; bottomFraction: 1; topOffset: (self syncPaneHeightWith: builder) negated; ->
			[self buildSyncPaneWith: builder]}.
	^ builder build: windowSpec
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/12/2026 17:39'
}
MethodMorserTool >> buttonFadingFrameRate [

	^ 30 "fps"
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/12/2026 17:39'
}
MethodMorserTool >> buttonFadingMaxRecency [

	^ 5 seconds
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/12/2026 17:40'
}
MethodMorserTool >> buttonFadingStepTime [

	^ 1000 / self buttonFadingFrameRate
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 1/31/2026 22:52'
}
MethodMorserTool >> connectLabel [
	<uses: #(isConnected isConnectionPending)>

	self isConnected ifFalse: [^ 'connect'].
	self isConnectionPending ifTrue: [^ 'connecting...'].
	^ 'connected'
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/1/2026 02:44'
}
MethodMorserTool >> connectionBarHeightWith: builder [

	^ builder buttonRowHeight
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 1/31/2026 22:51'
}
MethodMorserTool >> connectionColor [
	<uses: #isConnected>

	self isConnected ifFalse: [^ self defaultButtonColor].
	self halt
]

{
	#category : #'toolbuilder - constants',
	#'squeak_changestamp' : 'ct 1/31/2026 21:48'
}
MethodMorserTool >> defaultButtonColor [

	^ (Smalltalk isMorphic ifTrue: [self userInterfaceTheme get: #color for: #PluggableButtonMorph])
		ifNil: [Color gray: 0.91]
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 17:26'
}
MethodMorserTool >> doManualSync [

	^ self morser doManualSync
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/1/2026 02:29'
}
MethodMorserTool >> editConnection [

	| currentSpec specs spec |
	currentSpec := self morser server ifNotNil: #connectionSpec.
	specs := self allConnectionSpecs collect: [:ea |
		ea connectionType = (currentSpec ifNotNil: #connectionType)
			ifTrue: [currentSpec]
			ifFalse: [ea]].
	spec := Project uiManager
		chooseFromLabeledValues: (specs collect: [:ea | ea connectionLabel -> ea] as: OrderedDictionary)
		"initialSelection: currentSpec".
	spec ifNil: [^ self].
	self morser server: (spec editConnection ifNil: [^ self]).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 00:52'
}
MethodMorserTool >> environment [

	^ environment ifNil: [super environment]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 00:53'
}
MethodMorserTool >> environment: anEnvironment [

	environment := anEnvironment.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:14'
}
MethodMorserTool >> extraSpaces [

	^ extraSpaces
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:14'
}
MethodMorserTool >> extraSpaces: aCollection [

	extraSpaces := aCollection.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 02:19'
}
MethodMorserTool >> hasIncompleteAutoSyncIncoming [

	^ self morser hasIncompleteAutoSyncIncoming
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/2/2026 02:19'
}
MethodMorserTool >> hasIncompleteAutoSyncOutgoing [

	^ self morser hasIncompleteAutoSyncOutgoing
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:21'
}
MethodMorserTool >> hasProjectSelected [

	^ self selectedProject notNil
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:17'
}
MethodMorserTool >> hasProjectsSelected [

	^ self allSelectedProjects notEmpty
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:51'
}
MethodMorserTool >> incomingAutoSyncRecency [
	<uses: #lastIncomingAutoSyncStamp>

	^ DateAndTime now - (self lastIncomingAutoSyncStamp ifNil: [^ nil])
]

{
	#category : #'toolbuilder - constants',
	#'squeak_changestamp' : 'ct 2/13/2026 19:26'
}
MethodMorserTool >> incompleteSyncColor [

	^ self userInterfaceTheme incompleteSyncColor ifNil: [Color red]
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/1/2026 22:04'
}
MethodMorserTool >> initialExtent [

	^ 250 @ 200
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/1/2026 02:42'
}
MethodMorserTool >> initialize [

	super initialize.
	
	self morser: MethodMorser new.
	selectedProjectIndex := 0.
	allSelectedProjects := Set new.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/1/2026 20:07'
}
MethodMorserTool >> isAutoSyncIncomingInProgress [

	^ self morser isAutoSyncIncomingInProgress
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/1/2026 19:46'
}
MethodMorserTool >> isAutoSyncOutgoingInProgress [

	^ self morser isAutoSyncOutgoingInProgress
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/1/2026 02:37'
}
MethodMorserTool >> isConnected [

	^ self morser isConnected
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/1/2026 02:29'
}
MethodMorserTool >> isConnectionPending [

	^ self morser isConnectionPending
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 2/11/2026 19:21'
}
MethodMorserTool >> isManualSyncInProgress [

	^ self morser isSyncInProgress
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 1/31/2026 22:13'
}
MethodMorserTool >> isProjectSelectedAt: anInteger [

	^ self allSelectedProjects includes: (self projects at: anInteger ifAbsent: [nil])
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/10/2026 21:45'
}
MethodMorserTool >> labelString [

	| title |
	title := 'Method Morser'.
	^ self environment = self class environment
		ifTrue: [title]
		ifFalse: ['{1} on {2}' format: {title. self environment name}]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:52'
}
MethodMorserTool >> lastIncomingAutoSyncStamp [

	^ self morser lastIncomingAutoSyncStamp
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 19:19'
}
MethodMorserTool >> lastManualSyncStamp [

	^ self morser lastSyncStamp
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:54'
}
MethodMorserTool >> lastOutgoingAutoSyncStamp [

	^ self morser lastOutgoingAutoSyncStamp
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/13/2026 19:28'
}
MethodMorserTool >> manualSyncButtonColor [
	<uses: #(isManualSyncInProgress manualSyncRecency)>

	self isManualSyncInProgress ifTrue: [^ self ongoingSyncColor].
	
	self manualSyncRecency ifNotNil: [:recency |
		recency <= self buttonFadingMaxRecency ifTrue:
			[(self future: self buttonFadingStepTime) changed: #manualSyncButtonColor.
			^ self defaultButtonColor
				mixed: recency / self buttonFadingMaxRecency
				with: self recentSyncColor]].
	^ self defaultButtonColor
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 19:17'
}
MethodMorserTool >> manualSyncButtonHelp [
	<uses: #basicManualSyncButtonHelp>

	^ self updatingHelpText: [self basicManualSyncButtonHelp]
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 21:40'
}
MethodMorserTool >> manualSyncPaneHeightWith: builder [

	^ builder buttonRowHeight
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 19:24'
}
MethodMorserTool >> manualSyncRecency [
	<uses: #lastManualSyncStamp>

	^ DateAndTime now - (self lastManualSyncStamp ifNil: [^ nil])
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 02:33'
}
MethodMorserTool >> morser [

	^ morser
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 05:44'
}
MethodMorserTool >> morser: aMethodMorser [

	self morser removeDependent: self.
	
	morser := aMethodMorser.
	
	self morser addDependent: self.
	self morser server ifNotNil: [:server |
		server remoteSpaces ifNotEmpty: [:spaces |
			self environment: spaces keys anyOne environment]].
	
	self changed: #morser.
]

{
	#category : #'toolbuilder - constants',
	#'squeak_changestamp' : 'ct 2/13/2026 19:28'
}
MethodMorserTool >> ongoingSyncColor [

	^ self userInterfaceTheme ongoingSyncColor ifNil: [Color yellow]
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 20:21'
}
MethodMorserTool >> open [

	^ ToolBuilder open: self
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 18:54'
}
MethodMorserTool >> outgoingAutoSyncRecency [
	<uses: #lastOutgoingAutoSyncStamp>

	^ DateAndTime now - (self lastOutgoingAutoSyncStamp ifNil: [^ nil])
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:29'
}
MethodMorserTool >> project: aProject select: aBoolean [

	aBoolean
		ifFalse: [self allSelectedProjects remove: aProject ifAbsent: []]
		ifTrue: [self allSelectedProjects add: aProject].
	self changed: #allSelectedProjects.
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 1/31/2026 22:16'
}
MethodMorserTool >> projectAt: anInteger select: aBoolean [

	^ self
		project: (self projects at: anInteger)
		select: aBoolean
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 21:38'
}
MethodMorserTool >> projectButtonBarHeightWith: builder [

	^ builder buttonRowHeight
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/1/2026 01:59'
}
MethodMorserTool >> projectListMenu: menu [
	<projectListMenuShifted: false>

	menu add: 'add' action: #addProjects.
	self hasProjectsSelected ifTrue:
		[menu
			add: 'remove' action: #removeProjects].
	self hasProjectSelected ifTrue:
		[menu
			addLine;
			add: 'browse' action: #browseProject;
			add: 'browse remote' action: #browseProjectRemote].
	^ menu
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 22:11'
}
MethodMorserTool >> projectListMenu: menu shifted: shifted [

	^ self
		menu: menu
		for: #(projectListMenu projectListMenuShifted:)
		shifted: shifted
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 04:29'
}
MethodMorserTool >> projectNames [
	<uses: #projects>

	^ self projects collect: #name
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/1/2026 02:38'
}
MethodMorserTool >> projects [

	^ self morser projects
]

{
	#category : #'toolbuilder - constants',
	#'squeak_changestamp' : 'ct 2/13/2026 19:26'
}
MethodMorserTool >> recentSyncColor [

	^ self userInterfaceTheme recentSyncColor ifNil: [Color green]
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/1/2026 02:36'
}
MethodMorserTool >> release [

	self morser release.
	
	^ super release
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 1/31/2026 22:18'
}
MethodMorserTool >> removeProjects [

	self removeProjects: self allSelectedProjects.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/1/2026 02:30'
}
MethodMorserTool >> removeProjects: someProjects [

	self morser removeProjects: someProjects.
	
	allSelectedProjects removeAllFoundIn: someProjects.
	self changed: #projects.
	self changed: #selectedProjects.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/31/2026 22:21'
}
MethodMorserTool >> selectedProject [

	^ self projects at: self selectedProjectIndex ifAbsent: [nil]
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 1/31/2026 22:09'
}
MethodMorserTool >> selectedProjectIndex [

	^ selectedProjectIndex
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 1/31/2026 22:14'
}
MethodMorserTool >> selectedProjectIndex: anInteger [

	selectedProjectIndex := anInteger.
	self changed: #selectedProjectIndex.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/1/2026 02:31'
}
MethodMorserTool >> startConnection [

	self morser startConnection.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/1/2026 02:31'
}
MethodMorserTool >> stopConnection [

	self morser stopConnection.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/31/2026 21:40'
}
MethodMorserTool >> syncPaneHeightWith: builder [

	^ (self manualSyncPaneHeightWith: builder) + builder panelSpacing + (self autoSyncPaneHeightWith: builder)
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/1/2026 03:02'
}
MethodMorserTool >> toggleAutoSync [

	self morser autoSyncEnabled: self autoSyncEnabled not.
	self changed: #autoSyncEnabled.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/1/2026 03:08'
}
MethodMorserTool >> toggleAutoSyncIncoming [

	self morser autoSyncIncomingEnabled: self autoSyncIncomingEnabled not.
	self changed: #autoSyncIncomingEnabled.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/1/2026 03:07'
}
MethodMorserTool >> toggleAutoSyncOutgoing [

	self morser autoSyncOutgoingEnabled: self autoSyncOutgoingEnabled not.
	self changed: #autoSyncOutgoingEnabled.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 1/31/2026 22:32'
}
MethodMorserTool >> toggleConnection [

	^ self isConnected
		ifFalse: [self startConnection]
		ifTrue: [self stopConnection]
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/11/2026 19:47'
}
MethodMorserTool >> update: what [

	self flag: #todo. "aggregate and deduplicate changes in queue and create single future on first enqueue"
	self future changed:
		(what
			caseOf:
				{[#isSyncInProgress] -> [#isManualSyncInProgress].
				[#lastSyncStamp] -> [#lastManualSyncStamp]}
			otherwise: [what]).
	
	^ super update: what
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 19:16'
}
MethodMorserTool >> updatingHelpText: aBlock [ 

	| text |
	text := aBlock value.
	Smalltalk isMorphic ifTrue:
		[((self currentWorld future: 1000) submorphsSatisfying: [:m | m isBalloonHelp]) then: [:balloons |
			balloons
				detect: [:m |
					m text asString withSeparatorsCompacted "for old BalloonMorph" = text asString withSeparatorsCompacted]
				ifFound: [:m |
					m setText: (self updatingHelpText: aBlock)]]].
	^ text
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/1/2026 01:42'
}
MethodMorserTool >> windowIsClosing [

	self stopConnection.
	^ super windowIsClosing
]
