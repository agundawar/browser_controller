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

	def stop
		@controller.stop
	end

	def cleanup
		@controller.cleanup
	end

end

c = Controller.new

# w = WindowsController.new
# w.setup('Firefox', 'firefox', nil, 'http://www.techcrunch.com')
# w.start
# w.stop

# c.setup('firefox', nil, 'http://www.techcrunch.com')
# c.start
# sleep(5)
# c.stop

# REST Endpoints
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
		sucess = c.start
		if sucess
			status 200
			{'message' => 'Browser start sucess'}.to_json
		else
			status 500
			{'message' => 'Browser start failed'}.to_json
		end
	end
end

get '/stop/' do
	puts "#{Time.now} Stop browser request"
	sucess = c.stop
	if sucess
		status 200
		{'message' => 'Browser stop sucess'}.to_json
	else
		status 500
		{'message' => 'Browser stop failed'}.to_json
	end
	end

get '/cleanup/' do
	puts "#{Time.now} Cleanup browser request"
	c.cleanup
end
