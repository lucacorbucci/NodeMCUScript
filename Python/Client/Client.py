import paho.mqtt.client as mqtt
import datetime
from pymongo import MongoClient
import sys
import socket


def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe("temperature")


def sendToServer(newData, size, sock):
    # Send data to Server
    try:
        print size
        sock.sendall(str(size))
        print("inviato")
        sock.sendall(newData)

        # received = 0
        # ackLen = sys.getsizeof(int())

        # while received < ackLen:
        #     data = sock.recv(10)
        #     amount_received += len(data)
        #     print >>sys.stderr, 'received "%s"' % data

    finally:
        sock.close()
        print("chiuso")


def connectToServer():
    # Connect the socket to the port where the server is listening
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        serverAddress = ('116.203.183.105', 10000)
        sock.connect(serverAddress)
        return sock
    except:
        print("Something went wrong Connection")


def saveToMongo(newData):
    # Save data to local mongo db database
    try:
        client = MongoClient('mongodb://localhost:27017/')
        db = client.temperature
        temperatureDB = db.temperature
        temperatureID = temperatureDB.insert_one(newData).inserted_id
    except:
        print("Something went wrong Save")


def on_message(client, userdata, msg):
    if msg.topic == 'temperature':
        temperature = msg.payload.split(" ")[0]
        umidity = msg.payload.split(" ")[1]
        date = str(datetime.datetime.now())
        newData = {'temperature': temperature,
                   'umidity': umidity,
                   'date': date}
        strData = str(newData)
        size = len(strData)
        saveToMongo(newData)
        sock = connectToServer()
        sendToServer(strData, size, sock)


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect("localhost", 1883, 60)
client.loop_forever()
