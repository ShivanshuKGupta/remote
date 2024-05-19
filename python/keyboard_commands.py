from pyautogui import hotkey


def execute(cmd: str):
    hotkey(*cmd.split('+'))
