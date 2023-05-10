import mss
import base64
import os


def get():
    with mss.mss() as sct:
        sct.shot(output='screenshot.png')
        with open('screenshot.png', 'rb') as f:
            image_bytes = f.read()
        os.system("del screenshot.png")
        return base64.b64encode(image_bytes)
