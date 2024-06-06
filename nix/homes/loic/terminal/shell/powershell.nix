{self, ...}: {
  programs.powershell = {
    enable = true;
    profile = "${self}/config/powershell/Microsoft.PowerShell_profile.ps1";
  };
}
