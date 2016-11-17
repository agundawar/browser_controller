# Controller for Opening, Closing and Cleaning up the browser

require 'sinatra'
require 'json'


require './MacController'
require './WindowsController'

set :port, 8080

module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end

class Controller

	def initialize
		if OS.windows?
			@controller = WindowsController.new
		elsif OS.mac?
			@controller = MacController.new
		end
	end
				
	def setup(browser, proxy=nil, url=nil)
		case browser.downcase
		when 'chrome'
			@controller.setup("Google Chrome", "chrome.exe", proxy, url)
		when 'explorer'
			@controller.setup("Internet Explorer", "iexplore.exe", proxy, url)
		when 'safari'
			@controller.setup("Safari", "safari.exe", proxy, url)
		when 'firefox'
			@controller.setup("Firefox", "firefox.exe", proxy, url)
		end
	end

	def start
		@controller.start
	end

	def stop(browser)
		@controller.stop
	end

	def cleanup(browser)
		@controller.cleanup(browser)
	end

end

c = Controller.new

# # REST Endpoints
	post '/start/:browser' do
	puts "#{Time.now} Start browser request"
	request.body.rewind
	data = JSON.parse(request.body.read)
	browser = params[:browser]
	if data.has_key?("proxy")
		proxy = data["proxy"]
	end
	if data.has_key?("url")
		url = data["url"]
	end
	puts "#{Time.now} browser #{browser}, url #{url}, proxy #{proxy}"

	error = false
	if (!['chrome', 'firefox', 'safari', 'explorer'].include?(browser))
		error = true; message = "Browser not supported!"
	end
	if error
		status 400
		{'message' => message}.to_json
	else
		c.setup(params[:browser], proxy, url)
		success = c.start
		if success
			status 200
			{'message' => 'Browser start sucess'}.to_json
		else
			status 500
			{'message' => 'Browser start failed'}.to_json
		end
	end
end

get '/stop/:browser' do
	puts "#{Time.now} Stop browser request"
	success = c.stop params[:browser]
	if success
		status 200
		{'message' => 'Browser stop sucess'}.to_json
	else
		status 500
		{'message' => 'Browser stop failed'}.to_json
	end
	end

get '/cleanup/:browser' do
	puts "#{Time.now} Browser cleanup  request for #{params[:browser]}"
	success = c.cleanup params[:browser]
	if success
		status 200
		{'message' => 'Browser cleanup sucess'}.to_json
	else
		status 500
		{'message' => 'Browser cleanup failed'}.to_json
	end	
end
