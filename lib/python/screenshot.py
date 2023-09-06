import base64
import os
import socket

import mss
from tools import dbg


def send(conn: socket):
    image_base64 = 0
    with mss.mss() as ss:
        ss.compression_level = 9
        ss.shot(output='screenshot.png')
        with open('screenshot.png', 'rb') as f:
            image_bytes = f.read()
        os.system("del screenshot.png")
        image_base64 = base64.b64encode(image_bytes)
    separator = '\''.encode()
    while (True):
        try:
            conn.sendall(separator)
        except socket.error as e:
            if e.errno == socket.errno.EWOULDBLOCK:
                continue
            else:
                print("Socket error:", str(e))
                return
        break
    while (True):
        try:
            conn.sendall(image_base64)
        except socket.error as e:
            if e.errno == socket.errno.EWOULDBLOCK:
                continue
            else:
                print("Socket error:", str(e))
                return
        break
    while (True):
        try:
            conn.sendall(separator)
        except socket.error as e:
            if e.errno == socket.errno.EWOULDBLOCK:
                continue
            else:
                print("Socket error:", str(e))
                return
        break
