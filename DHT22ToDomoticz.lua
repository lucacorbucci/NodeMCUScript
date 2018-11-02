-- Collegamenti:
-- Dat del dht22 al D2 del nodemcu
-- GND del dht22 al G del nodemcu
-- VCC del dht22 al 3V del nodemcu
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
        -- Stoppiamo l'alarm con id 0
        tmr.stop(0)

        disconnected = 0
        -- Creo un secondo alarm con id 1 che parte solamente dopo che sono sicuro che 
        -- siamo connessi al wifi
        tmr.alarm(1,2000,1,function()
            -- Controlliamo ogni volta di essere connessi al wifi
            -- Se siamo offline blocchiamo l'alarm con id 1 e parte l'alarm con id2
            if wifi.sta.getip() == nil then
                print("Connessione alla Wifi...\n")
                disconnected = 1
                tmr.stop(1)
                tmr.start(2)
            else
       
                -- Se va tutto bene rileviamo i dati tramite il sensore e li mandiamo tramite MQTT a Domoticz
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
    
        -- Quando ho una disconnessione attivo l'alarm 2, questo controlla se la connessione 
        -- è tornata a funzionare e poi quando ci siamo connessi di nuovo ad internet va a disconnettere
        -- il client MQTT precedentemente creato e poi ad aprire una nuova connessione verso domoticz
        -- Poi alla fine blocchiamo questo alarm e torniamo nell'altro in cui inviamo i dati a domoticz.
        -- è brutto ma funziona quindi va bene così. Tutte le print sono inutili ma ora non ho voglia di toglierle.
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

    end
end)


