{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  xdg.configFile."nvim" = {
    source = "${self}/config/neovim";
    recursive = true;
  };

  programs.neovim = let
    installPlugins = false;
    pluginsPath = "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start";
  in {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraWrapperArgs =
      [
        # See `config/neovim/init.lua`
        "--prefix"
        "NVIM_NIX_WRAPPED"
        ":"
        "1"
      ]
      ++ (
        if installPlugins
        then [
          "--prefix"
          "NVIM_NIX_PLUGINS_PATH"
          ":"
          pluginsPath
        ]
        else []
      );
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      # Plugins from `vimExtraPlugins` must be renamed to their GitHub name to be recognized by Lazy
      lazy-nvim
      # -- Vim stuff
      better-escape-nvim
      bufdelete-nvim
      persistence-nvim
      persisted-nvim
      guess-indent-nvim
      smartcolumn-nvim
      (pkgs.vimExtraPlugins.visual-whitespace-nvim.overrideAttrs (_: {pname = "visual-whitespace.nvim";}))
      yanky-nvim
      # -- UI
      alpha-nvim
      bufferline-nvim
      (pkgs.vimExtraPlugins.incline-nvim.overrideAttrs (_: {pname = "incline.nvim";}))
      lualine-nvim
      neo-tree-nvim
      (pkgs.vimExtraPlugins.noice-nvim.overrideAttrs (_: {pname = "noice.nvim";}))
      nvim-notify
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-manix
      telescope-undo-nvim
      toggleterm-nvim
      zen-mode-nvim
      twilight-nvim
      pkgs.vimExtraPlugins.beacon-nvim
      # -- Code/LSP
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-nvim-lsp
      nvim-lspconfig
      nvim-lint
      nvim-treesitter.withAllGrammars
      neoconf-nvim
      lsp_lines-nvim
      conform-nvim
      (comment-nvim.overrideAttrs (_: {pname = "Comment.nvim";}))
      nvim-ts-context-commentstring
      trouble-nvim
      todo-comments-nvim
      ltex_extra-nvim
      # -- Git
      gitsigns-nvim
      diffview-nvim
      # -- Markdown
      markdown-preview-nvim
      # -- Rice
      vscode-nvim
      tokyonight-nvim
      helpview-nvim
      # -- Highlights
      coconut-vim
      (vim-bbcode-syntax.overrideAttrs (_: {pname = "bbcode";}))
      vim-syntax-vidir-ls
      # -- Memes
      duck-nvim
      # -- Dependencies
      plenary-nvim
      nvim-web-devicons
      dressing-nvim
    ];
>>>>>>> 6f8b19f (feat(config.neovim): add Beacon plugin)
    extraPackages = with pkgs; let
      # WARNING: tricky hack for installing Python LSP Server plugins
      # See:
      # - https://github.com/nix-community/nixvim/blob/main/plugins/lsp/language-servers/pylsp.nix
      # - https://github.com/NixOS/nixpkgs/issues/229337
      # `pylsp` plugins are installed by adding them into `python-lsp-server`'s `propagatedBuildInputs`.
      # Since plugins have the server as the dependencies, the latter is removed from the plugins deps
      # to prevent circular dependencies issues.
      pylspPlugins = lib.lists.flatten (
        lib.mapAttrsToList
        (
          _pluginName: pluginPkg: (
            pluginPkg.overridePythonAttrs (old: {
              dependencies = lib.filter (dep: dep.pname != "python-lsp-server") old.dependencies;
              doCheck = false;
            })
          )
        )
        (
          with python3Packages; {
            # pylsp_mypy = pylsp-mypy.overridePythonAttrs (old: {
            #   postPatch =
            #     old.postPatch
            #     or ''''
            #     + ''
            #       substituteInPlace setup.cfg \
            #         --replace-fail "python-lsp-server >=1.7.0" ""
            #     '';
            # });
            ruff = python-lsp-ruff.overridePythonAttrs (old: {
              postPatch =
                old.postPatch
                or ''''
                + ''
                  sed -i '/python-lsp-server/d' pyproject.toml
                '';

              build-system = [setuptools] ++ (old.build-system or []);
            });
          }
        )
      );

      pylsp = python3Packages.python-lsp-server.overridePythonAttrs (old: {
        propagatedBuildInputs = pylspPlugins ++ old.dependencies;
        disabledTests =
          (old.disabledTests or [])
          ++ [
            # Those tests fail when third-party plugins are loaded
            "test_notebook_document__did_open"
            "test_notebook_document__did_change"
          ];
      });
    in [
      # -- Build stuff
      gcc
      gnumake
      # -- General linters and spelling
      editorconfig-checker
      ltex-ls
      typos-lsp
      # -- VSC
      git
      gitlint
      mercurial
      delta
      # -- Shell
      shfmt
      shellcheck
      # -- Python
      pylsp
      # -- Lua
      lua-language-server
      selene
      stylua
      # -- Nix
      alejandra
      deadnix
      manix
      nil
      statix
      # -- Fortran
      fortls
      fprettify
      # -- Misc
      actionlint
      bash
      clang-tools
      checkmake
      hadolint
      just
      markdownlint-cli
      taplo
      texlab
      tinymist
      yamllint
    ];
    plugins = with pkgs.vimPlugins;
      if ! installPlugins
      then []
      else [
        # Plugins from `vimExtraPlugins` must be renamed to their GitHub name to be recognized by Lazy
        lazy-nvim
        # -- Vim stuff
        better-escape-nvim
        bufdelete-nvim
        persistence-nvim
        persisted-nvim
        guess-indent-nvim
        smartcolumn-nvim
        (pkgs.vimExtraPlugins.visual-whitespace-nvim.overrideAttrs (_: {pname = "visual-whitespace.nvim";}))
        yanky-nvim
        # -- UI
        alpha-nvim
        bufferline-nvim
        (pkgs.vimExtraPlugins.incline-nvim.overrideAttrs (_: {pname = "incline.nvim";}))
        lualine-nvim
        neo-tree-nvim
        (pkgs.vimExtraPlugins.noice-nvim.overrideAttrs (_: {pname = "noice.nvim";}))
        nvim-notify
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-manix
        telescope-undo-nvim
        toggleterm-nvim
        zen-mode-nvim
        twilight-nvim
        # -- Code/LSP
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp-nvim-lsp
        nvim-lspconfig
        nvim-lint
        nvim-treesitter.withAllGrammars
        neoconf-nvim
        lsp_lines-nvim
        conform-nvim
        (comment-nvim.overrideAttrs (_: {pname = "Comment.nvim";}))
        nvim-ts-context-commentstring
        trouble-nvim
        todo-comments-nvim
        ltex_extra-nvim
        # -- Git
        gitsigns-nvim
        diffview-nvim
        # -- Markdown
        markdown-preview-nvim
        # -- Rice
        vscode-nvim
        tokyonight-nvim
        helpview-nvim
        # -- Highlights
        coconut-vim
        (vim-bbcode-syntax.overrideAttrs (_: {pname = "bbcode";}))
        vim-syntax-vidir-ls
        # -- Memes
        duck-nvim
        # -- Dependencies
        plenary-nvim
        nvim-web-devicons
        dressing-nvim
      ];
  };
}
