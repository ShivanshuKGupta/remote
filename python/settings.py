import socket
import json

# tools
from tools import dbg


class settings:
    @classmethod
    def initialize(cls, data: str):
        settings = json.loads(data)

        cls.receiveImage: bool = settings['receiveImage']
        dbg(f"settings['receiveImage'] = {settings['receiveImage']}")
        cls.delayTime: float = settings['delayTime']
        dbg(f"settings['delayTime'] = {settings['delayTime']}")
