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
					sourceFiles: [file.get('url') + '.coffee'] # but actually included inline
					generatedFile: file.get('url')
					literate: literate or coffee.helpers.isLiterate(fileFullPath)
				}

				# Merge options
				for own key,value of @getConfig().compileOptions
					compileOptions[key] ?= value

				# Render
				try
					compiled = coffee.compile(opts.content, compileOptions)

					if typeof compiled is 'object'
						{js, v3SourceMap} = compiled
					else
						js = compiled

					if v3SourceMap
						# Encode the coffeescript source directly into the sourcemap
						v3SourceMap = JSON.parse v3SourceMap
						v3SourceMap.sourcesContent = [opts.content]
						v3SourceMap = JSON.stringify v3SourceMap, null, 2

						# Base64 encode the sourcemap into the JS output
						js = "" +
							js +
							"\n//# sourceMappingURL=data:application/json;base64," +
							new Buffer(unescape(encodeURIComponent(v3SourceMap)), 'binary').toString('base64')

					opts.content = js

				catch err
					if err.location
						start = "#{err.location.first_line}:#{err.location.first_column}"
						finish = "#{err.location.last_line}:#{err.location.last_column}"
						err.message += " at #{fileFullPath}:#{start}"
						err.message += " to #{finish}"  if finish isnt start
					return err

			# Done
			return
