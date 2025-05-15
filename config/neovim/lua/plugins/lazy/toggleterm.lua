return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    {
      "<Leader>th",
      "<Cmd>ToggleTerm direction=horizontal<CR>",
      desc = "Toggle terminal in horizontal split (ToggleTerm)",
    },
    {
      "<Leader>tv",
      "<Cmd>ToggleTerm size=80 direction=vertical<CR>",
      desc = "Toggle terminal in vertical split (ToggleTerm)",
    },
    {
      "<Leader>tf",
      "<Cmd>ToggleTerm direction=float<CR>",
      desc = "Toggle floating terminal (ToggleTerm)",
    },
    {
      "<F7>",
      "<Cmd>ToggleTerm<CR>",
      desc = "Toggle terminal (ToggleTerm)",
    },
  },
  opts = {
    direction = "float",
    highlights = {
      Normal = { link = "Normal" },
      NormalNC = { link = "NormalNC" },
      NormalFloat = { link = "NormalFloat" },
      FloatBorder = { link = "TelescopePromptBorder" },
      StatusLine = { link = "StatusLine" },
      StatusLineNC = { link = "StatusLineNC" },
      WinBar = { link = "WinBar" },
      WinBarNC = { link = "WinBarNC" },
    },
    --@param term Terminal
    on_create = function(term)
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.signcolumn = "no"
      -- if term.hidden then
      --   local function toggle() term:toggle() end
      --   vim.keymap.set({ "t", "n", "i" }, "<F7>", toggle, { desc = "Toggle terminal", buffer = t.bufnr })
      -- end
    end,
    shading_factor = 2,
    float_opts = {
      border = "rounded",
    },
  },
}
