import subprocess
import os
import sys
from tools import *


def dbg(msg):
    print(msg)


def get_ip_addresses():
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
    return addresses


def setHostNPort(addresses, DEF_HOST, DEF_PORT):
    developer_mode = False
    port = DEF_PORT
    host = DEF_HOST

    if (len(sys.argv) > 1):
        for arg in sys.argv:
            if (arg == '--help' or arg == '-h'):
                print("Contact shivanshukgupta at github/linkedin for more info")
            elif (arg == '-d'):
                print("Remote running in developer mode")
                developer_mode = True

    if (not DEF_HOST.startswith('192')):
        for addr in addresses:
            if (addr.startswith('192')):
                DEF_HOST = addr
                break

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
    return host, port
