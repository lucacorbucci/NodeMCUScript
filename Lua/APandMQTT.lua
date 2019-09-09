wifi.setmode(wifi.SOFTAP)   -- set AP parameter
config = {}
config.ssid = "NodeMCU"
config.pwd = "password"
wifi.ap.config(config)

config_ip = {}  -- set IP,netmask, gateway
config_ip.ip = "192.168.2.1"
config_ip.netmask = "255.255.255.0"
config_ip.gateway = "192.168.2.1"
wifi.ap.setip(config_ip)

client = mqtt.Client("nodeMCU", 30, "username", "password")
print(client:connect("192.168.2.3", 1883, 0))
-- mqtt:publish(topic, payload, qos, retain[, function(client)])
client:publish("testm", "hello", 0, 0)
