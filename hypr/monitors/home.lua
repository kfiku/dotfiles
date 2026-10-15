-- HOME

hl.monitor({
  output = "DP-1",
  mode = "3440x1440@60",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "eDP-1",
  mode = "1920x1200@60",
  position = "3440x600",
  scale = 1.25,
})

hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
