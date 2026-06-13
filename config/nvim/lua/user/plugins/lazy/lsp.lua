---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
        "snacks.nvim",
      },
    },
  },

  -- Cursor word/reference highlighting via `textDocument.documentHighlight`
  {
    "akioweh/lsp-document-highlight.nvim",
    lazy = false,
    enabled = not vim.g.sinfo.is_slow,
    keys = {
      {
        "[[",
        function() require("lsp-document-highlight").jump(-vim.v.count1, true) end,
        desc = "Previous reference",
      },
      {
        "]]",
        function() require("lsp-document-highlight").jump(vim.v.count1, true) end,
        desc = "Next reference",
      },
    },
    ---@module "LDH
    ---@type LDH.config
    opts = {
      throttle = 50,
      navigation = {},
    },
  },

  -- Injected languages support
  -- NOTE(2026-04-24): Doesn't work with Snacks LSP pickers (`lsp_references` etc.)
  {
    "jmbuhr/otter.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },

  -- Codelens
  {
    "oribarilan/lensline.nvim",
    enabled = not vim.g.sinfo.is_slow,
    event = "LspAttach",
    opts = {
      profiles = {
        {
          name = "default",
          providers = {
            {
              name = "usages",
              breakdown = false,
              show_zero = true,
            },
            -- {
            --   name = "last_author",
            --   enabled = true,
            --   cache_max_files = 50,
            -- },
          },
          style = {
            separator = " • ",
            highlight = "Comment",
            prefix = "",
            placement = "inline", -- Use default prefix when using `"above"`
            use_nerdfont = true,
            render = "all", -- "all" | "focused"
          },
        },
      },
    },
  },
  {
    "lensline.nvim",
    opts = function()
      Snacks.toggle({
        name = "Lensline",
        get = function() return require("lensline").is_visible() end,
        set = function(state)
          if state then
            require("lensline").show()
          else
            require("lensline").hide()
          end
        end,
      }):map("<Leader>uL")
    end,
  },

  -- LTeX configuration
  {
    "barreiroleo/ltex_extra.nvim",
    branch = "dev",
    ft = { "markdown", "tex" },
    opts = function()
      local path
      local git_root = vim.fs.dirname(vim.fs.find(".git", { path = vim.loop.cwd(), upward = true })[1])

      if git_root then
        if #vim.fn.glob(git_root .. "/.vscode" .. "/ltex.*", true, true) == 0 then
          path = git_root .. "/.ltex"
        else
          path = git_root .. "/.vscode"
        end
      else
        path = vim.fn.stdpath("data") .. "/ltex"
      end

      ---@module "ltex_extra"
      ---@type LtexExtraOpts
      ---@diagnostic disable-next-line: missing-fields
      return {
        load_langs = { "en", "en-US", "fr" },
        path = path,
      }
    end,
  },
}
