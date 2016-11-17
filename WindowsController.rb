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

	def chrome_cleanup
		puts "Chrome cleanup called"
	end

	def firefox_cleanup
		puts "Firefox cleanup called"
	end

	def explorer_cleanup
		puts "Explorer cleanup called"
	end
	
	def cleanup(browser)
		case browser.downcase
			when "chrome" then self.chrome_cleanup
			when "firefox" then self.firefox_cleanup
			when "iexplore" then self.explorer_cleanup
		end
	end
end