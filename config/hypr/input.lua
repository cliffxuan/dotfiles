-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    -- Australian / US Macintosh ISO layout for MacBook Pro
    -- Shift+3 produces '#', Option+3 produces '£', Shift+2 produces '@'
    kb_layout = "us",
    kb_variant = "mac-iso",
    kb_model = "apple",
    -- Remap Caps Lock to Escape
    kb_options = "caps:escape",

    touchpad = {
      -- Use natural (inverse) scrolling.
      natural_scroll = true,

      -- Use two-finger clicks for right-click instead of lower-right corner.
      clickfinger_behavior = true,

      -- Control the speed of your scrolling.
      scroll_factor = 0.4,

      -- Enable the touchpad while typing.
      disable_while_typing = false,

      -- Left-click-and-drag with three fingers.
      drag_3fg = 1,
    },
  },
})
