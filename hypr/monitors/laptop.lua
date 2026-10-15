hl.monitor({
  output = "eDP-1",
  mode = "1920x1200@60",
  position = "0x0",
  scale = 1.25,
})

hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })