### Simple Browser Controller

Simple server controlling the different browsers on machine. Command to run the app - "ruby browser_controller.rb"

Port used 8080

### Libraries used
	- sinatra


### Endpoints supported

	-	POST /start/:browser : To start the browser on the server (Allowed values for browser - "firefox", "chrome", "safari", "explorer"). Also accepts JSON body with "key" & "proxy" as optional parameters

	-	GET /stop : To stop the browser


### OS supported

	-	Mac machines
	
	-	Windows machines