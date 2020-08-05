# Determine CoffeeScript version
try
	require('coffeescript')
	coffeescriptVersion = 2
catch
	coffeescriptVersion = 1

# Test our plugin using DocPad's Testers
require('docpad').require('testers').test({
	pluginPath: __dirname+'/..'
	testerClass: 'RendererTester'
	outExpectedPath: __dirname+"/../test/out-expected-v#{coffeescriptVersion}"
})