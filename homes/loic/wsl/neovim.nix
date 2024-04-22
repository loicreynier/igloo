{
  config,
  lib,
  ...
}: {
  # Set WSL clipboard integration
  # Related: https://neovim.io/doc/user/provider.html#provider-clipboard
  programs.nixvim.globals.clipboard = let
    # clipCmd = "${pkgs.win32yank-bin}/bin/win32yank.exe";
    # Use binary from Windows path for performance
    # Nix binary through WSL became (very) slow in 2024/04
    clipCmd = "win32yank.exe";
  in
    lib.mkIf config.programs.nixvim.enable {
      name = "WSLClipboard";
      copy = {
        "+" = "${clipCmd} -i";
        "*" = "${clipCmd} -i";
      };
      paste = {
        "+" = "${clipCmd} -o";
        "*" = "${clipCmd} -o";
      };
      cache_enabled = 0;
    };
}
