return {
    {
        "Mofiqul/vscode.nvim",
        lazy = false, -- Load during startup since colorscheme
        priority = 1000, -- Make sure it is loaded first
        opts = {
            transparent = false,
        },
        config = function()
            vim.cmd.colorscheme "vscode"
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {},
    },

    {
        "goolord/alpha-nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local startify = require("alpha.themes.startify")
            startify.file_icons.provider = "devicons"
            require("alpha").setup(
              startify.config
            )
        end,
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            -- ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        opts = {
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
}
