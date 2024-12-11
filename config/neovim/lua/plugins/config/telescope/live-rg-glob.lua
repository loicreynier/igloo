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
  -- TODO: stole shortcut option from TJ's

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then return nil end

      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }

      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g") -- "glob" files
        table.insert(args, pieces[2])
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
