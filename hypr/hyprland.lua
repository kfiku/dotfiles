-- Polska klawiatura
hl.config({
    input = {
        kb_layout = "pl",
        kb_options = "lv3:ralt_switch"
        -- follow_mouse = 0,
    }
})

-- Workspace
hl.workspace_rule({
    workspace = "1",
    monitor = "eDP-1"
})

-- Reguły okien
hl.window_rule({
    match = {
        class = ".*(keepassxc|bitrix24|Spotify|chrome-mail.google.com).*"
    },
    workspace = "1"
})

hl.window_rule({
    match = {
        class = ".*(code).*"
    },
    workspace = "2"
})

hl.window_rule({
    match = {
        class = ".*bitrix24.*"
    },
    group = "new"
})
