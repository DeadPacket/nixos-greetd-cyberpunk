# PROJECT2: GREETD/TUIGREET CONFIG

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


#############################################
##              SYSTEM BASICS              ##
#############################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
     "quiet"
     "loglevel=3"
     "rd.systemd.show_status=false"
     "vt.global_cursor_default=0"
  ];
  
  systemd.services.greetd.serviceConfig = {
     TTYReset = true;
     TTYVHangup = true;
     TTYVTDisallocate = true;
  };

 
  # Set your time zone.
  time.timeZone = "America/New_York";

  nix.settings.experimental-features = [ "nix-command" "flakes"];


#############################################
##           CONSOLE / TTY THEME           ##
#############################################
  # Console (TTY) appearance - affects greetd/tuigreet
  console = {
     useXkbConfig = true;

     colors = [
	"000b1e" # 0 - black (background)
	"ff0000" # 1 - red
	"d300c4" # 2 - green (magenta in my theme)
	"f57800" # 3 - yellow/orange
	"133e7c" # 4 - blue
	"711c91" # 5 - purple
	"0abdc6" # 6 - cyan (PRIMARY COLOR)
	"0abdc6" # 7 - white (use cyan for glow effect)

	"1c61c2" # 8 - bright black
	"ff0000" # 9 - bright red
	"d300c4" # 10 - bright green
	"ff5780" # 11 - bright yellow
	"00ff00" # 12 - bright blue (neon green pop)
	"711c91" # 13 - bright purple
	"0abdc6" # 14 - bright cyan
	"ffffff" # 15 - bright white
     ];
  };


#############################################
##              USERS & SUDO               ##
#############################################                           
  users.users.dev = {                                              
  isNormalUser = true;                                               
  extraGroups = [ "wheel" "networkmanager" "audio" "video" "storage" ]; # Enable ‘sudo’ for the user.
 };
  security.sudo.enable = true; #Allows 'sudo' for users in wheel group


#############################################
##               NETWORKING                ##
#############################################
   networking.hostName = "nixos"; # Define your hostname.              
   # Configure network connections interactively with nmcli or nmtui.
   networking.networkmanager.enable = true;
   # Configure network proxy if necessary 
   # networking.proxy.default = "http://user:password@proxy:port/";
   # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


#############################################
##          GREETD CONFIGURATION           ##
#############################################
#  security.pam.services.greetd.enableGnomeKeyring = true;
  
  services.greetd = {
     enable = true;

     settings = {
	default_session = {
	   command = ''
	      ${pkgs.tuigreet}/bin/tuigreet \
		 --time \
		 --time-format "%Y-%m-%d %H:%M:%S" \
		 --remember \
		 --asterisks \
		 --greeting "AUTHENTICATION REQUIRED" \
		 --window-padding 4 \
		 --container-padding 2 \
		 --cmd startx
	   '';
	   user = "greeter";
	};
     };
  }; 


#############################################
##           GREETD ENVIRONMENTS           ##
#############################################
  environment.etc."issue".text = ''
  \e[1;36m==============================================\e[0m
  \e[1;35m               [NEXUS NODE-01]                \e[0m
  \e[1;36m----------------------------------------------\e[0m

  \e[1;34m        Secure Authentication Interface       \e[0m

  \e[1;32m System Status:\e[0m ONLINE
  \e[1;32m Integrity Check:\e[0m PASSED

  Time: \l
  
  \e[1;31m Authorized Access Only.\e[0m
  \e[1;31m All Activity Is Monitored.\e[0m
  \e[1;36m==============================================\e[0m
  
  '';

#  environment.etc."greetd/environments".text = ''
#     i3
#  '';


#############################################
##             X SERVER FOR i3             ##
#############################################
  # Enable the X11 windowing system (needed for i3)
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true; #Allow Starting X sessions via startx (used after greetd login)
  services.xserver.windowManager.i3.enable = true;	#Enable i3 Window Manager
  services.displayManager.sddm.enable = false;		#Disable SDDM
  
  # Make i3 available as a selectable session
  #services.displayManager.sessionPackages = [
  #   pkgs.xorg.xinit
  #];  

  #services.displayManager.defaultSession = "none+i3";
  services.displayManager.autoLogin.enable = false;
     
  # services.xserver.layout = "us";
  # services.xserver.videoDrivers = []


#############################################
##         WAYLAND WINDOW MANAGER          ##
#############################################
  #programs.hyperland.enable = true;


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";


#############################################
##                  AUDIO                  ##
#############################################
  # Enable sound.
  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;


#############################################
##            FONTS & UTILITIES            ##
#############################################
  fonts.packages = with pkgs;
[
	nerd-fonts.jetbrains-mono
	noto-fonts
	
];

  environment.systemPackages = with pkgs; 
[
#	(pkgs.stdenv.mkDerivation {
#	      name = "sddm-theme-cyberpunk";
	      
#	      src = /etc/nixos/themes/cyberpunk;

#	      installPhase = ''
#		 mkdir -p $out/share/sddm/themes/cyberpunk
#		 cp -r . $out/share/sddm/themes/cyberpunk/
#	      '';
#	})

	vim
	git
	wget
	curl
	htop
	neofetch
	feh

	i3status
	i3lock-color
	tuigreet		#Fallback Option
	gtkgreet
	cage
#	bibata-cursors
#	papirus-icon-theme
#	sddm-astronaut
		
	kitty
	kdePackages.kate
	kdePackages.dolphin
	kdePackages.okular
	libreoffice
	onlyoffice-desktopeditors
	chromium
	firefox
	mullvad-browser

	rofi
	dunst
	nitrogen
	polybar
	picom
	
	libva-vdpau-driver
	jmtpfs
	mtpfs
	gvfs
];

  # Hardware Video Acceleration
  hardware.graphics.enable = true;
  
  # Power Management Service
  services.upower.enable = true;

  # Storage
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;


#############################################
##             SYSTEM OPTIONS              ##
#############################################
system.stateVersion = "25.11"; #My NoxOS version

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  # wget
  # konsole
  #];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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
  # system.stateVersion = "25.11"; # Did you read the comment?

}
