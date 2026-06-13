{
  perSystem =
    {
      pkgs,
      lib,
      inputs',
      ...
    }:
    let
      wrapperArgs = [
        "--prefix"
        "NVIM_NIX_SQLITE_PATH"
        ":"
        "${pkgs.sqlite.out}/lib/libsqlite3${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}"
      ];
      extraPackages = with pkgs; [
        # -- Unix utilities
        lsof
        ps
        curl
        wget
        # -- Grep and find tools
        fd
        ripgrep
        # -- Parsers
        jq
        yq-go
        # -- Build stuff
        gcc
        gnumake
        cmake
        just
        tree-sitter
        # -- Git & friends
        git
        delta
        # -- LSPs, linters & formatters
        # Lua
        lua-language-server
        selene
        stylua
        # Nix
        deadnix
        nil
        nixfmt
        statix
        # Shell
        shfmt
        shellcheck
        # Python
        ruff
        ty
        # Fortran
        fortitude
        fortls
        fprettify
        # C/C++
        clang-tools
        # LaTeX
        texlab
        tex-fmt
        # Spelling
        ltex-ls
        typos-lsp
        # Misc
        checkmake
        neocmakelsp
        taplo
        yamllint
        vscode-langservers-extracted # Provides `jsonls`
      ];
      wrapperArgsPkgs = lib.optionals (extraPackages != [ ]) [
        "--suffix"
        "PATH"
        ":"
        (lib.makeBinPath extraPackages)
      ];

      excluededRuntimeFiles = [
        "example_init.lua"
        "plugin/rplugin.vim.orig"
        "plugin/tutor.vim"
      ];
      postInstallCommands = map (target: "rm -f $out/share/nvim/runtime/${target}") excluededRuntimeFiles;

      # References:
      # - https://github.com/nix-community/home-manager/blob/master/modules/programs/neovim.nix
      # - https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/neovim/wrapper.nix
      neovimWrapper =
        pkg:
        (pkgs.wrapNeovimUnstable pkg {
          wrapRc = false;
          wrapperArgs = wrapperArgs ++ wrapperArgsPkgs;
          autowrapRuntime = true;
        }).overrideAttrs
          (prev: {
            packpathDirs.myNeovimPackages = {
              start = [ ];
              opt = [ ];
            };

            postInstall = ''
              ${prev.postInstall or ""}
              ${builtins.concatStringsSep "\n" postInstallCommands}
            '';
          });

      neovimWrapped = neovimWrapper pkgs.neovim-unwrapped;
      neovimWrappedNightly = pkgs.writeShellScriptBin "nvim-nightly" ''
        exec ${neovimWrapper inputs'.neovim-nightly-overlay.packages.default}/bin/nvim "$@"
      '';
    in
    {
      packages = {
        inherit
          neovimWrapped
          neovimWrappedNightly
          ;
      };
    };
}
