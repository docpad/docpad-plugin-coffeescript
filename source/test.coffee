# Determine CoffeeScript version
try
	require('coffeescript')
	coffeescriptVersion = 2
catch
	coffeescriptVersion = 1

# Test our plugin using DocPad's Testers
module.exports = require('docpad-plugintester').test({
	outExpectedPath: __dirname+"/../test/out-expected-v#{coffeescriptVersion}"
})
