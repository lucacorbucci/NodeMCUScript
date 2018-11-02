# Script per NodeMCU

All'interno di questa repo ho caricato gli script che ho utilizzato (e utilizzo) sul nodeMCU. Nella maggior parte dei casi sono script che ho trovato su internet e ho poi adattato alle mie esigenze.

Tutti gli script sono stati testati con il seguente hardware:

- NodeMcu esp8266 (https://it.aliexpress.com/item/5pcs-lot-New-Wireless-module-NodeMcu-Lua-WIFI-Internet-of-Things-development-board-based-ESP8266-with/32266751149.html?spm=a2g0s.9042311.0.0.607d4c4dlGfHFr)
- Sensore DHT22 (https://it.aliexpress.com/item/High-Precision-AM2302-DHT22-Digital-Temperature-Humidity-Sensor-Module-For-Uno-R3/32292594513.html?spm=a2g0s.9042311.0.0.607d4c4dlGfHFr)
- 3 Cavi Dupont Femmina-Femmina

Software utilizzati:

- ESPLorer https://esp8266.ru/esplorer/
- NodeMCU PyFlasher https://github.com/marcelstoer/nodemcu-pyflasher
- Sito per generare il firmware del NodeMCU https://nodemcu-build.com

### Blink.Lua

Semplice script che permette di far lampeggiare il led presente sul NodeMCU.

### getDHT22Data.lua

Script che recupera il valore della temperatura e dell'umidità tramite il sensore DHT22 e poi lo stampa nella console di ESPLorer

### webServerTemperatura.lua

Script che connette il nodeMCU al wifi, successivamente viene rilevata la temperatura e il valore dell'umidità tramite il sensore DHT22. Poi viene creato un web server e collegandosi all'ip del nodeMCU possiamo visualizzare i valori della temperatura e dell'umidità

### DHT22ToDomoticz.lua

Script che permette di far comunicare il Node con Domoticz.
Per prima cosa ci si connette al Wifi e si avvia un client MQTT. 
Poi si rileva la temperatura e si invia il dato al server MQTT in azione sul rasberry.
Possiamo utilizzare questo script come init.lua del node, quando non c'è una rete wifi disponibile il Node si disconnette ma continua a cercare il wifi, quando lo trova si connette nuovamente e avvia di nuovo la connessione MQTT.
