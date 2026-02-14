Extension { #name : #MCMethodDefinition }

{
	#category : #'*MethodMorseDomains-Code-converting',
	#'squeak_changestamp' : 'ct 2/13/2026 19:00'
}
MCMethodDefinition >> asMorseItemIn: aCodeProject [

	^ MorseCodeItem
		forDefinition: self
		project: aCodeProject
]

{
	#category : #'*MethodMorseDomains-Code-copying',
	#'squeak_changestamp' : 'ct 2/1/2026 20:20'
}
MCMethodDefinition >> morseWithCategory: newCategory [

	^ self species
		className: self className
		classIsMeta: self classIsMeta
		selector: self selector
		category: newCategory
		timeStamp: self timeStamp
		source: self source
]

{
	#category : #'*MethodMorseDomains-Code-copying',
	#'squeak_changestamp' : 'ct 2/1/2026 21:26'
}
MCMethodDefinition >> morseWithClassName: classString [

	^ self species
		className: classString
		classIsMeta: self classIsMeta
		selector: self selector
		category: self category
		timeStamp: self timeStamp
		source: self source
]

{
	#category : #'*MethodMorseDomains-Code-copying',
	#'squeak_changestamp' : 'ct 2/9/2026 18:13'
}
MCMethodDefinition >> morseWithSource: sourceString timeStamp: timeString [

	^ self species
		className: self className
		classIsMeta: self classIsMeta
		selector: self selector
		category: self category
		timeStamp: timeString
		source: sourceString
]

{
	#category : #'*MethodMorseDomains-Code-copying',
	#'squeak_changestamp' : 'ct 2/9/2026 19:36'
}
MCMethodDefinition >> morseWithTimeStamp: timeString category: catString [

	^ self species
		className: self className
		classIsMeta: self classIsMeta
		selector: self selector
		category: catString
		timeStamp: timeString
		source: self source
]
