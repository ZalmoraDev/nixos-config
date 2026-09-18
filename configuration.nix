# NixOS/Home Manager option types:
# - Config-generating:
#     serializes a Nix value into the app's own config
#     syntax. Breaks on syntax changes; fights apps that self-write config.
#
# - Format-agnostic:
#     packages, env vars, files, toggles. Doesn't touch
#     the app's config syntax at all.
#
# This config avoids using config-generating options,
# I find them to be problematic as they wrap config files,
# adding an unneeded middleman between config being written and being read,
# which adds extra complexity and points of breakage

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
  imports =
    [
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];


  # Set ownership of /etc/nixos to 'users' group, no sudo needed
  system.activationScripts.nixosConfigOwnership = {
    text = ''
      chown -R sv:users /etc/nixos
      chmod -R g+rwx /etc/nixos
    '';
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];





  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.sv = import ./home.nix;


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;  # ESP is 260MiB, limit to 5 nixos generations


  # GPU Support
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    #powerManagement.finegrained = true; # 30-series or higher
    open = true;
    nvidiaSettings = true;
  };
  services.xserver.videoDrivers = ["nvidia"];


  # User & System
  networking.hostName = "helios";
  users.users."sv" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [];
  };





  # Enable networking & bluetooth
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";






  # TODO: Figure out how to have home-manager 'own' /etc\ folders
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
  };

  programs.uwsm.enable = true;
  programs.xwayland.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true; # Universal Wayland Session Manager, enables systemd integration
    xwayland.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];











  services.udisks2.enable = true; # Used by Dolphin to show mounted devices

  environment.systemPackages = with pkgs; [
    # ABCD
    alsa-utils              # 2026-09-08 | provides `arecord` voice recording command, used by Whisper for STT
    anki                    # 2026-09-08 | Flashcard Spaced-repetition
    audacity                # 2026-09-08 | simple audio recorder/editor

    bat                     # 2026-09-10 | Improved cat
    blanket                 # 2026-09-08 | Whitenoise audio
    blender                 # 2026-09-08 | 3D modeller
    bluetui                 # 2026-09-08 | Bluetooth TUI
    brave                   # 2026-09-08 | Privacy centric chromium-based webbrowser
    brightnessctl           # 2026-09-08 | Used by hyprland to change laptop brightness
    btop                    # 2026-09-08 | Improved top, real-time process statistics

    cliphist                # 2026-09-08 | Clipboard history
    cmake                   # 2026-09-08 | c/c++ build configuration system
    contrast                # 2026-09-08 | WCAG color contrast testing tool

    davinci-resolve         # 2026-09-08 | Video editor
    discord                 # 2026-09-08 | Degenerate gamer communication platform
    docker                  # 2026-09-08 | Container management tool
    drawio                  # 2026-09-08 | ERD/UML diagram drawing

    ###########################################################################
    # EFGH
    fastfetch               # 2026-09-08 | Display system info

    ghostty                 # 2026-09-08 | Terminal emulator (main)
    git                     # 2026-09-08 | Version control system
    git-fame                # 2026-09-11 | Git contribution statistic
    gource                  # 2026-09-11 | Git contribution timeline visualizer

    hyprland                # 2026-09-08 | Hyprland, Tiling window manager
    hypridle                # 2026-09-08 | Hyprland sleep
    hyprlock                # 2026-09-08 | Hyprland screenlock
    hyprpaper               # 2026-09-08 | Hyprland wallpaper
    hyprshot                # 2026-09-08 | Hyprland screenshots
    hyprsunset              # 2026-09-08 | Hyprland bluelight/brightness adjustment

    ###########################################################################
    # IJKL
    jetbrains.webstorm      # 2026-09-08 | JetBrains Node IDE
    jetbrains.clion         # 2026-09-08 | JetBrains C/C++IDE
    jetbrains.phpstorm      # 2026-09-08 | JetBrains PHP IDE

    kdePackages.dolphin     # 2026-09-08 | File manager
    kdePackages.filelight   # 2026-09-08 | Disk use visualizer
    kdePackages.kalm        # 2026-09-08 | BREATHING
    kdePackages.kate        # 2026-09-08 | Textfile viewer
    kdePackages.kcalc       # 2026-09-08 | Calculator
    kdePackages.okular      # 2026-09-08 | PDF viewer
    kitty                   # 2026-09-08 | Terminal emulator (backup for Ghostty)
    krita                   # 2026-09-08 | Digital art tool

    libreoffice             # 2026-09-08 | Office application suite
    lshw                    # 2026-09-08 | list hardware info, lsusb & lspci

    ###########################################################################
    # MNOP
    nomacs                  # 2026-09-08 | image viewer
    numlockx                # 2026-09-18 | set numlock on by default

    obsidian                # 2026-09-08 | Note taking app
    obs-studio              # 2026-09-08 | Screenrecording
    openai-whisper          # 2026-09-08 | Speach-to-Text
    opencode                # 2026-09-08 | Open-source ai agent

    pavucontrol             # 2026-09-08 | PulseAudio volume control
    pciutils                # 2026-09-08 | lsusb command for USB devices
    playerctl               # 2026-09-08 | Used by hyprland to control MPRIS-enabled media (spotify pause/resume)
    proton-vpn-cli          # 2026-09-08 | VPN client
    #pureref                 # 2026-09-08 | imageboard for art references bugs out
    python3                 # 2026-09-08 | Python interpreter

    ###########################################################################
    # QRST
    rofi                    # 2026-09-08 | Dynamic menu for app lauching
    rofimoji                # 2026-09-08 | Rofi clipboard & emoji list

    scrcpy                  # 2026-09-08 | Display & Control Android Devices
    spotify                 # 2026-09-08 | Music streaming client
    starship                # 2026-09-08 | Prompt string replacer
    steam                   # 2026-09-08 | PC Games
    swaynotificationcenter  # 2026-09-08 | Sway notification manager

    tmux                    # 2026-09-08 | Terminal Multiplexer
    tree                    # 2026-09-10 | ls as tree view

    ###########################################################################
    # UVWXYZ
    usbutils                # 2026-09-08 | lspci command for PCIe devices

    virtualbox              # 2026-09-08 | VM management tool
    vlc                     # 2026-09-08 | VLC media player

    waybar                  # 2026-09-08 | Wayland taskbar
    #wget                    # 2026-09-08 | CLI HTTPS/SFTP downloading
    wl-clipboard            # 2026-09-08 | Command-line copy/paste util (used by scripts, like whisper STT)
    wshowkeys               # 2026-09-08 | Keyboard input UI display

    xnconvert               # 2026-09-08 | Bulk image converter

    #zen                     # 2026-09-08 | Privacy centric firefox-based webbrowser

    ###################################################################################################################
    # Theming & Icons
    adwaita-icon-theme                    # 2026-09-10 | GNOME Adwaita cursor theme

    qt6Packages.qt6ct                     # 2026-09-13 | QT Themeing
    qt6.qtwayland # NO IDEA


    kdePackages.breeze
    kdePackages.breeze-icons
    kdePackages.qqc2-desktop-style

    kdePackages.kdegraphics-thumbnailers  # 2026-09-10 | More Dolphin file previews ()
    kdePackages.kio-extras                # 2026-09-11 | More Dolphin file previews ()
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
    noto-fonts
  ];


  #environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";
  programs.dconf.enable = true; # GNOME / GTK theme support





  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };




  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;



  # ###################################################################################################################
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
