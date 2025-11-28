#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Gtk4LayerShell', '1.0')

from gi.repository import Gtk, Gdk, Gtk4LayerShell, GLib
import json
import os
import subprocess
import signal
import sys

CONFIG_DIR = os.path.expanduser("~/.config/hypr")
CONFIG_FILE = os.path.join(CONFIG_DIR, "ruler-position.json")
PID_FILE = os.path.join(CONFIG_DIR, "ruler.pid")
CMD_FILE = os.path.join(CONFIG_DIR, "ruler.cmd")

# Track all ruler windows
h_rulers = []  # horizontal (top margin)
v_rulers = []  # vertical (left margin)
app_ref = None  # will store Gtk.Application


def get_mouse_pos():
    """Get global mouse (x, y) position from Hyprland."""
    try:
        result = subprocess.run(
            ['hyprctl', 'cursorpos'],
            capture_output=True,
            text=True
        )
        # Output format: "x, y"
        pos = result.stdout.strip().split(',')
        x = int(pos[0].strip())
        y = int(pos[1].strip())
        return x, y
    except Exception:
        return 0, 0


def load_positions():
    """
    Load stored ruler positions.
    Format (new):

        {
          "horizontal": [y1, y2, ...],
          "vertical": [x1, x2, ...]
        }

    Backward compatible with old formats.
    """
    try:
        with open(CONFIG_FILE, 'r') as f:
            data = json.load(f)

        # New format
        if isinstance(data, dict) and ("horizontal" in data or "vertical" in data):
            h = data.get("horizontal", [])
            v = data.get("vertical", [])
            h = list(map(int, h))
            v = list(map(int, v))
            if not h and not v:
                h = [200]
            return h, v

        # Older formats:
        # { "positions": [...] }  or  [ ... ]  or  { "margin_top": 200 }
        if isinstance(data, dict) and "positions" in data:
            h = list(map(int, data["positions"]))
            return h, []

        if isinstance(data, dict) and "margin_top" in data:
            return [int(data["margin_top"])], []

        if isinstance(data, list):
            return list(map(int, data)), []

        return [200], []
    except Exception:
        return [200], []


def save_positions():
    """Save positions of all current rulers (horizontal + vertical)."""
    os.makedirs(CONFIG_DIR, exist_ok=True)
    h_pos = [int(r.pos) for r in h_rulers]
    v_pos = [int(r.pos) for r in v_rulers]
    data = {
        "horizontal": h_pos,
        "vertical": v_pos,
    }
    with open(CONFIG_FILE, 'w') as f:
        json.dump(data, f)


class HorizontalRuler(Gtk.Window):
    """Horizontal line moving up/down (margin TOP)."""

    def __init__(self, app, margin_top):
        super().__init__(application=app)
        self.pos = margin_top  # y
        self.dragging = False
        self.offset = 0

        # 3 px high, full width
        self.set_default_size(-1, 3)

        Gtk4LayerShell.init_for_window(self)
        Gtk4LayerShell.set_layer(self, Gtk4LayerShell.Layer.OVERLAY)
        Gtk4LayerShell.set_exclusive_zone(self, 0)

        Gtk4LayerShell.set_anchor(self, Gtk4LayerShell.Edge.TOP, True)
        Gtk4LayerShell.set_anchor(self, Gtk4LayerShell.Edge.LEFT, True)
        Gtk4LayerShell.set_anchor(self, Gtk4LayerShell.Edge.RIGHT, True)
        Gtk4LayerShell.set_margin(
            self,
            Gtk4LayerShell.Edge.TOP,
            self.pos
        )

        # Mouse click & drag
        click = Gtk.GestureClick.new()
        click.connect('pressed', self.on_press)
        click.connect('released', self.on_release)
        self.add_controller(click)

        motion = Gtk.EventControllerMotion.new()
        motion.connect('motion', self.on_motion)
        self.add_controller(motion)

        # Style
        css = b"window { background-color: yellow; }"
        provider = Gtk.CssProvider()
        provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self.present()

    def on_press(self, gesture, n, x, y):
        self.dragging = True
        _, mouse_y = get_mouse_pos()
        self.offset = mouse_y - self.pos

    def on_motion(self, controller, x, y):
        if self.dragging:
            _, mouse_y = get_mouse_pos()
            new_pos = max(0, mouse_y - self.offset)
            Gtk4LayerShell.set_margin(
                self,
                Gtk4LayerShell.Edge.TOP,
                new_pos
            )

    def on_release(self, gesture, n, x, y):
        if self.dragging:
            _, mouse_y = get_mouse_pos()
            self.pos = max(0, mouse_y - self.offset)
            save_positions()
            self.dragging = False


