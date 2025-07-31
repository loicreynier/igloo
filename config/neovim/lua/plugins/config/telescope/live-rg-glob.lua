--[[-- Telescope live grep with glob filter

  Usage  : <pattern> <space><space>glob
  Example: ripgrep␣␣*.lua

  Inspired from TJ's setup:
  - https://github.com/tjdevries/config.nvim/blob/master/lua/custom/telescope/multi-ripgrep.lua
  - https://www.youtube.com/watch?v=xdXE1tOT-qg

--]]

local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")

return function(opts)
  opts = opts or {}
  ---@diagnostic disable-next-line: undefined-field
  opts.cwd = opts.cwd or vim.uv.cwd()
  opts.shortcuts = opts.shortcuts
    or {
      ["l"] = "*.lua",
      ["v"] = "*.vim",
      ["n"] = "*.{vim,lua}",
      ["c"] = "*.c",
    }

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then return nil end

      local prompt_splits = vim.split(prompt, "  ")
      local args = { "rg" }

      if prompt_splits[1] then
        table.insert(args, "-e")
        table.insert(args, prompt_splits[1])
      end

      if prompt_splits[2] then
        table.insert(args, "-g") -- "glob" files

        local pattern
        if opts.shortcuts[prompt_splits[2]] then
          pattern = opts.shortcuts[prompt_splits[2]]
        else
          pattern = prompt_splits[2]
        end

        table.insert(args, string.format("%s", pattern))
      end

      return vim
        .iter({
          args,
          {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
        })
        :flatten()
        :totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  pickers
    .new(opts, {
      prompt_title = "Live ripgrep",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = sorters.empty(),
    })
    :find()
end
