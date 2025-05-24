vim.g.mapleader = require("config.keymaps").leader -- Should be set before loading Lazy
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.filetypes")
require("config.autocmds")
