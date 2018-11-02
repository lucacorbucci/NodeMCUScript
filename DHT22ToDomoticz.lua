
-- Collego a D2 = GPIO 4 il pin Data del DHT22
pin = 2

-- setto il modulo wifi in station mode
print("AVVIO WIFI")
wifi.setmode(wifi.STATION)
-- setto i parametri di connessione alla rete
config = {}
config.SSID = {}
config.SSID["nome_rete"] = "password"
config.save = true


-- Verifico connessione, poi stampo in seriale info rete
tmr.alarm(0, 2000, 1, function()
    if wifi.sta.getip() == nil then
        print("Connessione alla Wifi...\n")
    else
        client = mqtt.Client("nodeMCU", 30, "username", "password")

        client:connect("192.168.1.100", 1883, 0)
        
        tmr.stop(0)

   end
end)

disconnected = 0
tmr.alarm(1,2000,1,function()

    if wifi.sta.getip() == nil then
        print("Connessione alla Wifi...\n")
        disconnected = 1
        tmr.stop(1)
        tmr.start(2)
    else
       
        
        pin = 2
        status, temp, humi, temp_dec, humi_dec = dht.read(pin)
        if status == dht.OK then
         
        
            print(client)
            if client:publish("domoticz/in",string.format('{ "idx" : 5, "nvalue" : 0, "svalue" : "%d.%d" }', temp, temp_dec),0,0) == false then
                print("false")
            else
                print("inviato")
            end
            
            print(client:publish("domoticz/in",string.format('{ "idx" : 6, "nvalue" : %d, "svalue" : "0" }', humi),0,0))
            
        end
    end
    
end)

tmr.alarm(2,2000,1, function()

    if wifi.sta.getip() == nil then
        print("Connessione alla Wifi...\n")
        
    else
        disconnected = 0
        print(client:close())
        client = mqtt.Client("id2", 120, "username", "password")
        print(client:connect("192.168.1.100", 1883, 0))
        tmr.stop(2)
        tmr.start(1)
    end
end)

