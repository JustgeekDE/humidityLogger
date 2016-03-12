local moduleName = ...
local M = {}
_G[moduleName] = M

M.wifiTimer = 1

function M.connect(ssid, password, callback)
    wifi.sta.config(ssid, password)

    tmr.register(M.wifiTimer, 1000, tmr.ALARM_AUTO, function()
        ip = wifi.sta.getip()
        if (ip ~= nil) then
            print("Connected: " .. ip) 
            tmr.stop(M.wifiTimer)
            callback()
        end
    end)

    wifi.sta.connect()
    print("Connecting to:" .. ssid)
    tmr.start(M.wifiTimer)
end

function M.sendOutData(url, data)
  print("Sending out data to " .. url)
  print("payload: " .. data)
    http.post(url,
      'Content-Type: application/json\r\n',
      data,
      function(code, data)
      end)
end

return M
