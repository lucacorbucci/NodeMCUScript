import socket
import sys

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

server_address = ('116.203.183.105', 10000)
sock.bind(server_address)
sock.listen(1)

while True:
    connection, client_address = sock.accept()
    firstData = sys.getsizeof(int())
    received = 0
    try:
        while True:
            data = connection.recv(firstData)
            print >>sys.stderr, 'received "%s"' % data
            secondLen = int(data)
            completeData = ""
            read = 0
            while(read < secondLen):
                secondData = connection.recv(secondLen)
                read += len(secondData)
                completeData += secondData

            print >>sys.stderr, 'received "%s"' % completeData
            break

    finally:
        connection.close()
