import dht
import machine
import time


def checkTemperature():
    while(True):
        d = dht.DHT22(machine.Pin(4))
        d.measure()
        print(str(d.temperature()) + " " + str(d.humidity()))
        c = MQTTClient("client", "192.168.4.4")
        c.connect()
        c.publish("dev", "Hello World")
        time.sleep(3600)
