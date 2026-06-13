local M = {}

---@class PickerOption
---@field fn string | fun():nil The function or command to execute when the picker is called
---@field desc string Description of the picker for keymap documentation

---@class Picker
---@field [string] PickerOption

---@type table<string, Picker>
M.pickers = {
  --- Main pickers
  grep = {
    fff = {
      fn = function() require("fff").live_grep() end,
      desc = "Live grep (FFF)",
    },
  },
  command_history = {
    snacks = {
      fn = function() Snacks.picker.command_history() end,
      desc = "Search command line history (Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope command_history<CR>",
      desc = "Search command line history (Telescope)",
    },
  },

  -- LSP
  lsp_definitions = {
    snacks = {
      fn = function() Snacks.picker.lsp_definitions() end,
      desc = "Go to symbol definition (LSP|Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope lsp_definitions<CR>",
      desc = "Go to symbol definition (LSP|Telescope)",
    },
  },
  lsp_references = {
    snacks = {
      fn = function() Snacks.picker.lsp_references() end,
      desc = "Go to symbol definition (LSP|Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope lsp_references<CR>",
      desc = "Go to symbol definition (LSP|Telescope)",
    },
  },

  -- Find
  buffers = {
    snacks = {
      fn = function() Snacks.picker.buffers() end,
      desc = "Find buffers (Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope buffers<CR>",
      desc = "Find buffers (Telescope)",
    },
  },
  files = {
    snacks = {
      fn = function() Snacks.picker.smart() end,
      desc = "Find files (Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope find_files<CR>",
      desc = "Find files (Telescope)",
    },
    fff = {
      fn = function() require("fff").find_files() end,
      desc = "Find files (FFF)",
    },
  },
  git_files = {
    snacks = {
      fn = function() Snacks.picker.git_files() end,
      desc = "Fint Git files (Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope git_files<CR>",
      desc = "Find Git files (Telescope)",
    },
    fff = {
      fn = function() require("fff").find_in_git_root() end,
      desc = "Find Git files (FFF)",
    },
  },
  oldfiles = {
    snacks = {
      fn = function() Snacks.picker.recent() end,
      desc = "Find recent files (Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope oldfiles<CR>",
      desc = "Find recent files (Telescope)",
    },
  },
  config_files = {
    snacks = {
      fn = function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
      desc = "Find config files (Snacks)",
    },
    fff = {
      fn = function() require("fff").find_files_in_dir(vim.fn.stdpath("config")) end,
      desc = "Find config files (FFF)",
    },
  },
  todo_comments = {
    snacks = {
      ---@diagnostic disable-next-line: undefined-field
      fn = function() Snacks.picker.todo_comments() end,
      desc = "Find TODO comments (TodoComments|Snacks)",
    },
    telescope = {
      fn = "<Cmd>TodoTelescope<CR>",
      desc = "Find TODO comments (TodoComments|Snacks)",
    },
  },

  --- Search
  search_history = {
    snacks = {
      fn = function() Snacks.picker.search_history() end,
      desc = "Search search history (Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope search_history<CR>",
      desc = "Search search history (Telescope)",
    },
  },
  grep_buffers = {
    snacks = {
      fn = function() Snacks.picker.grep_buffers() end,
      desc = "Grep buffers (Snacks)",
    },
  },
  commands = {
    snacks = {
      fn = function() Snacks.picker.commands() end,
      desc = "Search user commands (Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope commands<CR>",
      desc = "Search user commands (Telescope)",
    },
  },
  keymaps = {
    snacks = {
      fn = function() Snacks.picker.keymaps() end,
      desc = "Search keymaps (Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope keymaps<CR>",
      desc = "Search keymaps (Telescope)",
    },
  },
  lazy = {
    snacks = {
      fn = function() Snacks.picker.lazy() end,
      desc = "Search Lazy plugins spec (Snacks)",
    },
    telescope = {
      fn = "<Cmd>Telescope lazy_plugins<CR>",
      desc = "Search Lazy plugins spec (Telescope)",
    },
  },
}

---@param picker string
---@param key string
---@param choice string
local function set_picker_keymap(picker, key, choice, opts)
  opts = opts or {}
  local selected = M.pickers[picker] and M.pickers[picker][choice]
  if not selected then
    vim.notify(string.format("Picker not found: %s.%s", picker, choice), vim.log.levels.ERROR)
    return
  end

  opts = vim.tbl_extend("force", opts, { desc = selected.desc })

  vim.keymap.set("n", key, selected.fn, opts)
end

function M.set_pickers_keymaps()
  require("user.utils.lazy").schedule_very_lazy(function()
    -- Snacks command/search history as a similar look as Noice command line
    local is_noice_cmdline = package.loaded["noice"] and true
    -- NOTE: we could check for Noice command module but would require `CmdLineEnter` to be triggered
    -- require("noice").api.status.command.has()

    -- Main pickers
    set_picker_keymap("grep", "<Leader>/", "fff")
    set_picker_keymap("command_history", "<Leader>:", is_noice_cmdline and "snacks" or "telescope")

    --- Find
    set_picker_keymap("buffers", "<Leader><Space>", "telescope")
    set_picker_keymap("files", "<Leader>ff", "fff")
    set_picker_keymap("git_files", "<Leader>fg", "fff")
    set_picker_keymap("oldfiles", "<Leader>fr", "telescope")
    set_picker_keymap("config_files", "<Leader>fc", "fff")
    set_picker_keymap("todo_comments", "<Leader>ft", "telescope")

    --- Search
    set_picker_keymap("search_history", "<Leader>s/", is_noice_cmdline and "snacks" or "telescope")
    set_picker_keymap("grep_buffers", "<Leader>sg", "snacks")
    set_picker_keymap("commands", "<Leader>sC", "snacks")
    set_picker_keymap("keymaps", "<Leader>sk", "snacks")
    set_picker_keymap("lazy", "<Leader>sL", "telescope")
  end)
end

function M.set_pickers_lsp_keymaps()
  set_picker_keymap("lsp_definitions", "gd", "telescope")
  set_picker_keymap("lsp_references", "gr", "telescope")
end

return M
