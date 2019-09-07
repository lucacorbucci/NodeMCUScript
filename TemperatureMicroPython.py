
import dht
import machine
import time
from umqtt.simple import MQTTClient


def temperature():
  while(True):
      d = dht.DHT22(machine.Pin(4))
      d.measure()
      print(str(d.temperature()) + " " + str(d.humidity()))
      c = MQTTClient("client", "192.168.4.4")
      try:
        c.connect()
        c.publish("temperature", str(d.temperature()) + " " + str(d.humidity()))
      except:
        time.sleep(1)
      time.sleep(5)
      

temperature()