class VerticalRuler(Gtk.Window):
    """Vertical line moving left/right (margin LEFT)."""

    def __init__(self, app, margin_left):
        super().__init__(application=app)
        self.pos = margin_left  # x
        self.dragging = False
        self.offset = 0

        # 3 px wide, full height
        self.set_default_size(3, -1)

        Gtk4LayerShell.init_for_window(self)
        Gtk4LayerShell.set_layer(self, Gtk4LayerShell.Layer.OVERLAY)
        Gtk4LayerShell.set_exclusive_zone(self, 0)

        Gtk4LayerShell.set_anchor(self, Gtk4LayerShell.Edge.LEFT, True)
        Gtk4LayerShell.set_anchor(self, Gtk4LayerShell.Edge.TOP, True)
        Gtk4LayerShell.set_anchor(self, Gtk4LayerShell.Edge.BOTTOM, True)
        Gtk4LayerShell.set_margin(
            self,
            Gtk4LayerShell.Edge.LEFT,
            self.pos
        )

        # Mouse click & drag
        click = Gtk.GestureClick.new()
        click.connect('pressed', self.on_press)
        click.connect('released', self.on_release)
        self.add_controller(click)

        motion = Gtk.EventControllerMotion.new()
        motion.connect('motion', self.on_motion)
        self.add_controller(motion)

        # Style
        css = b"window { background-color: yellow; }"
        provider = Gtk.CssProvider()
        provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self.present()

    def on_press(self, gesture, n, x, y):
        self.dragging = True
        mouse_x, _ = get_mouse_pos()
        self.offset = mouse_x - self.pos

    def on_motion(self, controller, x, y):
        if self.dragging:
            mouse_x, _ = get_mouse_pos()
            new_pos = max(0, mouse_x - self.offset)
            Gtk4LayerShell.set_margin(
                self,
                Gtk4LayerShell.Edge.LEFT,
                new_pos
            )

    def on_release(self, gesture, n, x, y):
        if self.dragging:
            mouse_x, _ = get_mouse_pos()
            self.pos = max(0, mouse_x - self.offset)
            save_positions()
            self.dragging = False


def add_horizontal_ruler():
    global h_rulers, app_ref
    if app_ref is None:
        return
    _, mouse_y = get_mouse_pos()
    r = HorizontalRuler(app_ref, max(0, mouse_y))
    h_rulers.append(r)
    save_positions()


def remove_horizontal_ruler():
    global h_rulers
    if not h_rulers:
        return
    r = h_rulers.pop()
    r.destroy()
    save_positions()


def add_vertical_ruler():
    global v_rulers, app_ref
    if app_ref is None:
        return
    mouse_x, _ = get_mouse_pos()
    r = VerticalRuler(app_ref, max(0, mouse_x))
    v_rulers.append(r)
    save_positions()


def remove_vertical_ruler():
    global v_rulers
    if not v_rulers:
        return
    r = v_rulers.pop()
    r.destroy()
    save_positions()


def on_activate(app):
    global h_rulers, v_rulers, app_ref
    app_ref = app

    h_pos, v_pos = load_positions()
    if not h_pos and not v_pos:
        h_pos = [200]

    h_rulers = []
    v_rulers = []

    for y in h_pos:
        h_rulers.append(HorizontalRuler(app, y))

    for x in v_pos:
        v_rulers.append(VerticalRuler(app, x))


def process_pending_command():
    """Read CMD_FILE and execute the requested command."""
    try:
        with open(CMD_FILE, 'r') as f:
            cmd = f.read().strip()
    except Exception:
        return False  # nothing to do

    if cmd in ("add", "add-h"):
        add_horizontal_ruler()
    elif cmd in ("remove", "remove-h"):
        remove_horizontal_ruler()
    elif cmd == "add-v":
        add_vertical_ruler()
    elif cmd == "remove-v":
        remove_vertical_ruler()

    # Optionally clear the command file
    try:
        os.remove(CMD_FILE)
    except Exception:
        pass

    return False  # GLib.idle_add: False => don't reschedule


def setup_signal_handler():
    """
    Single handler for SIGUSR1 – it just wakes up the main loop
    to process the command file.
    """

    def handler(signum, frame):
        GLib.idle_add(process_pending_command)

    signal.signal(signal.SIGUSR1, handler)


def is_process_running(pid: int) -> bool:
    """Check if a process with given PID is running."""
    try:
        os.kill(pid, 0)
        return True
    except OSError:
        return False


def send_command_to_existing(cmd: str) -> bool:
    """
    If there's an existing main instance (PID file), send it a command
    by writing CMD_FILE and poking it with SIGUSR1.
    Returns True if signal was sent and we should exit.
    """
    try:
        with open(PID_FILE, 'r') as f:
            pid = int(f.read().strip())
        if is_process_running(pid):
            os.makedirs(CONFIG_DIR, exist_ok=True)
            with open(CMD_FILE, 'w') as cf:
                cf.write(cmd)
            os.kill(pid, signal.SIGUSR1)
            return True
    except Exception:
        pass
    return False


def write_own_pid():
    os.makedirs(CONFIG_DIR, exist_ok=True)
    with open(PID_FILE, 'w') as f:
        f.write(str(os.getpid()))


def main():
    # Decide operation based on CLI arg
    # Defaults to horizontal add for backwards compatibility
    op = "add-h"
    if len(sys.argv) > 1:
        arg = sys.argv[1]
        if arg in ("add", "add-h", "remove", "remove-h", "add-v", "remove-v"):
            op = arg
        else:
            op = "add-h"

    # If another instance exists, just send it the command and exit.
    if send_command_to_existing(op):
        return

    # We're the main instance now
    write_own_pid()
    setup_signal_handler()

    app = Gtk.Application(application_id='com.ruler.app')
    app.connect('activate', on_activate)
    app.run(None)


if __name__ == "__main__":
    main()
