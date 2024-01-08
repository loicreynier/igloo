{pkgs, ...}: {
  imports = [
    ./nvim-tree
  ];

  programs.nixvim = {
    plugins = {
      # -- Language server
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          julials.enable = true;
          ltex.enable = true;
          lua-ls.enable = true;
          nil_ls = {
            enable = true;
            settings = {
              formatting.command = [
                "alejandra"
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
          typst-lsp.enable = true;
        };
      };
      lsp-format.enable = true;
      lsp-lines.enable = true;

      # -- Treesitter
      treesitter = {
        enable = true;
        indent = true;
      };

      # -- Completion
      nvim-cmp = {
        enable = true;

        mappingPresets = [
          "insert"
          # "cmdline" # TODO
        ];
        mapping = {
          "<Tab>" = {
            modes = ["i" "s"];
            action = "cmp.mapping.select_next_item()";
          };
          "<S-Tab>" = {
            modes = ["i" "s"];
            action = "cmp.mapping.select_prev_item()";
          };
          "<CR>" = "cmp.mapping.confirm({select = true})";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-e>" = "cmp.mapping.close()";
        };

        autoEnableSources = true;
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
        autoClose = true;
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
