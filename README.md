A basic humidity / temprature logger system using a DHT11 sensor with a ESP8266 controller.

Backend
=======
In the backend folder you can find the nodeJS app to store the sensor data

To automatically setup the backend on an raspberry pi, you can use ansible:

    ansible-playbook -i hosts basic-setup.yml --ask-pass


Sensor
======
In `sensor/src/` you can find the lua scripts for the ESP8266. You will need a NodeMCU build with the `cjson, http, file` and `DHT` modules enabled.    
After loading the src code onto the ESP module execute 

    require("config").setValue("wifiSSID", "YOUR NETWORK NAME") 
    require("config").setValue("wifiPass", "YOUR NETWORK PASS") 
    require("config").setValue("sensorId", "YOUR SENSOR ID") 
    require("config").setValue("logEndpoint", "URL OF NODE APP") 

in the interactive shell, to set the necessary configuration values.
