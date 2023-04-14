from keybind import KeyBinder
import signal
import subprocess

def run(project):
    def fn():
        subprocess.Popen(project, shell=True)

    return fn

KeyBinder.activate({
    'Ctrl-Alt-Super-C': run("code ~/dev/casino"),
    'Ctrl-Alt-Super-F': run("code ~/dev/casino/frontend"),
    'Ctrl-Alt-Super-H': run("code ~/dev/detailed-game-history/frontend"),
    'Ctrl-Alt-Super-S': run("code ~/dev/softest"),
    'Ctrl-Alt-Super-G': run("code ~/dev/games-provider"),
    'Ctrl-Alt-Super-D': run("code ~/dev/docker"),
    'Ctrl-Alt-Super-B': run("code ~/dev/build"),
    'Ctrl-Alt-Super-R': run("code ~/dev/reader-www/frontend"),
    'Ctrl-Alt-Super-T': run("code ~/dev/games-tester"),
    'Ctrl-Alt-Super-N': run("code ~/Dropbox/notes.md"),
    'Ctrl-Alt-Super-O': run("code ~/dev/online-games-statistics-server-2"),
    'Ctrl-Alt-Super-K': run("code ~/dev/casino-kiosk-2/"),
    'Ctrl-Alt-Super-L': run("code ~/dev/online-lens/"),
    'Ctrl-Alt-Super-Q': run("wine ~/.wine/dosdevices/c\:/Program\ Files/HeidiSQL/heidisql.exe"),
    'Ctrl-Alt-Super-P': run("~/dev/Postman/Postman"),
}, run_thread=True)

signal.pause()