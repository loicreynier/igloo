local function is_visible(cmp) return cmp.core.view:visible() or vim.fn.pumvisible() == 1 end

return {
  "hrsh7th/nvim-cmp",
  version = false, -- Last version is old
  dependencies = {
    { "hrsh7th/cmp-buffer", lazy = true },
    { "hrsh7th/cmp-path", lazy = true },
    { "hrsh7th/cmp-nvim-lsp", lazy = true },
  },
  event = "InsertEnter",
  opts = function()
    vim.api.nvim_set_hl(0, "CmpGhostTExt", { link = "Comment", default = true })
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    local auto_select = true
    return {
      auto_brackets = {}, -- Configure any filetype to auto add brackets
      completion = {
        completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping(function()
          if is_visible(cmp) then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end),
        ["<C-p>"] = cmp.mapping(function()
          if is_visible(cmp) then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end),
        ["<C-j>"] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Insert,
        }),
        ["<C-k>"] = cmp.mapping.select_prev_item({
          behavior = cmp.SelectBehavior.Insert,
        }),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<M-u>"] = cmp.mapping.scroll_docs(-4),
        ["<M-d>"] = cmp.mapping.scroll_docs(4),
        -- TODO: add completion/snippet synergy, see:
        -- https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/plugins/cmp_luasnip.lua
      }),
      sources = cmp.config.sources({
        { name = "lazydev" },
        { name = "nvim_lsp" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
      sorting = defaults.sorting,
      formatting = {
        -- Add "kind" info with icon on right of completion menu,
        -- i.e. completing `vim.fn.len` will show:
        --
        --    len(expr)   󰊕 Function
        --
        format = function(_, item)
          local icons = require("rice").icons.kinds
          if icons[item.kind] then item.kind = icons[item.kind] .. item.kind end

          local widths = {
            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
          }

          -- Check if "kind" info fits in `widths`, abbreviate if not
          for key, width in pairs(widths) do
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
              item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
            end
          end

          return item
        end,
      },
    }
  end,
}
