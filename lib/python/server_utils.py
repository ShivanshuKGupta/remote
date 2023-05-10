from time import sleep  # for delay in between command execution and taking screenshot
import socket
import json

# command definitions
import custom_commands
import keyboard_commands
import os_commands

# tools
from tools import dbg
import screenshot
from settings import settings


def serve_connection(conn: socket):
    # serving the client
    while True:
        # blocking until we receive data
        try:
            data = conn.recv(1024)
        except:
            print(f"Connection was forcibly closed.")
            break
        if not data:
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

            keys = response.keys()
            if ('settings' in keys):
                settings.initialize(response['settings'])
            if ('keyboard' in keys):
                keyboard_commands.execute(response['keyboard'])
            if ('custom' in keys):
                custom_commands.execute(response['custom'])
            if ('os' in keys):
                os_commands.execute(response['os'])

            # json.dumps({})
            # json.loads(str)

            # responses = response.split(sep=',')
            # for r in responses:
            #     if (len(r) > 0):
            #         if (len(r) > 3 and r[0:3] == 'os:'):
            #             cmd = r[3::]
            #             os_commands.execute(cmd)
            #         elif (len(r) > len('custom:') and r[0:len('custom:')] == 'custom:'):
            #             cmd = r[len('custom:')::]
            #             custom_commands.execute(cmd)
            #         else:
            #             keyboard_commands.execute(r)

        if (settings.receiveImage):
            sleep(settings.delayTime)
            screenshot.send(conn)

        dbg('screenshot sent!')
