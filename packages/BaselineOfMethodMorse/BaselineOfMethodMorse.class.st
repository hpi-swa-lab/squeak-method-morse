Class {
	#name : #BaselineOfMethodMorse,
	#superclass : #BaselineOf,
	#category : #BaselineOfMethodMorse
}

{
	#category : #baseline,
	#'squeak_changestamp' : 'ct 2/21/2026 21:55'
}
BaselineOfMethodMorse >> baseline: spec [
	<baseline>

	spec for: #common do: [
		"dependencies"
		spec
			baseline: 'CtAppFramework' with:
				[spec repository: 'github://LinqLover/squeak-appframework:main'];
			baseline: 'Yaros' with:
				[spec repository: 'github://LinqLover/yaros:main'].
		
		"packages"
		spec
			package: 'MethodMorse';
			package: 'MethodMorseDomains-Code' with:
				[spec requires: 'MethodMorse'];
			package: 'MethodMorseDomains-Demo' with:
				[spec requires: 'MethodMorse'];
			package: 'MethodMorseServers-Yaros' with:
				[spec requires: #('MethodMorse' 'Yaros')].
		
		"groups"
		spec
			group: #small with: #('MethodMorse' 'MethodMorseDomains-Code' 'MethodMorseDomains-Demo' 'MethodMorseServers-Yaros');
			group: #default with: #(small 'CtAppFramework')].
]

{
	#category : #'self-updating',
	#'squeak_changestamp' : 'ct 2/22/2026 01:12'
}
BaselineOfMethodMorse >> installDependencies [
	"Install most important dependencies. Metacello>>#get is not recursive."

	Metacello new
		baseline: 'CtAppFramework';
		repository: 'github://LinqLover/squeak-appframework:main';
		get;
		load.
	(Smalltalk hasClassNamed: #YarosServer) ifTrue:
		[Metacello new
			baseline: 'Yaros';
			repository: 'github://LinqLover/yaros:main';
			get;
			load].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 5/26/2021 15:29'
}
BaselineOfMethodMorse >> projectClass [

	^ (self environment classNamed: #MetacelloCypressBaselineProject) ifNil: [super projectClass]
]
