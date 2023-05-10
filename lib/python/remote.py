import socket
from time import sleep

# Command Definitions
import custom_commands
import keyboard_commands
import os_commands

# Tools
import screenshot
from tools import *

host, delayTime, port = setHostNPort(addresses=get_ip_addresses(
), DEF_HOST=socket.gethostbyname(socket.gethostname()), DEF_DELAY_TIME=0.1, DEF_PORT=8080)


def iterate():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((host, port))
        s.listen()
        print(f'Server listening on {host}:{port}')
        conn, addr = s.accept()

        with conn:
            print(f'Client connected from {addr}')
            while True:
                try:
                    data = conn.recv(1024)
                except:
                    print(f"Client malfunctioned.")
                    exit(0)
                if not data:
                    print('Disconnected')
                    break
                response = data.decode()
                dbg(f'Received from client: {response}')
                responses = response.split(sep=',')
                for r in responses:
                    if (len(r) > 0):
                        if (len(r) > 3 and r[0:3] == 'os:'):
                            cmd = r[3::]
                            os_commands.execute(cmd)
                        elif (len(r) > len('custom:') and r[0:len('custom:')] == 'custom:'):
                            cmd = r[len('custom:')::]
                            custom_commands.execute(cmd)
                        else:
                            keyboard_commands.execute(r)
                sleep(delayTime)
                image_base64 = screenshot.get()

                separator = '\''.encode()
                conn.sendall(separator)
                dbg(f"sent: {separator}")
                conn.sendall(image_base64)
                conn.sendall(separator)

                dbg('screenshot sent!')


while (True):
    iterate()
