wifiPass = require("config").getValue("wifiPass", "")
wifiSSID = require("config").getValue("wifiSSID", "") 

require("wlan").connect(wifiSSID, wifiPass, function()
  print("done")
  require("sensor").startSensor()
end)
