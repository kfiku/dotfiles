from keybind import KeyBinder
import signal
import subprocess

def run(project):
    def fn():
        subprocess.Popen(project, shell=True)

    return fn

KeyBinder.activate({
    'Ctrl-Alt-Super-C': run("code /app/dev/casino"),
    'Ctrl-Alt-Super-F': run("code /app/dev/casino/frontend"),
    'Ctrl-Alt-Super-H': run("code /app/dev/detailed-game-history/frontend"),
    'Ctrl-Alt-Super-S': run("code /app/dev/softest"),
    'Ctrl-Alt-Super-G': run("code /app/dev/games-provider"),
    'Ctrl-Alt-Super-D': run("code /app/dev/docker"),
    'Ctrl-Alt-Super-B': run("code /app/dev/build"),
    'Ctrl-Alt-Super-R': run("code /app/dev/reader-www/frontend"),
    'Ctrl-Alt-Super-T': run("code /app/dev/games-tester"),
    'Ctrl-Alt-Super-O': run("code /app/dev/online-games-statistics-server-2"),
    'Ctrl-Alt-Super-K': run("code /app/dev/casino-kiosk-2/"),
    'Ctrl-Alt-Super-L': run("code /app/dev/online-lens/"),
    'Ctrl-Alt-Super-A': run("code /app/dev/games-provider-admin/"),
    'Ctrl-Alt-Super-W': run("code /app/dev/wallet/"),
    'Ctrl-Alt-Super-Y': run("code /app/dev/lobby/lobby.code-workspace"),

    'Ctrl-Alt-Super-N': run("code ~/Dropbox/notes.md"),
    'Ctrl-Alt-Super-E': run("code ~/Dropbox/dotfiles"),

    'Ctrl-Alt-Super-Q': run("wine ~/.wine/dosdevices/c\:/Program\ Files/HeidiSQL/heidisql.exe"),
    'Ctrl-Alt-Super-P': run("/app/dev/Postman/Postman"),
    'Ctrl-Alt-Super-_': run("~/Dropbox/dotfiles/piner/run.sh"),

    'Ctrl-Alt-Super-V': run("code /app/dev/github/advent-of-code"),

    'Ctrl-Alt-Super-8': run("killall Bitrix24 || true; sleep 5; /opt/Bitrix24/Bitrix24 "),
    'Ctrl-Alt-Super-9': run('xinput enable "AT Translated Set 2 keyboard"'),
    'Ctrl-Alt-Super-0': run('xinput disable "AT Translated Set 2 keyboard"'),
    'Ctrl-Alt-Super-1': run('autorandr --load dom'),
    'Ctrl-Alt-Super-2': run('autorandr --load praca'),

}, run_thread=True)

signal.pause()