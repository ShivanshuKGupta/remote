import socket
import time
import os

import server_utils

# Tools
from tools import setHostNPort, get_ip_addresses, dbg

# Setting host and port - If automatic discovery is implemented in near
# future then the required should be coded here in the below function

print("In case you don't have the app or want instructions on how to use it,\ngo here: https://github.com/ShivanshuKGupta/remote/releases/latest")

ip_addr = socket.gethostbyname(socket.gethostname())
host, port = None, None

while (True):
    if port is None or host is None:
        host, port = setHostNPort(addresses=get_ip_addresses(
        ), DEF_HOST=ip_addr, DEF_PORT=8080)

    # socket creation
    sct = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    if (host is not None):
        # if connected to a network
        sct.setblocking(False)
        try:
            sct.bind((host, port))
        except OSError as osError:
            if (osError.errno == 10048):
                print(
                    f"Port {port} is busy. Retrying with port number: {port+1}")
                port += 1
                continue

        # listening for incoming connections - if multiple users want to use the same host
        # then this listen function needs to be changed
        sct.listen()

        # blocking until a client is connected
        dbg(f'Server listening on {host}:{port}')
        print(f"Enter {host} in the 'Enter Server Address' Field of the app")
        print(f"Enter {port} in the 'Enter Port Number' Field of the app")

        while (True):
            try:
                conn, addr = sct.accept()
                break
            except socket.error as e:
                if e.errno == socket.errno.EWOULDBLOCK:
                    time.sleep(1)
                    new_ip_addr = socket.gethostbyname(socket.gethostname())
                    if (new_ip_addr != ip_addr):
                        print("Network change detected")
                        ip_addr = new_ip_addr
                        host = None
                        break
                else:
                    print("Socket error:", str(e))
                    host = None
            except KeyboardInterrupt:
                # Handling Ctrl+C
                exit(0)

        if (host is None):
            continue

        print(f'Client App connected from {addr}')

        # serving the client
        server_utils.serve_connection(conn)

        # service finished / disconnected
        conn.close()
        sct.close()
    else:
        print("You are not connected to a network")
        while (True):
            new_ip_addr = socket.gethostbyname(socket.gethostname())
            if (new_ip_addr != ip_addr):
                print("Network change detected")
                ip_addr = new_ip_addr
                break
            time.sleep(1)
