-- BIURO

hl.monitor({
  output = "DP-3",
  mode = "3840x2160@60",
  position = "0x0",
  scale = 1.5,
})

hl.monitor({
  output = "DP-1",
  mode = "3840x2160@60",
  position = "2560x0",
  scale = 1.5,
})

hl.monitor({
  output = "eDP-1",
  mode = "1920x1200@60",
  position = "5120x600",
  scale = 1.25,
})

-- 3840 / 1.5 * 2 = 5120

hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-2" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-2" })