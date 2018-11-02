-- Collegamenti:
-- Dat del dht22 al D2 del nodemcu
-- GND del dht22 al G del nodemcu
-- VCC del dht22 al 3V del nodemcu

----
-- Fonte: https://ciaobit.com/mcu/esp8266/nodemcu-esp8266-e-dht22-am2302-sensore-di-temperatura-e-umidita-wifi-con-server-web/
----
pin = 2

-- setto il modulo wifi in station mode
print("AVVIO WIFI")
wifi.setmode(wifi.STATION)
-- setto i parametri di connessione alla rete. Va fatto così altrimenti non funziona
config = {}
config.SSID = {}
config.SSID["nomeRete"] = "password"
config.save = true


-- Quando mi sono connesso stampo i dati della connessione
tmr.alarm(0, 5000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connessione alla Wifi...\n")
   else
      ip, netmask, gateway=wifi.sta.getip()
      print("Info Rete: \nIP: ",ip)
      print("Netmask: ",netmask)
      print("Gateway: ",gateway,'\n')
      -- la funzione stop prende 0 perchè 0 è l'id dell'alarm creato sopra
      tmr.stop(0)

      
    
     -- Avvio di un server web
      srv=net.createServer(net.TCP)
      print("server pronto")
      srv:listen(80,function(conn)
        conn:on("receive",function(conn,payload)
         
         -- Chiedo al DHT22 temperatura e Umidità 
         status,temp,humi,temp_decimial,humi_decimial = dht.read(pin)
         if( status == dht.OK ) then
            print( "\nDati ricevuti dal DHT:\nTemperatura:"..temp.."."..temp_decimial); 
            print( "\nUmidita:"..humi.."."..humi_decimial);
            conn:send("<h1>Dati ricevuti dal DHT:</h1> &ltp>Temperatura:"..temp.."."..temp_decimial.."°C</p> <p>Umidita:"..humi.."."..humi_decimial.."%</p>")
         elseif( status == dht.ERROR_CHECKSUM ) then
            print( "DHT Errore Checksum" );
            conn:send("<h1> Hello, NodeMCU!!! </h1>")
         elseif( status == dht.ERROR_TIMEOUT ) then
            print( "DHT Time out." );
            conn:send("<h1> Hello, NodeMCU!!! </h1>")
         conn:send("<h1> Hello, NodeMCU!!! </h1>")
        end
      
      end)
      conn:on("sent",function(conn) conn:close() end)
    end)
      
   end
end)
