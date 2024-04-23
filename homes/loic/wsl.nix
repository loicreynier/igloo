{
  imports = [
    ../vscode-server.nix
  ];

  igloo.wsl = {
    enable = true;
    windowsClipboard.commands = {
      copy = "win32yank.exe -i";
      paste = "win32yank.exe -o --lf";
    };
  };
}
