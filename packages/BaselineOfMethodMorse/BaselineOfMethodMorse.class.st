Class {
	#name : #BaselineOfMethodMorse,
	#superclass : #BaselineOf,
	#category : #BaselineOfMethodMorse
}

{
	#category : #baseline,
	#'squeak_changestamp' : 'ct 2/14/2026 19:26'
}
BaselineOfMethodMorse >> baseline: spec [
	<baseline>

	spec for: #common do: [
		"dependencies"
		spec
			baseline: 'CtAppFramework' with:
				[spec repository: 'github://LinqLover/squeak-appframework:main'].
		
		"packages"
		spec
			package: 'MethodMorse';
			package: 'MethodMorseDomains-Code' with:
				[spec requires: 'MethodMorse'];
			package: 'MethodMorseDomains-Demo' with:
				[spec requires: 'MethodMorse'].
		
		"groups"
		spec
			group: #small with: #('MethodMorse' 'MethodMorseDomains-Code' 'MethodMorseDomains-Demo');
			group: #default with: #(small 'CtAppFramework')].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 5/26/2021 15:29'
}
BaselineOfMethodMorse >> projectClass [

	^ (self environment classNamed: #MetacelloCypressBaselineProject) ifNil: [super projectClass]
]
