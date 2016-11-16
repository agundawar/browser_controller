class MacController

	def setup(app, browser, proxy=nil, url=nil)
		@app = app
		@proxy = proxy
		@url = url
	end

	def start
		command = 'open -a "' + @app + '"'
		
		if @url != nil
			command += ' "' + @url + '"'
		end
		
		if @proxy != nil
			command += ' --args --proxy-server=' + @proxy
		end

		puts "Command to run #{command}"
		`#{command}` ;  result=$?.success?
		result
	end

	def stop
		command = 'osascript -e \'quit app "' + @app + '"\'' 
		puts "Command to run #{command}"
		`#{command}` ;  result=$?.success?
		result
	end

	def cleanup
	end
end