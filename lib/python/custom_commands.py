import ctypes   # for lock screen


def execute(cmd: str):
    if (cmd == 'lock'):
        user32 = ctypes.WinDLL('user32')
        user32.LockWorkStation()
