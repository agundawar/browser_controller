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
		user = ENV['USERNAME']
		chrome_path = "C:\\Users\\#{user}\\AppData\\Local\\Google\\Chrome\\\"User Data\""
		cleanup_commands = ["del /Q /S /F #{chrome_path}", "rd /Q /S #{chrome_path}"]
		cleanup_commands.each do |command|
			puts "Command to run #{command}"
			`#{command}`; result=$?.success?
			if !result
				puts "Error while running command"
				return false
			end
		end
		puts "Chrome cleanup completed"
		return true
	end

	def firefox_cleanup
		puts "Firefox cleanup called"
		user = ENV['USERNAME']
		moz_path = "C:\\Users\\#{user}\\AppData\\Local\\Mozilla\\Firefox\\Profiles"
		cleanup_commands = ["del /Q /S /F #{moz_path}", "rd /Q /S #{moz_path}"]
		cleanup_commands.each do |command|
			puts "Command to run #{command}"
			`#{command}`; result=$?.success?
			if !result
				puts "Error while running command"
				return false
			end
		end
		puts "Firefox cleanup completed"
		return true
	end

	def explorer_cleanup
		puts "Explorer cleanup called"
		user = ENV['USERNAME']
		ie_path = "C:\\Users\\#{user}\\AppData\\Local\\Microsoft\\\"Internet Explorer\""
		history_path = "C:\\Users\\#{user}\\AppData\\Local\\Microsoft\\Windows\\History"
		cookies_path = "C:\\Users\\#{user}\\AppData\\Roaming\\Microsoft\\Windows\\Cookies"
		cleanup_commands = ["del /q #{ie_path}", "rd /Q /S #{ie_path}", "del /Q /S /F #{history_path}", "rd /Q /S #{history_path}", "del /Q /S /F #{cookies_path}", "rd /Q /S #{cookies_path}"]
		cleanup_commands.each do |command|
			puts "Command to run #{command}"
			`#{command}`; result=$?.success?
			if !result
				puts "Error while running command"
				return false
			end
		end
		puts "Explorer cleanup completed"
		return true		
	end
	
	def cleanup(browser)
		case browser.downcase
			when "chrome" then self.chrome_cleanup
			when "firefox" then self.firefox_cleanup
			when "explorer" then self.explorer_cleanup
		end
	end
end