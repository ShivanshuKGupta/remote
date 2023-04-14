import socket
from pyautogui import hotkey
import mss
import base64

HOST = socket.gethostbyname(socket.gethostname())
PORT = 8080

while (True):
    with mss.mss() as sct:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind((HOST, PORT))
            s.listen()
            print(f'Server listening on {HOST}:{PORT}')
            conn, addr = s.accept()

            with conn:
                print(f'Client connected from {addr}')
                while True:
                    data = conn.recv(1024)
                    if not data:
                        print('Disconnected')
                        break
                    response = data.decode()
                    print(f'Received from client: {response}')
                    responses = response.split(sep=',')
                    for r in responses:
                        if (len(r) > 0):
                            hotkey(r)

                    sct.shot(output='screenshot.png')
                    with open('screenshot.png', 'rb') as f:
                        image_bytes = f.read()

                    image_base64 = base64.b64encode(image_bytes)
                    data_len = str(len(image_base64)).encode()
                    conn.sendall(image_base64)
                    print('screenshot sent!')
