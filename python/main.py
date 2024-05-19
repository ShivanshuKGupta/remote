import json
import platform
import socket
import time

import server_utils
from tools import bindSocket, cls, dbg, get_ip_addresses, setHostNPort


# Accepts a connection request and Serves it (if a connection request is made else returns False)
# Returns whether a connection was served or not
def acceptConnectionAndServe(sct) -> bool:
    try:
        conn, addr = sct.accept()
        print(f'Client App connected from {addr}')
    except socket.error as e:
        if e.errno != socket.errno.EWOULDBLOCK:
            print(e)
        return False

    # serving the client
    server_utils.serve_connection(conn)

    # service finished / disconnected
    conn.close()
    return True


def handleBroadcastSignals(sct, thisDeviceIP: str, thisDevicePort: int):
    while (True):
        try:
            msg, clientAddr = sct.recvfrom(1024)
        except socket.error as e:
            if e.errno != socket.errno.EWOULDBLOCK:
                print("Socket error:", str(e))
            return None, None
        try:
            obj = json.loads(msg.decode())
            dbg(f"Received json obj: {obj} from {clientAddr}")
        except:
            dbg(f"Invalid format of msg: {msg} from {clientAddr}")
            return None, None
        dbg(f"Sending acknowledgment back to the client")
        dbg(f"action={obj['action']}")
        ack_msg = {
            "app-type": "server-app",
            "platform": platform.system(),
            "name": socket.gethostname(),
            "ip": thisDeviceIP,
            "port": thisDevicePort,
            "action": 'accept' if obj['action'] == 'connect' else 'ready',
        }
        sct.sendto(json.dumps(ack_msg).encode(), clientAddr)
        if (obj['action'] == 'connect'):
            return clientAddr


# Main Code =======================


print("In case you don't have the app or want instructions on how to use it,\ngo here: https://github.com/ShivanshuKGupta/remote/releases/latest")


while (True):
    ip_addr = socket.gethostbyname(socket.gethostname())
    host, port = setHostNPort(get_ip_addresses(), ip_addr, 8080)

    if (host is None):
        print("You are not connected to a network.")
        while (True):
            new_ip_addr = socket.gethostbyname(socket.gethostname())
            if (new_ip_addr != ip_addr):
                cls()
                print("Network change detected")
                ip_addr = new_ip_addr
                host = None
                break
            time.sleep(1)
        continue

    sct = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sct.setblocking(False)
    discovery_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    discovery_socket.setblocking(False)

    port, discovery_port = bindSocket(sct, host, port), bindSocket(
        discovery_socket, host, port-1, -1)

    sct.listen()

    dbg(f'Server listening on {host}:{port}')
    dbg(f'Discovery server listening on {host}:{discovery_port}')
    print(
        f"Scan for device '{socket.gethostname()}({platform.system()})' in the remote app")
    print(
        f"Or if scanning doesn't works then connect to {host}:{port} manually.")

    keepRunning = True
    while (keepRunning):
        keepRunning = not acceptConnectionAndServe(sct)
        handleBroadcastSignals(discovery_socket, host, port)
        time.sleep(1)
        new_ip_addr = socket.gethostbyname(socket.gethostname())
        if (new_ip_addr != ip_addr):
            cls()
            print("Network change detected")
            ip_addr = new_ip_addr
            host = None
            break
    sct.close()
    discovery_socket.close()
