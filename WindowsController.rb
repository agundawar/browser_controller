class WindowsController

	def setup(app, browser, proxy=nil, url=nil)
		@app = app
		@browser = browser
		@proxy = proxy
		@url = url
	end

	def start
		command = 'start ' + @browser
		
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
		command = 'taskkill /F /IM ' + @browser
		puts "Command to run #{command}"
		`#{command}` ;  result=$?.success?
		result
	end

	def cleanup
	end
end