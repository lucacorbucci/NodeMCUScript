import dht
import machine
import time
from umqtt.simple import MQTTClient


def temperature():
    while(True):
        try:
            d = dht.DHT22(machine.Pin(4))
            d.measure()
        
            c = MQTTClient('client', '192.168.4.4')
        
            c.connect()
            c.publish('temperature', str(d.temperature()) + ' ' + str(d.humidity()))
        except:
            time.sleep(1)
        time.sleep(5)

temperature()
