import time
import ctypes
import threading
from pystray import Icon, MenuItem, Menu
from PIL import Image, ImageDraw

running = True
ES_CONTINUOUS = 0x80000000
ES_SYSTEM_REQUIRED = 0x00000001
ES_DISPLAY_REQUIRED = 0x00000002

def keep_awake():
    while running:
        ctypes.windll.kernel32.SetThreadExecutionState(
            ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED
        )
        time.sleep(30)

def create_image():
    size = 64
    image = Image.new("RGB", (size, size), "black")
    draw = ImageDraw.Draw(image)
    draw.ellipse((16, 16, 48, 48), fill="green")
    return image

def quit_app(icon, item):
    global running
    running = False
    icon.stop()

def main():
    icon = Icon("KeepAwake")
    icon.icon = create_image()
    icon.title = "KeepAwake"
    icon.menu = Menu(MenuItem("Exit", quit_app))
    threading.Thread(target=keep_awake, daemon=True).start()
    icon.run()

if __name__ == "__main__":
    main()
