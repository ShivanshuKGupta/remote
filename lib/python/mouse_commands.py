import pyautogui as pg


def execute(cmd):
    x, y = pg.position()
    x += int(cmd['x'])  # change in the position of the pointer along x-axis
    y += int(cmd['y'])  # change in the position of the pointer along y-axis
    print(f"x={x}", f"y={y}")
    WIDTH, HEIGHT = pg.size()
    # Failsafe protection
    if (x >= WIDTH-1):
        x = WIDTH-2
    if (y >= HEIGHT-1):
        y = HEIGHT-2
    if (x <= 0):
        x = 1
    if (y <= 0):
        y = 1
    pg._mouseMoveDrag("move", x, y, 0, 0, duration=0, tween=None)
