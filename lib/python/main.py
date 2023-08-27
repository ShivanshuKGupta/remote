import socket

import server_utils

# Tools
from tools import setHostNPort, get_ip_addresses, dbg

# Setting host and port - If automatic discovery is implemented in near
# future then the required should be coded here in the below function
host, port = setHostNPort(addresses=get_ip_addresses(
), DEF_HOST=socket.gethostbyname(socket.gethostname()), DEF_PORT=8080)

print("In case you don't have the app or want instructions on how to use it,\ngo here: https://github.com/ShivanshuKGupta/remote/releases/latest")

while (True):
    # socket creation
    sct = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sct.bind((host, port))

    # listening for incoming connections - if multiple users want to use the same host
    # then this listen function needs to be changed
    sct.listen()

    # blocking until a client is connected
    dbg(f'Server listening on {host}:{port}')
    print(f"Enter {host} in the 'Enter Server Address' Field of the app")
    print(f"Enter {port} in the 'Enter Port Number' Field of the app")
    conn, addr = sct.accept()
    print(f'Client App connected from {addr}')

    # serving the client
    server_utils.serve_connection(conn)

    # service finished / disconnected
    conn.close()
    sct.close()
