hl.unbind("F9")
hl.unbind("Print")
hl.unbind("ALT + Print")

-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

o.bind("Print", nil, "omarchy-capture-screenshot smart")

o.bind("SUPER + U", "Screenshot to clipboard", "/home/grzegorz/Dropbox/dotfiles/hypr/snapshot-region.sh")

o.bind("SUPER + SHIFT + U", "Screenshot to clipboard", "/home/grzegorz/Dropbox/dotfiles/hypr/snapshot-region.sh 1")

o.bind("SUPER + Q", "HeidiSQL", "heidisql")

o.bind("SUPER + SHIFT + Q", "HeidiSQL", [[kill $(ps aux | grep heidi | awk '{print $2}')]])

o.bind("SUPER + N", "Notes", "code /home/grzegorz/Dropbox/notes.md")

o.bind("SUPER + R", "GitlabHelper", "node /home/grzegorz/Dropbox/dotfiles/gitlab_eqxt/index.js")

o.bind("SUPER + L", "Guides", "/home/grzegorz/Dropbox/dotfiles/guides/index.sh")

o.bind("SUPER + SHIFT + equal", "Guides", "/home/grzegorz/Dropbox/dotfiles/guides/ruler.sh add-h")

o.bind("SUPER + SHIFT + minus", "Guides", "/home/grzegorz/Dropbox/dotfiles/guides/ruler.sh remove-h")

o.bind("SUPER + SHIFT + bracketright", "Guides", "/home/grzegorz/Dropbox/dotfiles/guides/ruler.sh add-v")

o.bind("SUPER + SHIFT + bracketleft", "Guides", "/home/grzegorz/Dropbox/dotfiles/guides/ruler.sh remove-v")

