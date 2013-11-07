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
				try
					opts.content = coffee.compile(opts.content, compileOptions)
				catch err
					if err.location
						start = "#{err.location.first_line}:#{err.location.first_column}"
						finish = "#{err.location.last_line}:#{err.location.last_column}"
						err.message += " at #{fileFullPath}:#{start}"
						err.message += " to #{finish}"  if finish isnt start
					return err

			# Done
			return