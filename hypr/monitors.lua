local directory = os.getenv("HOME") .. "/Dropbox/dotfiles/hypr/monitors/"
local currentProfile

local function updateMonitors()
  local count = #hl.get_monitors()

  -- Przy starcie monitory mogą nie być jeszcze gotowe.
  if count == 0 then
    return
  end

  local profile
  if count >= 3 then
    profile = "office"
  elseif count == 2 then
    profile = "home"
  else
    profile = "laptop"
  end

  -- Zastosowanie konfiguracji też zmienia układ monitorów.
  -- Ten warunek zapobiega ponownemu ładowaniu tego samego profilu.
  if profile == currentProfile then
    return
  end

  currentProfile = profile
  dofile(directory .. profile .. ".lua")

  hl.notification.create({
    text = 'Monitor profile changed to "' .. profile .. '"',
    timeout = 3000,
    icon = "ok",
  })
end

hl.on("monitor.layout_changed", updateMonitors)
hl.on("config.reloaded", updateMonitors)
hl.on("hyprland.start", updateMonitors)

updateMonitors()