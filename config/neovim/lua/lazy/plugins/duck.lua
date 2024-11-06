--[[-- `duck.nvim`

  Do you have ducks Emacs? Uh?

--]]

return {
  "tamton-aquib/duck.nvim",
  keys = {
    {
      "<Leader>uD",
      function() require("duck").hatch() end,
      desc = "Spawn a little duck, coin coin",
    },
    {
      "<Leader>uD",
      function() require("duck").cook_all() end,
      desc = "Kill all the ducks, not coin coin",
    },
  },
}
