{
  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;

      # direnv.disabled = false;

      nix_shell = {
        # Remove state and force symbol for better render
        format = ''via [❄️ (\($name\))]($style) '';
      };

      shell.disabled = false;
    };
  };
}
