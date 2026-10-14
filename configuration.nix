########################################################################################################################
# region Imports
{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./rootfiles.nix
      (import "${home-manager}/nixos")
    ];

  ######################################################################################################################
  # region NixOS config
  system.stateVersion = "26.05"; # Do NOT change this value
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true; # Allow running non-nix packaged dynamic libraries

  # Home manager
  home-manager = {
    users.sv = import ./dotfiles.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "nixos-backup";
  };

  # Set ownership of /etc/nixos to 'users' group, so sudo is not needed for editing
  system.activationScripts.nixosConfigOwnership.text = "chown -R sv:users /etc/nixos; chmod -R g+rwx /etc/nixos";


  ######################################################################################################################
  # region systemdboot, sddm & hyprland
  boot = {
    # second LUKS drive, this isn't generated in hardware-configuration.nix SO IT MUST BE DESCRIBED HERE
    initrd.luks.devices.cryptdata2.device = "/dev/disk/by-uuid/978907d3-46fb-4e12-a36a-b6f34b7d85e6";

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;  # ESP is 260MiB, limit to 5 nixos generations
      efi.canTouchEfiVariables = true;
    };
  };

  # configuration in dir ./rootfiles/
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };

    # Correct displays for SDDM
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr \
        --output eDP-1  --auto --primary --pos 0x1080 \
        --output HDMI-1 --auto --above eDP-1 \
        --output DP-1   --auto --right-of eDP-1
    '';
  };

  programs.uwsm.enable = true;
  programs.xwayland.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true; # Universal Wayland Session Manager, enables systemd integration
    xwayland.enable = true;
  };


  ######################################################################################################################
  # region GPU Support
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
#      powerManagement.finegrained = true;
#      prime = {
#        offload.enable = true;
#        offload.enableOffloadCmd = true;   # nvidia-offload wrapper
#        intelBusId = "PCI:0:2:0";
#        nvidiaBusId = "PCI:1:0:0";
#      };

      open = true;
    };
  };
  services.xserver.videoDrivers = ["nvidia"];


  ######################################################################################################################
  # region User & System
  networking.hostName = "helios";
  users.users."sv" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    packages = with pkgs; [];
  };


  ######################################################################################################################
  # region Enable networking & bluetooth
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # PulseAudio support, needed for Kate among others
    jack.enable = true;     # optional, for JACK host in Audacity
  };

  services.udisks2.enable = true; # Required by Dolphin to show mounted devices
  virtualisation.docker.enable = true; # Required to enable docker service


  ######################################################################################################################
  # region Packages
  environment.systemPackages = with pkgs; [
    # ABCD
    alsa-utils                            # 2026-09-08 | provides `arecord` voice recording command, used by Whisper for STT
    anki                                  # 2026-09-08 | Flashcard Spaced-repetition
    audacity                              # 2026-09-08 | simple audio recorder/editor

    bat                                   # 2026-09-10 | Improved cat
    blanket                               # 2026-09-08 | Whitenoise audio
    blender                               # 2026-09-08 | 3D modeller
    bluetui                               # 2026-09-08 | Bluetooth TUI
    brave                                 # 2026-09-08 | Privacy centric chromium-based webbrowser
    brightnessctl                         # 2026-09-08 | Used by hyprland to change laptop brightness
    btop                                  # 2026-09-08 | Improved top, real-time process statistics

    cliphist                              # 2026-09-08 | Clipboard history
    cmake                                 # 2026-09-08 | c/c++ build configuration system
    contrast                              # 2026-09-08 | WCAG color contrast testing tool

    davinci-resolve                       # 2026-09-08 | Video editor
    discord                               # 2026-09-08 | Degenerate gamer communication platform
    docker                                # 2026-09-08 | Container management tool
    drawio                                # 2026-09-08 | ERD/UML diagram drawing

    ###########################################################################
    # EFGH
    efibootmgr                            # 2026-10-11 | EFI boot management tool

    fastfetch                             # 2026-09-08 | Display system info
    file                                  # 2026-09-24 | Basic Linux util for file type identificaition

    ghostty                               # 2026-09-08 | Terminal emulator (main)
    git                                   # 2026-09-08 | Version control system
    git-fame                              # 2026-09-11 | Git contribution statistic
    gource                                # 2026-09-11 | Git contribution timeline visualizer

    hyprland                              # 2026-09-08 | Hyprland, Tiling window manager
    hypridle                              # 2026-09-08 | Hyprland sleep
    hyprlock                              # 2026-09-08 | Hyprland screenlock
    hyprpaper                             # 2026-09-08 | Hyprland wallpaper
    hyprpicker                            # 2026-10-09 | Hyprland colorpicker
    hyprshot                              # 2026-09-08 | Hyprland screenshots
    hyprsunset                            # 2026-09-08 | Hyprland bluelight/brightness adjustment

    ###########################################################################
    # IJKL
    jetbrains.webstorm                    # 2026-09-08 | JetBrains IDE Node
    jetbrains.clion                       # 2026-09-08 | JetBrains IDE C/C++
    jetbrains.phpstorm                    # 2026-09-08 | JetBrains IDE PHP
    jetbrains.rust-rover                  # 2026-10-04 | JetBrains IDE Rust

    kdePackages.dolphin                   # 2026-09-08 | File manager
    kdePackages.ffmpegthumbs              # 2026-09-24 | Video thumbnails (mp4, mkv, webm...)
    kdePackages.filelight                 # 2026-09-08 | Disk use visualizer
    kdePackages.kalm                      # 2026-09-08 | BREATHING
    kdePackages.kate                      # 2026-09-08 | Textfile viewer
    kdePackages.kcalc                     # 2026-09-08 | Calculator
    kdePackages.kdegraphics-thumbnailers  # 2026-09-24 | PDF/PS previews, RAW camera images
    kdePackages.kimageformats             # 2026-09-24 | Image thumbnails (webp, tiff...)
    kdePackages.kio-extras                # 2026-09-24 | broader KIO previews/protocols, general polish
    kdePackages.okular                    # 2026-09-08 | PDF viewer
    kdePackages.qtimageformats            # 2026-10-04 | KDE Dolphin previews: WebP, TIFF, TGA, MNG
    kitty                                 # 2026-09-08 | Terminal emulator (backup for Ghostty)
    krita                                 # 2026-09-08 | Digital art tool

    libreoffice                           # 2026-09-08 | Office application suite
    lshw                                  # 2026-09-08 | list hardware info, lsusb & lspci
    lxmenu-data                           # 2026-10-04 | lxde data, needed for mimeapps associations (few KB, menu XML + directory files)

    ###########################################################################
    # MNOP
    nodejs                                # 2026-09-24 | JS execution outside of browser engines
    nomacs                                # 2026-09-08 | image viewer
    numlockx                              # 2026-09-18 | set numlock on by default

    obsidian                              # 2026-09-08 | Note taking app
    obs-studio                            # 2026-09-08 | Screenrecording
    openai-whisper                        # 2026-09-08 | Speach-to-Text
    opencode                              # 2026-09-08 | Open-source ai agent
    openssl                               # 2026-09-24 | Secure communications and random hex generation

    pavucontrol                           # 2026-09-08 | PulseAudio volume control
    pciutils                              # 2026-09-08 | lsusb command for USB devices
    phpPackages.composer                  # 2026-10-04 | Dependency Manager for PHP
    pipewire                              # 2026-09-24 | Linux audio
    playerctl                             # 2026-09-08 | Used by hyprland to control MPRIS-enabled media (spotify pause/resume)
    pnpm                                  # 2026-09-24 | parallel npm
    proton-vpn-cli                        # 2026-09-08 | VPN client
    #pureref                               # 2026-09-08 | imageboard for art references
    python3                               # 2026-09-08 | Python interpreter

    ###########################################################################
    # QRST
    rofi                                  # 2026-09-08 | Dynamic menu for app lauching
    rofimoji                              # 2026-09-08 | Rofi clipboard & emoji list

    scrcpy                                # 2026-09-08 | Display & Control Android Devices
    sddm-astronaut                        # 2026-10-10 | SDDM theme
    spotify                               # 2026-09-08 | Music streaming client
    starship                              # 2026-09-08 | Prompt string replacer
    steam                                 # 2026-09-08 | PC Games
    swaynotificationcenter                # 2026-09-08 | Sway notification manager

    tailscale                             # 2026-10-12 | Mesh VPN built on WireGuard
    tmux                                  # 2026-09-08 | Terminal Multiplexer
    tree                                  # 2026-09-10 | ls as tree view

    ###########################################################################
    # UVWXYZ
    usbutils                              # 2026-09-08 | lspci command for PCIe devices

    virtualbox                            # 2026-09-08 | VM management tool
    vlc                                   # 2026-09-08 | VLC media player

    waybar                                # 2026-09-08 | Wayland taskbar
    wl-clipboard                          # 2026-09-08 | Command-line copy/paste util (used by scripts, like whisper STT)
    wshowkeys                             # 2026-09-08 | Keyboard input UI display

    xnconvert                             # 2026-09-08 | Bulk image converter

    #zen                                   # 2026-09-08 | Privacy centric firefox-based webbrowser # DOESN'T WORK
  ];

  fonts = {
    enableDefaultPackages = true;   # DejaVu, Liberation, etc.

    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
      noto-fonts
      font-awesome
    ];
  };

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
    LC_TIME = "en_US.UTF-8";
  };
}
