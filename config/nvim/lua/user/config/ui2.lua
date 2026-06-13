require("vim._core.ui2").enable({
  enable = false,
  msg = {
    ---@type 'cmd'|'msg' Default message target, either in the cmdline or in a separate ephemeral message window
    targets = "cmd",
    cmd = {
      height = 0.5,
    },
  },
})
