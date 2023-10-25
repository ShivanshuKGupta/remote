import json
import os
import socket
from time import \
    sleep  # for delay in between command execution and taking screenshot

# command definitions
import custom_commands
import keyboard_commands
import mouse_commands
import os_commands
import screenshot
import scroll_commands
from settings import settings
# tools
from tools import dbg


def serve_connection(conn: socket):
    ip_addr = socket.gethostbyname(socket.gethostname())
    # serving the client
    while True:
        # blocking until we receive data
        try:
            data = conn.recv(1024)
        except socket.error as e:
            if e.errno == socket.errno.EWOULDBLOCK:
                new_ip_addr = socket.gethostbyname(socket.gethostname())
                if (new_ip_addr != ip_addr):
                    ip_addr = new_ip_addr
                    break
                continue  # do nothing
            else:
                print(f"Socket error: {str(e)}")
                break
        except:
            os.system('cls')
            print(f"Connection was forcibly closed.")
            break
        if not data:
            os.system('cls')
            print('Disconnected')
            break

        # decoding the data received
        response = data.decode()
        dbg(f'Received from client: {response}')
        for each_command in data.decode().split(';'):
            if (len(each_command) < 1):
                break
            dbg(f"Executing command: {each_command}")
            try:
                response: map = json.loads(each_command)
            except:
                dbg(f'error decoding json string: {response}')
                break

            # reacting to the input
            keys = response.keys()
            if ('settings' in keys):
                settings.initialize(response['settings'])
            if ('keyboard' in keys):
                keyboard_commands.execute(response['keyboard'])
                if (settings.receiveImage):
                    sleep(settings.delayTime)
                    screenshot.send(conn)
                    dbg('screenshot sent!')
            if ('custom' in keys):
                custom_commands.execute(response['custom'])
            if ('os' in keys):
                os_commands.execute(response['os'])
            if ('mouse' in keys):
                mouse_commands.execute(json.loads(response['mouse']))
            if ('scroll' in keys):
                scroll_commands.execute(response['scroll'])
