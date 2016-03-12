local moduleName = ...
local M = {}
_G[moduleName] = M

M.sensorPin = 4
M.sensorIntervall = 60000
M.timer = 2

function M.readSensor()
    status, temp, humi, temp_dec, humi_dec = dht.read11(M.sensorPin)
    print("Sensor status: " .. status)
    if status == dht.OK then
        print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
              math.floor(temp),
              temp_dec,
              math.floor(humi),
              humi_dec
        ))
    elseif status == dht.ERROR_CHECKSUM then
        print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
        print( "DHT timed out." )
    end    
end

function M.getSensorObject(name, value)
  sensor = {}
  sensor.name = name
  sensor.value = value
  return sensor
end

function M.sendOutSensorData()
    status, temp, humi, temp_dec, humi_dec = dht.read11(M.sensorPin)
    if status == dht.OK then
        local data = {}
        local sensorData = {}
        sensorData[1] = M.getSensorObject("humidity", (humi*1000)+humi_dec)
        sensorData[2] = M.getSensorObject("temperature", (temp*1000)+temp_dec)
    
        data.sensorId = require("config").getValue("sensorId", "unknown")
        data.sensors = sensorData
        
        endpoint = require("config").getValue("logEndpoint", "") 
        payload = require "cjson".encode(data)
        require("wlan").sendOutData(endpoint, payload)
    end
end

function M.startSensor()
    tmr.register(M.timer, M.sensorIntervall, tmr.ALARM_AUTO, function()
        M.sendOutSensorData()
    end)
    
    print("Starting data accquisition.")
    tmr.start(M.timer)
end

return M
