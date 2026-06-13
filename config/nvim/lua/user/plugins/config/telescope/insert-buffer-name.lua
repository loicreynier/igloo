local M = {}

local function telescope_insert_buffername(opts)
  opts = opts or {}
  local original_pos = vim.api.nvim_win_get_cursor(0)

  require("telescope.builtin").buffers({
    promp_title = "Select buffer to insert name",
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        local actions_state = require("telescope.actions.state")
        local selected = actions_state.get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)

        if selected and selected.filename then
          local buffer_name = selected.filename
          local insert_value = buffer_name

          if opts.full_path then
            insert_value = vim.fn.fnamemodify(buffer_name, ":p")
            -- TODO: implement relative path, may require use of external tools such as `realpath`
            -- elseif opts.relative_path then
            --   insert_value = vim.fn.fnamemodify(buffer_name, ":.")
          else
            -- Basename only
            insert_value = vim.fn.fnamemodify(buffer_name, ":t")
          end

          vim.api.nvim_win_set_cursor(0, original_pos)
          vim.api.nvim_put({ insert_value }, "c", true, true)
        end
      end)
      return true
    end,
  })
end

function M.insert_buffername(opts)
  opts = opts or {}
  if not opts.bang then
    vim.ui.select({
      "Filename",
      "Relative path",
      "Full path",
    }, { prompt = "Insert buffer name format :" }, function(choice)
      if not choice then return end
      if choice == "Relative path" then
        opts.relative_path = true
      elseif choice == "Full path" then
        opts.full_path = true
      end
      telescope_insert_buffername(opts)
    end)
  else
    telescope_insert_buffername(opts)
  end
end

function M.setup(opts)
  opts = opts or {
    name = "InsertBufferName",
  }
  vim.api.nvim_create_user_command(opts.name, M.insert_buffername, {
    bang = true,
    desc = "Insert buffer name (via Telescope picker)",
  })
end

return M
