class MacController

	def setup(app, browser, proxy=nil, url=nil)
		@app = app
		@proxy = proxy
		@url = url
	end

	def start
		command = 'open -a "' + @app + '"'
		
		if @url != nil
			command += ' "' + @url + '"  --args'
		end
		
		if @proxy != nil
			command += ' --proxy-server=' + @proxy
		end
		command += ' --default' if @app == "Google Chrome"
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

	def chrome_cleanup
		puts "Chrome cleanup called"
		user = ENV['USER']
		chrome_path = '/Users/' + user + '/Library/Application\\ Support/Google/Chrome/'
		chrome_cache_path = '/Users/' + user + '/Library/Caches/Google/Chrome/'
		# cleanup_commands = ["cp #{chrome_path}Default/Preferences .", "rm -rf #{chrome_path}", "rm -rf #{chrome_cache_path}", "mkdir #{chrome_path}", "touch #{chrome_path}First\\ Run", "mkdir #{chrome_path}Default", "cp ./Preferences #{chrome_path}Default/"]
		cleanup_commands = ["rm -rf #{chrome_path}", "rm -rf #{chrome_cache_path}", "mkdir #{chrome_path}", "touch #{chrome_path}First\\ Run"]
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
		user = ENV['USER']
		moz_path = '/Users/' + user + '/Library/Application\ Support/Firefox/'
		moz_profilepath = '/Users/' + user + '/Library/Application Support/Firefox/profiles.ini'
		moz_cache_path = '/Users/' + user + '/Library/Caches/Firefox/Profiles/'
		profile = nil
		file = File.new(moz_profilepath, "r")
		while (line = file.gets)
			if /Path=/ =~ line
				profile = line.split("=")[1].chomp
				break
			end
		end
		file.close
		return false if profile == nil
		cleanup_commands = ["cp #{moz_path}#{profile}/prefs.js .", "rm -rf #{moz_path}#{profile}/*", "rm -rf #{moz_cache_path}", "cp ./prefs.js #{moz_path}#{profile}/"]
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

	def safari_cleanup
		puts "Safari cleanup called"
		user = ENV['USER']
		safari_path = '/Users/' + user + '/Library/Safari/'
		safari_cache_path = '/Users/' + user + '/Library/Caches/com.apple.Safari'
		cleanup_commands = ["rm -rf #{safari_path}", "rm -rf #{safari_cache_path}"]
		cleanup_commands.each do |command|
			puts "Command to run #{command}"
			`#{command}`; result=$?.success?
			if !result
				puts "Error while running command"
				return false
			end
		end
		puts "Safari cleanup completed"
		return true
	end

	def cleanup(browser)
		case browser.downcase
			when "chrome" then self.chrome_cleanup
			when "firefox" then self.firefox_cleanup
			when "safari" then self.safari_cleanup
		end
	end
end