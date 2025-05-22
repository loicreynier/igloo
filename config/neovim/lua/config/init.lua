vim.g.mapleader = require("config.keymaps").leader -- Should be set before loading Lazy
require("config.lazy")
require("config.keymaps")
