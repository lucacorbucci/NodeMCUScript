-- Script che rileva la temperatura tramite il sensore DHT22 collegato al NodeMCU
-- Collegamenti:
-- Dat del dht22 al D2 del nodemcu
-- GND del dht22 al G del nodemcu
-- VCC del dht22 al 3V del nodemcu

function GetSensorData()
    print( "Rilevando la temperatura...." )
    -- 2 perchè il cavo dupont è collegato al D2 del nodemcu
    pin = 2
    status, temp, humi, temp_dec, humi_dec = dht.read(pin)
    if status == dht.OK then
        print("Temperatura:"..temp..";".."Umidità:"..humi)
    elseif status == dht.ERROR_CHECKSUM then
        print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
        print( "DHT timed out." )
    end
end

-- MAIN
tmr.alarm(1, 1000, 1, function() GetSensorData() end)
