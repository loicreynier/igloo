{
  pkgs,
  ...
}:
{
  system.stateVersion = "24.11";
  networking.hostName = "smaug-wsl";
  services.openssh.ports = [ 2201 ];

  wsl.defaultUser = "loic";

  igloo = {
    device = {
      type = "wsl";
      gpu.type = "nvidia";
    };

    system = {
      virtualization = {
        podman.enable = true;
        distrobox.enable = true;
      };
    };
  };

  systemd.services.mount-loot = {
    description = "Mount Loot via `gsudo wsl`";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.writeShellScript "mount-loot" ''
          #!${pkgs.stdenv.shell}

          if findmnt -rno TARGET "/mnt/wsl/loot" >/dev/null; then
            gsudo="/mnt/c/Program Files/gsudo/2.6.0/gsudo.exe"
            if [ ! -x "$gsudo" ]; then
              echo "Error: \`gsudo.exe\` not found or not executable at \`$gsudo\`"
              exit 1
            fi

            # NOTE: output is broken through systemd journal
            "$gsudo" wsl --mount '\\.\PHYSICALDRIVE2' --partition 1 --name loot --type ext4
          fi
        ''}
      '';
      Type = "oneshot";
      Restart = "no";
      RemainAfterExit = true;
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
  };
}
