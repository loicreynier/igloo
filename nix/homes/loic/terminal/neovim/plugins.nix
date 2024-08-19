{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nvim-tree
  ];

  programs.nixvim = {
    colorschemes.vscode = {
      enable = true;
      settings = {
        transparent = true;
        disable_nvimtree_bg = true;
      };
    };

    plugins = {
      # -- Key mappings
      better-escape.enable = true;

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

        servers = let
          cfg = config.programs.nixvim.plugins.lsp.servers;
        in {
          bashls.enable = true;
          fortls = {
            enable = true;
            cmd = [
              "${cfg.fortls.package}/bin/fortls"
              "--disable_autoupdate"
              "--lowercase_intrinsics"
            ];
          };
          gopls.enable = true;
          julials.enable = true;
          lemminx.enable = true;
          ltex.enable = true;
          lua-ls.enable = true;
          marksman.enable = true;
          nil-ls = {
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

      # -- `non-ls`
      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources = {
          code_actions = {
            gitrebase.enable = true;
            gitsigns.enable = true;
            statix.enable = true;
          };
          diagnostics = {
            actionlint.enable = true;
            ansiblelint.enable = true;
            checkmake.enable = true;
            deadnix.enable = true;
            editorconfig_checker.enable = true;
            gitlint.enable = true;
            markdownlint.enable = true;
            # selene.enable = true; # Not needed with `lua-ls`
            statix.enable = true;
            yamllint.enable = true;
          };
          formatting = {
            clang_format.enable = true;
            fprettify = {
              enable = true;
              settings.extra_args = [
                "--indent=4"
                "line-length=100"
              ];
            };
            just.enable = true;
            prettier.enable = true;
            shfmt.enable = true;
            typstfmt.enable = true;
          };
        };
      };

      # -- LSP-related plugins
      ltex-extra = {
        enable = true;
        settings = {
          path = {__raw = "ltex_dir_path()";};
        };
      };
      trouble = {
        enable = true;
        settings = {
          auto_close = true;
        };
      };

      # -- Treesitter - Highlighting - Indentation
      treesitter = {
        enable = true;
        settings.indent.enable = true;
      };
      guess-indent.enable = true;

      # -- Completion
      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          mapping = {
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<C-y>" = "cmp.mapping.confirm({select = true})";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
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

      # -- Telescope
      telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = {
            action = "git_files";
            options = {
              desc = "Telescope Git files";
            };
          };
          "<Leader>pf" = {
            action = "find_files";
            options = {
              desc = "Telescope files";
            };
          };
          "<Leader>pb" = {
            action = "buffers";
            options = {
              desc = "Telescope buffers";
            };
          };
        };
      };

      # -- UI
      bufferline.enable = true;
      bufdelete.enable = true;
      gitsigns.enable = true;
      lualine = {
        enable = true;
        extensions = [
          "fzf"
          "man"
          "nvim-tree"
        ];
        sections.lualine_y = [
          "progress"
          {
            name = "word count";
            fmt = ''
              function()
                  local filetypes = { 'text', 'markdown', 'tex' }
                  if vim.tbl_contains(filetypes, vim.bo.filetype) then
                      if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "" then
                        return vim.fn.wordcount().visual_words .. " words"
                      else
                        return vim.fn.wordcount().words .. " words"
                      end
                  end
              end
            '';
          }
        ];
      };
      nvim-autopairs.enable = true;
      nvim-tree = {
        enable = true;
        autoClose = false; # I want to use `vi <folder>`
        openOnSetup = true;
        tab.sync.open = true;
        view.side = "right";
      };
      zen-mode.enable = true;
      twilight.enable = true;
      notify = {
        enable = true;
        backgroundColour = "#000000";
      };
      noice = {
        enable = true;
        lsp = {
          progress.enabled = false;
        };
      };

      # -- Git
      diffview.enable = true;

      # -- Markdown
      markdown-preview.enable = true;
      mkdnflow.enable = true;

      # -- Misc
      codesnap = {
        enable = true;
        settings = {
          save_path = "${config.xdg.userDirs.pictures}/CodeSnap";
          watermark = "";
          has_breadcrumbs = true;
          has_line_number = true;
          show_workspace = false;
          bg_theme = "default";
          mac_window_bar = false;
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      # -- Core
      editorconfig-nvim

      # -- Memes
      duck-nvim

      # -- Highlighting
      vim-bbcode-syntax
      vim-just
      coconut-vim
      typst-vim
    ];

    extraConfigLuaPre = lib.fileContents ./ltex-dir-path.lua;
  };
}
# vim: nofoldenable

