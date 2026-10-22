-- Personal keyboard / touchpad (from input.conf).
-- The installer writes KAFY_KB_LAYOUT/KAFY_KB_VARIANT to /etc/environment so the
-- live session and the installed system share one layout without editing Lua.
local kb_layout = os.getenv("KAFY_KB_LAYOUT") or "us"
local kb_variant = os.getenv("KAFY_KB_VARIANT") or ""

hl.config({
  input = {
    kb_layout = kb_layout,
    kb_variant = kb_variant,
    kb_options = "compose:ralt", -- overrides vendor's compose:caps
    repeat_rate = 40,
    repeat_delay = 600,
    numlock_by_default = true,
    touchpad = {
      natural_scroll = true,
      scroll_factor = 1,
    },
  },
})

-- Scroll nicely in the terminal. (This windowrule lives in input.conf, not
-- windowrules.conf, so it is kept here.)
hl.window_rule({ match = { class = "(Alacritty|kitty)" }, scroll_touchpad = 1.5 })
