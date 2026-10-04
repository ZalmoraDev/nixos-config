{ config, pkgs, ... }:

let
  dotfiles = /etc/nixos/dotfiles;
in
{
  home.username = "sv";
  home.homeDirectory = "/home/sv";
  home.stateVersion = "26.05";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;

    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      text-scaling-factor = 1.0;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "audio/mp3" = "vlc.desktop";
      "audio/wav" = "vlc.desktop";
      "audio/ogg" = "vlc.desktop";

      "image/gif" = "org.nomacs.ImageLounge.desktop";
      "image/jpeg" = "org.nomacs.ImageLounge.desktop";
      "image/jpg" = "org.nomacs.ImageLounge.desktop";
      "image/png" = "org.nomacs.ImageLounge.desktop";
      "image/webp" = "org.nomacs.ImageLounge.desktop";

      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
      "text/html" = "brave-browser.desktop";

      "text/plain" = "org.kde.kate.desktop";
      "text/xml" = "org.kde.kate.desktop";
      "application/json" = "org.kde.kate.desktop";
      "application/jsonc" = "org.kde.kate.desktop";
      "application/octet-stream" = "org.kde.kate.desktop";
      "application/x-zerosize" = "org.kde.kate.desktop";
      "inode/x-empty" = "org.kde.kate.desktop";

      "application/pdf" = "okularApplication_pdf.desktop";
      "application/pur" = "PureRef-2.0.3_x64.Appimage.desktop";

      "x-scheme-handler/gitkraken" = "GitKraken.desktop";
      "x-scheme-handler/jetbrains" = "jetbrainsd.desktop";
    };
  };

  # Commented lines contain sentsitive data, figure out how to .gitignore a setup for this
  # ABCD
  home.file.".bashrc".source = dotfiles + "/bash/.bashrc";                                              # 2026-09-10 | bash
  home.file.".bash_profile".source = dotfiles + "/bash/.bash_profile";                                  # 2026-09-10 | bash
  home.file.".bash_logout".source = dotfiles + "/bash/.bash_logout";                                    # 2026-09-12 | bash

  #home.file.".config/blender".source = dotfiles + "/blender/.config/blender";                           # 2026-09-12 | blender, contains project paths & search histories

  home.file.".clang-format".source = dotfiles + "/clang/.clang-format";                                 # 2026-09-10 | clangformat

  home.file.".config/dolphinrc".source = dotfiles + "/dolphin/.config/dolphinrc";                       # 2026-09-12 | dolphin

  ###############################################################################################################################
  # EFGH
  home.file.".config/fastfetch".source = dotfiles + "/fastfetch/.config/fastfetch";                     # 2026-09-10 | fastfetch

  home.file.".config/ghostty".source = dotfiles + "/ghostty/.config/ghostty";                           # 2026-09-10 | ghostty

  home.file.".gitconfig".source = dotfiles + "/git/.gitconfig";                                         # 2026-09-10 | git

  home.file.".config/hypr".source = dotfiles + "/hypr/.config/hypr";                                    # 2026-09-10 | hyprland


  ###############################################################################################################################
  # IJKL
  #home.file.".config/kdeglobals".source = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
  home.file.".config/kdeglobals".source = dotfiles + "/kdeglobals/.config/kdeglobals";                  # 2026-09-18 | kde theming (dark)

  ###############################################################################################################################
  # MNOP
  #home.file.".config/mimeapps.list".source = dotfiles + "/mimeapps/.config/mimeapps.list";              # 2026-09-10 | mimemapps

  home.file.".nanorc".source = dotfiles + "/nano/.nanorc";                                              # 2026-09-12 | nano
  home.file.".local/share/nano".source = dotfiles + "/nano/.local/share/nano";                          # 2026-09-12 | nano

  #home.file.".config/PureRef/PureRef.ini".source = dotfiles + "/pureref/.config/PureRef/PureRef.ini";   # 2026-09-12 | pureref, contains project paths & search histories

  ###############################################################################################################################
  # QRST
  home.file.".config/rofi".source = dotfiles + "/rofi/.config/rofi";                                    # 2026-09-10 | rofi config
  home.file.".local/share/rofi".source = dotfiles + "/rofi/.local/share/rofi";                          # 2026-09-10 | rofi themes

  home.file.".config/starship.toml".source = dotfiles + "/starship/.config/starship.toml";              # 2026-09-10 | starship

  home.file.".tmux.conf".source = dotfiles + "/tmux/.tmux.conf";                                        # 2026-09-10 | tmux

  ###############################################################################################################################
  # UVWXYZ
  home.file.".config/waybar".source = dotfiles + "/waybar/.config/waybar";                              # 2026-09-10 | waybar

  #home.file.".ssh".source = dotfiles + "/ssh/.ssh";                                                     # 2026-09-12 | ssh, contains private SSH keys
}
