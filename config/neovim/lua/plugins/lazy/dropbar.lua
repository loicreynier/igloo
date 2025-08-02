return {
  "Bekaboo/dropbar.nvim",
  lazy = false,
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  opts = function()
    local menu_utils = require("dropbar.utils.menu")

    return {
      menu = {
        preview = false,
        keymaps = {
          ["<C-p>"] = "k",
          -- Back to parent menu
          ["h"] = "<C-w>q",
          -- Expands the menu if possible
          ["l"] = function()
            local menu = menu_utils.get_current()
            if not menu then return end
            local row = vim.api.nvim_win_get_cursor(menu.win)[1]
            local comp = menu.entries[row]:first_clickable()
            if comp then menu:click_on(comp, nil, 1, "l") end
          end,
        },
      },
    }
  end,
  config = function(_, opts)
    local dropbar_api = require("dropbar.api")
    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

    require("dropbar").setup(opts)
  end,
}
