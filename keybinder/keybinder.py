from keybind import KeyBinder
import signal
import subprocess

def do(project):
    def fn():
        subprocess.Popen('code ' + project, shell=True)

    return fn

KeyBinder.activate({
    'Ctrl-Alt-Super-C': do("~/dev/casino"),
    'Ctrl-Alt-Super-F': do("~/dev/casino/frontend"),
    'Ctrl-Alt-Super-H': do("~/dev/detailed-game-history/frontend"),
    'Ctrl-Alt-Super-S': do("~/dev/softest"),
    'Ctrl-Alt-Super-G': do("~/dev/games-provider"),
    'Ctrl-Alt-Super-D': do("~/dev/docker"),
    'Ctrl-Alt-Super-B': do("~/dev/build"),
    'Ctrl-Alt-Super-R': do("~/dev/reader-www/frontend"),
    'Ctrl-Alt-Super-T': do("~/dev/games-tester"),
    'Ctrl-Alt-Super-N': do("~/Dropbox/notes.md"),
    'Ctrl-Alt-Super-O': do("~/dev/online-games-statistics-server-2"),
    'Ctrl-Alt-Super-K': do("~/dev/casino-kiosk-2/"),
}, run_thread=True)

signal.pause()