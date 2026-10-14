{ config, pkgs, ... }:
let
  rootfiles = /etc/nixos/rootfiles;
in
{
  environment.etc = {
    "sddm.conf.d/10-custom.conf".source = rootfiles + "/etc/sddm.conf.d/10-custom.conf";          # 2026-10-10 | sddm display manager login
    "sddm/themes/silent".source = rootfiles + "/etc/sddm/themes/silent";                          # 2026-10-10 | sddm display manager login
  };
}