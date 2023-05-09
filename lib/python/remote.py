import socket
from time import sleep
from pyautogui import hotkey
import mss
import base64
import os
import subprocess
import sys

developer_mode: bool = False


def dprint(msg):
    if (developer_mode):
        print(msg)


if (len(sys.argv) > 1):
    for arg in sys.argv:
        if (arg == '--help' or arg == '-h'):
            print("Contact shivanshukgupta at github/linkedin for more info")
        elif (arg == '-d'):
            print("Remote running in developer mode")
            developer_mode = True

ipconfig = str(subprocess.check_output(['ipconfig'], shell=False))

start = ipconfig.find("IPv4 Address")
if (start == -1):
    print('Make Sure that you are connected to a network then try again.')
    os.system('pause')
    exit(0)

addresses = []

while (start != -1):
    while (ipconfig[start] != ':'):
        start += 1
    while (not ipconfig[start].isnumeric()):
        start += 1
    ipaddr = ""
    while (ipconfig[start].isnumeric() or ipconfig[start] == '.'):
        ipaddr += ipconfig[start]
        start += 1
    addresses.append(ipaddr)
    ipconfig = ipconfig[start::]
    start = ipconfig.find('IPv4 Address')

DEF_HOST = socket.gethostbyname(socket.gethostname())
if (not DEF_HOST.startswith('192')):
    for addr in addresses:
        if (addr.startswith('192')):
            DEF_HOST = addr
            break

DEF_DELAY_TIME = 0.1

host = DEF_HOST
delayTime = DEF_DELAY_TIME
port = 8080

if (developer_mode):
    print(f"IPv4 Addresses: {addresses}")
    host = input(f"Enter required ip address [default={DEF_HOST}]:")
    if (len(host) == 0):
        host = DEF_HOST
    port = input('Enter port [default=8080]:')
    if (len(port) == 0):
        port = 8080
    else:
        port = int(port)
    delayTime = input(f'Enter delayTime (in sec)[default={DEF_DELAY_TIME}]:')
    if (len(delayTime) == 0):
        delayTime = DEF_DELAY_TIME
    else:
        delayTime = float(delayTime)

while (True):
    with mss.mss() as sct:
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
                    dprint(f'Received from client: {response}')
                    responses = response.split(sep=',')
                    for r in responses:
                        if (len(r) > 0):
                            if (len(r) > 3 and r[0:3] == 'os:'):
                                cmd = r[3::]
                                os.system(cmd)
                            elif (len(r) > len('custom:') and r[0:len('custom:')] == 'custom:'):
                                cmd = r[len('custom:')::]
                                if (cmd == 'lock'):
                                    import ctypes
                                    user32 = ctypes.WinDLL('user32')
                                    user32.LockWorkStation()
                                pass
                            else:
                                hotkey(*r.split('+'))

                    sleep(delayTime)
                    sct.shot(output='screenshot.png')
                    with open('screenshot.png', 'rb') as f:
                        image_bytes = f.read()

                    image_base64 = base64.b64encode(image_bytes)
                    separator = '\''.encode()

                    conn.sendall(separator)
                    dprint(f"sent: {separator}")
                    conn.sendall(image_base64)
                    conn.sendall(separator)

                    dprint('screenshot sent!')
                    os.system("del screenshot.png")
