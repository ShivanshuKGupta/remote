import pyautogui as pg


def execute(cmd):
    x, y = pg.position()
    x += int(cmd['x'])  # percentage of screen width
    y += int(cmd['y'])  # percentage of screen height
    print(f"x={x}", f"y={y}")
    # WIDTH, HEIGHT = pg.size()
    # x = int(x * WIDTH)
    # y = int(y * HEIGHT)
    pg._mouseMoveDrag("move", x, y, 0, 0, duration=0, tween=None)
