{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    literalExpression
    ;
  cfg = config.igloo.wsl;
in
{
  options.igloo.wsl.windowsClipboard = {
    enable = mkEnableOption "Windows clipboard" // {
      default = true;
    };

    commands = {
      copy = mkOption {
        type = types.str;
        description = ''
          Command used to copy to the clipboard.
          Default uses the `clip.exe` binary from `C:/Windows/System32/clip.exe`.
        '';
        default = "clip.exe";
        example = literalExpression "win32yank.exe -i";
      };
      paste = mkOption {
        type = types.str;
        description = ''
          Command used to pate from the clipboard.
          Default uses `powershell.exe Get-Clipboard`.
        '';
        default = "powershell.exe Get-Clipboard";
        example = literalExpression "win32yank.exe -o --lf";
      };
    };
  };

  config = mkIf (cfg.enable && cfg.windowsClipboard.enable) {
    home.activation = {
      checkWindowBinaries =
        let
          # Check whether Windows clipboard binaries are in the expected path.
          # Since activation is not run in the user shell,
          # it is actually not possible to check if they are in `$PATH`.
          # Therefore it only checks if they are in the expected path and prints a warning.
          commands = {
            "clip.exe" = "/mnt/c/Windows/System32/clip.exe";

            # Note that programs installed with WinGet are only symlinked to
            # `%AppData%/Local/Microsoft/WinGet/Links`
            # if "Developer Mode" is enabled or if the command is run from an admin shell.
            # Source: https://github.com/microsoft/winget-cli/issues/3498
            "win32yank.exe" = "/mnt/c/Users/Loic/AppData/Local/Microsoft/WinGet/Links/win32yank.exe";
          };
          check = name: path: ''
            if  run --quiet command -v ${path}; then
              echo "Windows binary '${name}' found in '${path}', check if it's in 'PATH'."
            else
              errorEcho '${name}' not found in '${path}'
              exit 1
            fi
          '';
        in
        with builtins;
        lib.hm.dag.entryAfter [ "reloadSystemd" ] (
          concatStringsSep "\n" (attrValues (mapAttrs check commands))
        );
    };

    programs.password-store.package = pkgs.pass.withExtensions (_: [
      (pkgs.callPackage ./pass-extension-wclip { })
    ]);

    programs.nixvim.globals.clipboard =
      let
        # Related: https://neovim.io/doc/user/provider.html#provider-clipboard
        inherit (cfg.windowsClipboard) commands;
      in
      mkIf config.programs.nixvim.enable {
        name = "WSLClipboard";
        copy = {
          "+" = commands.copy;
          "*" = commands.copy;
        };
        paste = {
          "+" = commands.paste;
          "*" = commands.paste;
        };
        cache_enabled = 0;
      };
  };
}
