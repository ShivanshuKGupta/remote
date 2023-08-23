from pyautogui import scroll
from tools import dbg


def execute(value: float | int):
    dbg(f"got value of type: {type(value)}")
    dbg(f"Scrolling by {value}")
    scroll(value)
