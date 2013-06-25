# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class CoffeescriptPlugin extends BasePlugin
		# Plugin name
		name: 'coffeescript'

		# Plugin config
		config:
			compileOptions: {}

		# Render
		# Called per document, for each extension conversion. Used to render one extension to another.
		render: (opts) ->
			# Prepare
			{inExtension,outExtension,file} = opts
			literate = false

			# CoffeeScript to JavaScript
			if (inExtension in ['coffee','litcoffee'] and outExtension in ['js',null]) or (inExtension in ['md','markdown'] and outExtension is 'js' and literate = true)
				# Prepare
				coffee = require('coffee-script')
				fileFullPath = file.get('fullPath')
				compileOptions = {
					filename: fileFullPath
					literate: literate or coffee.helpers.isLiterate(fileFullPath)
				}

				# Merge options
				for own key,value of @getConfig().compileOptions
					compileOptions[key] ?= value

				# Render
				opts.content = coffee.compile(opts.content, compileOptions)

			# Done
			return