import pyperclip
import time

last_clipboard = ""

while True:
    try:
        current = pyperclip.paste()
        if current != last_clipboard:
            if current.startswith("frontend/"):
                modified = current[len("frontend/"):]
                pyperclip.copy(modified)
                last_clipboard = modified
            else:
                last_clipboard = current
    except Exception as e:
        print(f"Error: {e}")
    
    time.sleep(0.5)