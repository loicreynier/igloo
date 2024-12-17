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
      nil
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
