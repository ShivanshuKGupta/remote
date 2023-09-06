import json
import os
import platform
import socket
import time

# Tools
from tools import dbg

discoveryHost = ""
discoveryPort = 8079
discoverySocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


def initDiscoverySocket():
    global discoveryHost
    global discoveryPort
    global discoverySocket
    discoveryHost = ""
    discoveryPort = 8079
    discoverySocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    dbg(f"discoveryPort={discoveryPort}")


def makeServerVisible(host):
    global discoveryHost
    global discoveryPort
    global discoverySocket
    dbg(f"discoveryPort={discoveryPort}")
    if discoveryHost == host:
        return
    if (discoverySocket != None):
        try:
            discoverySocket.close()
        except socket.error as e:
            print(f"Error closing socket: {e}")
    discoveryHost = host
    discoverySocket.bind((discoveryHost, discoveryPort))
    discoverySocket.setblocking(False)


def hideServer():
    global discoveryHost
    global discoveryPort
    global discoverySocket
    discoveryHost = None
    discoverySocket.close()


def acceptConnection(host):
    global discoveryHost
    global discoveryPort
    global discoverySocket
    clientAddr = None, None

    k = 0
    try:
        msg, clientAddr = discoverySocket.recvfrom(1024)
    except socket.error as e:
        if e.errno == socket.errno.EWOULDBLOCK:
            return None, None
        else:
            print("Socket error:", str(e))
            return None, None
    try:
        obj = json.loads(msg.decode())
        dbg(f"Received json obj: {obj} from {clientAddr}")
    except:
        dbg(f"Invalid format of msg: {msg} from {clientAddr}")
        return None, None

    dbg(f"Sending acknowledgment back to the client ({k}times)")
    k += 1
    ack_msg = {
        "app-type": "server-app",
        "platform": platform.system(),
        "name": socket.gethostname(),
        "ip": host,
        "port": discoveryPort,
        "action": 'accept' if obj['action'] == 'connect' else 'ready',
    }
    discoverySocket.sendto(json.dumps(ack_msg).encode(), clientAddr)
    if (obj['action'] == 'connect'):
        return clientAddr
    return None, None
