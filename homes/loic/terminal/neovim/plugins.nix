{pkgs, ...}: {
  imports = [
    ./nvim-tree
  ];

  programs.nixvim = {
    plugins = {
      # -- Language server
      lsp = {
        enable = true;
        keymaps = {
          diagnostic = {
            "<Leader>lj" = {
              # Could be `[d` on a more programming oriented keyboard layout
              action = "goto_next";
              desc = "Go to next diagnostic";
            };
            "<Leader>lk" = {
              # Could be `]d` on a more programming oriented keyboard layout
              action = "goto_prev";
              desc = "Go to previous diagnostic";
            };
          };
          lspBuf = {
            "K" = "hover";
            "<Leader>la" = {
              action = "code_action";
              desc = "LSP code action";
            };
            "<Leader>ld" = "definition";
            "<Leader>lD" = "references";
            "<Leader>lt" = "type_definition";
            "<Leader>li" = "implementation";
          };
        };

        servers = {
          bashls.enable = true;
          gopls.enable = true;
          julials.enable = true;
          ltex.enable = true;
          lua-ls.enable = true;
          nil_ls = {
            enable = true;
            settings = {
              formatting.command = [
                "${pkgs.alejandra}/bin/alejandra"
                "--quiet"
                "--"
              ];
            };
          };
          pylsp.enable = true;
          ruff-lsp.enable = true;
          rust-analyzer = {
            enable = true;
            # TODO: install Rust by other means
            installRustc = true;
            installCargo = true;
          };
          taplo.enable = true;
          texlab.enable = true;
          typos-lsp.enable = true;
          typst-lsp.enable = true;
          yamlls.enable = true;
        };
      };
      lsp-format.enable = true;
      lsp-lines.enable = true;
      ltex-extra = {
        enable = true;
        settings = {
          path = ".vscode"; # Compatibility with VS Code extension
        };
      };

      # -- Treesitter
      treesitter = {
        enable = true;
        indent = true;
      };

      # -- Completion
      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          mapping = {
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<CR>" = "cmp.mapping.confirm({select = true})";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-e>" = "cmp.mapping.close()";
          };

          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
            {name = "calc";}
            {name = "latex_symbols";}
            {name = "tree_sitter";}
            # TODO: add filetype-specific sources
          ];
        };
      };
      cmp-conventionalcommits.enable = true;
      cmp-git.enable = true;

      # -- UI
      bufferline.enable = true;
      gitsigns.enable = true;
      lualine = {
        enable = true;
        extensions = [
          "fzf"
          "man"
          "nvim-tree"
        ];
      };
      nvim-autopairs.enable = true;
      nvim-tree = {
        enable = true;
        autoClose = false; # I want to use `vi <folder>`
        openOnSetup = true;
        tab.sync.open = true;
      };
      notify.enable = true;

      # -- Git
      diffview.enable = true;

      # -- Markdown
      markdown-preview.enable = true;
      mkdnflow.enable = true;
    };

    extraPlugins = [
      pkgs.vimPlugins.ltex_extra-nvim
      pkgs.vimPlugins.duck-nvim
      pkgs.vimPlugins.editorconfig-nvim
      pkgs.vimExtraPlugins.vscode-nvim
    ];

    extraConfigLuaPost =
      # -- VS Code theme
      ''
        -- Colorscheme {{{
        require("vscode").setup({disable_nvimtree_bg = true})
        require("vscode").load("dark")
        -- }}}
      '';
  };
}
# vim: nofoldenable

