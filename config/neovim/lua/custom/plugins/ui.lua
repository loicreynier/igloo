--[[-- UI plugins

  "Welcome to the rice fields"

  Plugins:
  - `nvim-notify`
  - `lualine.nvim`
  - `noice.nvim`
  - `alpha.nvim`

  References:
  - https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua

--]]

return {
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<Leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all notifications (Notify)",
            },
        },
        config = function()
            vim.notify = require("notify")
        end,
        opts = {
            stages = "static",
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { zindex = 100 })
            end,
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- Set an empty statusline till it loads
                vim.o.statusline = " "
            else
                -- Hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            -- PERF: "we don't need this `lualine` require madness" - LazyVim
            local lualine_require = require("lualine_require")
            lualine_require.require = require

            local opts = {
                options = {
                    theme = "auto",
                    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter " } },
                },
                sections = {
                    lualine_y = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        -- Word count for text, Markdown and TeX
                        {
                            function()
                                if
                                    vim.fn.mode() == "v"
                                    or vim.fn.mode() == "V"
                                    or vim.fn.mode() == ""
                                then
                                    return vim.fn.wordcount().visual_words .. " words"
                                else
                                    return vim.fn.wordcount().words .. " words"
                                end
                            end,
                            cond = function()
                                return vim.tbl_contains(
                                    { "text", "markdown", "tex" },
                                    vim.bo.filetype
                                )
                            end,
                        },
                    },
                },
                extensions = { "neo-tree", "lazy" },
            }

            return opts
        end,
    },

    {
        "folke/noice.nvim",
        version = "<=4.4.7", -- https://github.com/folke/noice.nvim/issues/938
        event = "VeryLazy",
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            -- ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },

    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local startify = require("alpha.themes.startify")
            startify.file_icons.provider = "devicons"
            require("alpha").setup(startify.config)
        end,
    },
}
