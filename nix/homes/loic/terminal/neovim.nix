{
  config,
  pkgs,
  self,
  ...
}: {
  xdg.configFile."nvim" = {
    source = "${self}/config/neovim";
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraWrapperArgs = [
      # See `config/neovim/init.lua`
      "--prefix"
      "NVIM_NIX_WRAPPER"
      ":"
      "1"
      "--prefix"
      "NVIM_NIX_PLUGINS_PATH"
      ":"
      "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start"
    ];
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      # -- Vim stuff
      better-escape-nvim
      bufdelete-nvim
      smartcolumn-nvim
      yanky-nvim
      # -- UI
      alpha-nvim
      bufferline-nvim
      pkgs.vimExtraPlugins.incline-nvim
      lualine-nvim
      neo-tree-nvim
      noice-nvim
      nvim-notify
      telescope-nvim
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
      comment-nvim
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
      vim-bbcode-syntax
      # -- Memes
      duck-nvim
      # -- Dependencies
      plenary-nvim
      nvim-web-devicons
      dressing-nvim
    ];
    extraPackages = with pkgs; [
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
      # -- Lua
      lua-language-server
      selene
      stylua
      # -- Nix
      alejandra
      deadnix
      manix
      statix
      # -- Fortran
      fortls
      fprettify
      # -- Misc
      actionlint
      ansible-lint
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
    extraPython3Packages = ps:
      with ps; [
        python-lsp-server
        python-lsp-ruff
      ];
  };
}
