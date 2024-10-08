--[[-- Meme plugins

Do you have memes Emacs?

--]]

return {
  {
    "tamton-aquib/duck.nvim",

    keys = {
      {
        "<Leader>dd",
        function()
          require("duck").hatch()
        end,
        desc = "Spawn a little duck, coin coin",
      },
      {
        "<Leader>dk",
        function()
          require("duck").cook_all()
        end,
        desc = "Kill all the ducks, not coin coin",
      },
    },
  },
}
