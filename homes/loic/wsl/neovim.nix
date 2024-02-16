{
  config,
  lib,
  ...
}: {
  # Set WSL clipboard integration, requires `win32yank.exe` in `$PATH`
  # Related: https://neovim.io/doc/user/provider.html#provider-clipboard
  programs.nixvim.globals.clipboard = lib.mkIf config.programs.nixvim.enable {
    name = "WSLClipboard";
    copy = {
      "+" = "win32yank.exe -i";
      "*" = "win32yank.exe -i";
    };
    paste = {
      "+" = "win32yank.exe -o";
      "*" = "win32yank.exe -o";
    };
    cache_enabled = 0;
  };
}
