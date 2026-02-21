Class {
	#name : #MorseDemoTodoTool,
	#superclass : #StringHolder,
	#traits : 'TMorseAspectDependencyGraph',
	#classTraits : 'TMorseAspectDependencyGraph classTrait',
	#instVars : [
		'book',
		'selectedList',
		'selectedItem',
		'selectedLabel'
	],
	#category : #'MethodMorseDomains-Demo-Todo'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/11/2026 22:12'
}
MorseDemoTodoTool class >> on: aDemoTodoBook [

	^ self new
		book: aDemoTodoBook;
		yourself
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/11/2026 22:13'
}
MorseDemoTodoTool class >> open [

	^ self new open
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/11/2026 22:12'
}
MorseDemoTodoTool class >> openOn: aDemoTodoBook [

	^ (self on: aDemoTodoBook)
		open
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 23:48'
}
MorseDemoTodoTool >> addItem [

	self selectedList ifNil: [^ self changed: #flash].
	self addItemWithName: (self requestItemName ifNil: [^ self]).
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 23:48'
}
MorseDemoTodoTool >> addItemWithName: aString [

	| item |
	item := self selectedList addItemWithName: aString.
	self changed: #items.
	self selectItem: item.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 23:10'
}
MorseDemoTodoTool >> addLabel [

	self selectedItem ifNil: [^ self changed: #flash].
	self addLabel: (self requestLabel ifNil: [^ self]).
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 23:09'
}
MorseDemoTodoTool >> addLabel: aString [

	| label |
	label := self selectedItem addLabel: aString.
	self changed: #labels.
	self selectLabel: label.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 22:48'
}
MorseDemoTodoTool >> addList [

	self addListNamed: (self requestListName ifNil: [^ self]).
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 23:03'
}
MorseDemoTodoTool >> addListNamed: aString [

	| list |
	list := self book addListNamed: aString.
	self changed: #lists.
	self selectList: list.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:38'
}
MorseDemoTodoTool >> book [

	^ book
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:04'
}
MorseDemoTodoTool >> book: aBook [

	book := aBook.
	
	self changed: #book.
	self selectList: nil.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 22:53'
}
MorseDemoTodoTool >> buildItemListWith: builder [

	^ builder pluggableListSpec new
		model: self;
		list: #itemList;
		getIndex: #itemSelectionIndex;
		setIndex: #itemSelectionIndex:;
		menu: #itemMenu:;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 23:11'
}
MorseDemoTodoTool >> buildLabelListWith: builder [

	^ builder pluggableListSpec new
		model: self;
		list: #labels;
		help: 'labels';
		getIndex: #labelSelectionIndex;
		setIndex: #labelSelectionIndex:;
		menu: #labelMenu:;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 22:53'
}
MorseDemoTodoTool >> buildListListWith: builder [

	^ builder pluggableListSpec new
		model: self;
		list: #listList;
		getIndex: #listSelectionIndex;
		setIndex: #listSelectionIndex:;
		menu: #listMenu:;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 22:11'
}
MorseDemoTodoTool >> buildWith: builder [

	| windowSpec |
	windowSpec := self buildWindowWith: builder specs:
		{LayoutFrame new rightFraction: 0.5; bottomFraction: 0.5; ->
			[self buildListListWith: builder].
		LayoutFrame new leftFraction: 0.5; rightFraction: 1; bottomFraction: 0.5; ->
			[self buildItemListWith: builder].
		LayoutFrame new topFraction: 0.5; rightFraction: 0.75; bottomFraction: 1; ->
			[self buildCodePaneWith: builder].
		LayoutFrame new topFraction: 0.5; leftFraction: 0.75; rightFraction: 1; bottomFraction: 1; ->
			[self buildLabelListWith: builder]}.
	^ builder build: windowSpec
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 23:06'
}
MorseDemoTodoTool >> contents [
	<uses: #selectedItem>

	^ (self selectedItem ifNil: [^ nil]) text
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 23:06'
}
MorseDemoTodoTool >> contents: aStringOrText [

	| item |
	item := self selectedItem ifNil: [^ self changed: #flash].
	
	item text: aStringOrText.
	self changed: #items.
	self selectItem: item.
	^ true
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/11/2026 22:13'
}
MorseDemoTodoTool >> initialize [

	super initialize.
	
	self book: MorseDemoTodoBook default.
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 22:57'
}
MorseDemoTodoTool >> itemList [
	<uses: #items>

	^ self items collect: #name
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/11/2026 23:48'
}
MorseDemoTodoTool >> itemMenu: menu [

	self selectedList ifNil: [^ menu].
	
	menu add: 'add' action: #addItem.
	self selectedItem ifNotNil:
		[menu add: 'rename...' action: #renameItem.
		menu add: 'remove' action: #removeItem].
	^ menu
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 22:46'
}
MorseDemoTodoTool >> itemSelectionIndex [
	<uses: #(items selectedItem)>

	^ self items indexOf: self selectedItem
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 23:04'
}
MorseDemoTodoTool >> itemSelectionIndex: anInteger [

	self selectItem:
		(self items at: anInteger ifAbsent: [nil]).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:46'
}
MorseDemoTodoTool >> items [
	<uses: #selectedList>

	^ (self selectedList ifNil: [^ #()]) items
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/11/2026 23:07'
}
MorseDemoTodoTool >> labelMenu: menu [

	self selectedItem ifNil: [^ menu].
	
	menu add: 'add' action: #addLabel.
	self selectedLabel ifNotNil:
		[menu add: 'remove' action: #removeLabel].
	^ menu
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 22:45'
}
MorseDemoTodoTool >> labelSelectionIndex [
	<uses: #(labels selectedLabel)>

	^ self labels indexOf: self selectedLabel
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 23:12'
}
MorseDemoTodoTool >> labelSelectionIndex: anInteger [

	self selectLabel:
		(self labels at: anInteger ifAbsent: [nil]).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:45'
}
MorseDemoTodoTool >> labels [
	<uses: #selectedItem>

	^ (self selectedItem ifNil: [^ #()]) labels
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 22:57'
}
MorseDemoTodoTool >> listList [
	<uses: #lists>

	^ self lists collect: #name
]

{
	#category : #menus,
	#'squeak_changestamp' : 'ct 2/11/2026 22:47'
}
MorseDemoTodoTool >> listMenu: menu [

	menu add: 'add' action: #addList.
	self selectedList ifNotNil:
		[menu add: 'rename...' action: #renameList.
		menu add: 'remove' action: #removeList].
	^ menu
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 22:46'
}
MorseDemoTodoTool >> listSelectionIndex [
	<uses: #(lists selectedList)>

	^ self lists indexOf: self selectedList
]

{
	#category : #'accessing - toolbuilder',
	#'squeak_changestamp' : 'ct 2/11/2026 22:54'
}
MorseDemoTodoTool >> listSelectionIndex: anInteger [

	self selectList:
		(self lists at: anInteger ifAbsent: [nil]).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:46'
}
MorseDemoTodoTool >> lists [
	<uses: #book>

	^ self book lists
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/11/2026 22:13'
}
MorseDemoTodoTool >> open [

	^ ToolBuilder open: self
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 2/12/2026 16:18'
}
MorseDemoTodoTool >> release [

	self selectedList ifNotNil: [:list | list removeDependent: self].
	self selectedItem ifNotNil: [:item | item removeDependent: self].
	^ super release
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 23:43'
}
MorseDemoTodoTool >> removeItem [

	self selectedItem ifNil: [^ self changed: #flash].
	self selectedList removeItem: self selectedItem.
	self changed: #items.
	self selectItem: nil.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 23:43'
}
MorseDemoTodoTool >> removeLabel [

	self selectedLabel ifNil: [^ self changed: #flash].
	self selectedItem removeLabel: self selectedLabel.
	self changed: #labels.
	self selectLabel: nil.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 23:43'
}
MorseDemoTodoTool >> removeList [

	self selectedList ifNil: [^ self changed: #flash].
	self book removeList: self selectedList.
	self changed: #lists.
	self selectList: nil.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 23:48'
}
MorseDemoTodoTool >> renameItem [

	self selectedItem ifNil: [^ self changed: #flash].
	self selectedItem name: ((self requestItemNameWithDefault: self selectedItem name) ifNil: [^ self]).
	self changed: #items.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 2/11/2026 22:56'
}
MorseDemoTodoTool >> renameList [

	self selectedList ifNil: [^ self changed: #flash].
	self selectedList name: ((self requestListNameWithDefault: self selectedList name) ifNil: [^ self]).
	self changed: #lists.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 23:49'
}
MorseDemoTodoTool >> requestItemName [

	^ self requestItemNameWithDefault: ''
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 23:49'
}
MorseDemoTodoTool >> requestItemNameWithDefault: aString [

	^ self requestName: 'Item name?' withDefault: aString
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 23:10'
}
MorseDemoTodoTool >> requestLabel [

	^ self requestName: 'Label?' withDefault: ''
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 22:49'
}
MorseDemoTodoTool >> requestListName [

	^ self requestListNameWithDefault: ''
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 22:49'
}
MorseDemoTodoTool >> requestListNameWithDefault: aString [

	^ self requestName: 'List name?' withDefault: aString
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 2/11/2026 22:50'
}
MorseDemoTodoTool >> requestName: label withDefault: aString [

	^ (Project uiManager request: label initialAnswer: aString)
		ifEmpty: [nil]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 16:14'
}
MorseDemoTodoTool >> selectItem: anItem [

	self selectedItem ifNotNil: [:item | item removeDependent: self].
	selectedItem := anItem.
	self selectedItem ifNotNil: [:item | item addDependent: self].
	self changed: #selectedItem.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:11'
}
MorseDemoTodoTool >> selectLabel: label [

	selectedLabel := label.
	self changed: #selectedLabel.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 16:18'
}
MorseDemoTodoTool >> selectList: aList [

	self selectedList ifNotNil: [:list | list removeDependent: self].
	selectedList := aList.
	self selectedList ifNotNil: [:list | list addDependent: self].
	self changed: #selectedList.
	self selectItem: nil.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:44'
}
MorseDemoTodoTool >> selectedItem [

	^ selectedItem
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:45'
}
MorseDemoTodoTool >> selectedLabel [

	^ selectedLabel
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 22:43'
}
MorseDemoTodoTool >> selectedList [

	^ selectedList
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 2/21/2026 21:38'
}
MorseDemoTodoTool >> update: what [

	what == self selectedList ifTrue:
		[self changed: #selectedList.
		(self items includes: self selectedItem) ifFalse: [self selectItem: nil]].
	what == self selectedItem ifTrue:
		[self changed: #selectedItem].
	^ super update: what
]
