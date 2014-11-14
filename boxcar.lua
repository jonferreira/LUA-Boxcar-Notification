-- Original code here
-- https://bitbucket.org/manubing/lua-notifo
-------------------------------------
-- Send a BoxcarV2 notification
--
-- @param user_credentials: This is where you pass your access token. Your access token can be found in Boxcar global setting pane. It is a string composed of letters and numbers. Do not confuse it with your Boxcar email address.
--
-- @param notification[title]: This parameter will contain the content of the alert and the title of the notification in Boxcar. Max size is 255 chars.
--
-- @param notification[long_message]: This is where you place the content of the notification itself. It can be either text or HTML. Max size is 4kb.
--
-- @param notification[sound] (optional):This is were you define the sound you want to play on your device. As a default, the general sound is used, if you omit this parameter. General sound typically default to silent, but if you changed it, you can force the notification to be silent with the "no-sound" sound name.
--
-- @param notification[source_name] (optional): This is a short source name to show in inbox. Default is "Custom notification".
--
-- @param notification[icon_url] (optional): This is where you define the icon you want to be displayed within the application inbox?.
--
-- @param notification[open_url] (optional): If defined, Boxcar will redirect you to this url when you open the notification from the Notification Center. It can be a http link like http://maps.google.com/maps?q=cupertino or an inapp link like twitter:///user?screen_name=vutheara??

-------------------------------------
function boxcar_notification (user_credentials, title, long_message, sound, source_name, icon_url, open_url)
	--	put here your api key
	--local user_credentials = 'user_credentials'
	local source_name = source_name or 'Vera'

	local https = require 'ssl.https'
	local ltn12 = require 'ltn12'

	-- utility method to make text URL friendly
	function url_encode(str)
	  if (str) then
	    str = string.gsub (str, "\n", "\r\n")
	    str = string.gsub (str, "([^%w ])",
	        function (c) return string.format ("%%%02X", string.byte(c)) end)
	    str = string.gsub (str, " ", "+")
	  end
	  return str   
	end

	local request_body = 'user_credentials=' .. url_encode(user_credentials) .. '&notification[title]=' .. title .. '&notification[long_message]=' .. long_message
	if (sound) then request_body = request_body .. '&notification[sound]=' .. url_encode(sound) end
	if (source_name) then request_body = request_body .. '&notification[source_name]=' .. url_encode(source_name) end
	if (icon_url) then request_body = request_body .. '&notification[icon_url]=' .. url_encode(icon_url) end
	if (open_url) then request_body = request_body .. '&notification[open_url]=' .. url_encode(open_url) end
	local response_body = {}

	b, c, h = https.request {
	  url = 'https://new.boxcar.io/api/notifications',
	  method = 'POST',
	  headers = {
	    ["Content-Type"] =  "application/x-www-form-urlencoded",
			["Content-Length"] = string.len(request_body)
		},
	  source = ltn12.source.string(request_body),
	  sink = ltn12.sink.table(response_body),
	}

end
