Class {
	#name : #MorseItemHolder,
	#superclass : #StringHolder,
	#instVars : [
		'item',
		'oldItem'
	],
	#category : #'MethodMorse-UI'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 2/2/2026 05:14'
}
MorseItemHolder class >> on: anItem [

	^ self new
		item: anItem;
		yourself
]

{
	#category : #browsing,
	#'squeak_changestamp' : 'ct 2/21/2026 21:48'
}
MorseItemHolder >> browse [

	^ self oldItem ifNotNil: #browse
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 2/2/2026 05:16'
}
MorseItemHolder >> buildPaneWith: builder [

	^ self buildCodePaneWith: builder
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 19:53'
}
MorseItemHolder >> codePaneProvenanceString [

	| symsAndWordings |
	(symsAndWordings := self contentsSymbolQuints ifEmpty: [^ nil]) do:
		[:aQuad |
			self contentsSymbol == aQuad first ifTrue: [^ aQuad fourth]].
	^ symsAndWordings first fourth "default to plain source, for example if nil as initially"
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:54'
}
MorseItemHolder >> contents [

	^ self item ifNotNil: #asStringOrText
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:53'
}
MorseItemHolder >> contentsSymbol [

	^ nil
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 19:29'
}
MorseItemHolder >> contentsSymbolQuints [

	^ #()
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 22:57'
}
MorseItemHolder >> diff: aDiff [
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:52'
}
MorseItemHolder >> editBlock: aBlock [
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/2/2026 05:14'
}
MorseItemHolder >> item [

	^ item
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/12/2026 00:05'
}
MorseItemHolder >> item: anItem [

	item := anItem.
	self changed: #contents.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:52'
}
MorseItemHolder >> item: anItem oldItem: anotherItem [

	self item: anItem; oldItem: anotherItem.
]

{
	#category : #'item list',
	#'squeak_changestamp' : 'ct 2/12/2026 00:15'
}
MorseItemHolder >> itemKey: aCharacter from: view [

	aCharacter = $b ifTrue: [^ self browse].
	^ false
]

{
	#category : #'item menu',
	#'squeak_changestamp' : 'ct 2/21/2026 21:50'
}
MorseItemHolder >> itemMenu: menu [
	<itemMenuShifted: false>

	menu
		add: 'browse (b)' target: self selector: #browse;
		add: 'inspect' target: self item selector: #inspect.
	menu addLine.
	^ menu
]

{
	#category : #'item list',
	#'squeak_changestamp' : 'ct 2/12/2026 00:09'
}
MorseItemHolder >> itemMenu: menu shifted: aBoolean [

	^ self menu: menu for: #(itemMenu itemMenuShifted:) shifted: aBoolean
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/21/2026 21:49'
}
MorseItemHolder >> oldItem [

	^ oldItem
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/21/2026 21:49'
}
MorseItemHolder >> oldItem: anItem [

	oldItem := anItem.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:52'
}
MorseItemHolder >> previewItem: anItem [
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 2/11/2026 23:52'
}
MorseItemHolder >> siteName: siteOrNil [
]
