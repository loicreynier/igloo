return {
  "goolord/alpha-nvim",
  event = "VimEnter", -- Load plugin after all configuration is set
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Source: https://github.com/PraveenGongada/dotfiles
    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }

    -- TODO: use a `get_icon` function for reproductibility, e.g.
    -- https://github.com/AstroNvim/astroui/blob/main/lua/astroui/init.lua
    dashboard.section.buttons.val = {
      -- dashboard.button("e", "   File explorer", ":Neotree <CR>"),
      dashboard.button("e", "   New file", "<Cmd>ene<CR>"),
      dashboard.button("f", "   Find file", "<Cmd>Telescope find_files previewer=false<CR>"),
      dashboard.button("w", "󰱼   Find word", "<Cmd>Telescope live_grep<CR>"),
      dashboard.button("r", "   Recent", "<Cmd>Telescope oldfiles<CR>"),
      dashboard.button("c", "   Config", "<Cmd>e $MYVIMRC <CR>"),
      dashboard.button("l", "󰒲   Lazy", "<Cmd>Lazy<CR>"),
      dashboard.button("m", "󱌣   Mason", "<Cmd>Mason<CR>"),
      dashboard.button("q", "   Quit Neovim", "<Cmd>qa<CR>"),
    }

    local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
    vim.api.nvim_set_hl(0, "DashboardButtonKey", { fg = normal_hl.fg, bg = normal_hl.bg, bold = true })
    vim.api.nvim_set_hl(0, "DashboardButtonText", { link = "Normal" })

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl_shortcut = "DashboardButtonKey"
      button.opts.hl = "DashboardButtonText"
    end

    alpha.setup(dashboard.config)

    -- Set highlight colors for startup times
    vim.api.nvim_set_hl(0, "DashboardFooterSTimeNormal", { link = "Normal" })
    vim.api.nvim_set_hl(0, "DashboardFooterSTimeSlow", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "DashboardFooterSTimeVerySlow", { link = "DiagnosticError" })

    -- Get Lazy stats (startup time, number of plugins)
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      desc = "Add Alpha dashboard footer",
      callback = function()
        local plugins = require("lazy").stats()
        local time = (math.floor(plugins.startuptime * 100) / 100)
        local footer_hl = "DashboardFooterSTimeSlow" -- Default white

        if time > 60 then
          footer_hl = "DashboardFooterSTimeVerySlow" -- Red if > 60ms
        elseif time > 50 then
          footer_hl = "DashboardFooterSTimeSlow" -- Orange if > 50ms
        end

        dashboard.section.footer.opts.hl = footer_hl

        dashboard.section.footer.val = {
          " ",
          " ",
          " ",
          "󱐌 " .. plugins.count .. " plugins loaded in " .. time .. " ms",
        }
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
