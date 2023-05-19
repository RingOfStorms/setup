# Prereq
- Nerd font jetbrains mono

# Application list:
## Bins
- curl
- (zsh)[https://ohmyz.sh/#install]
  - oh my zsh
  - powerlevel10k installation
  - setup powerlevel10k theme
- neofetch
- htop
- rust / rustup,cargo,cargo-binstall
    - stable + nightly installed
- cargo-binstall
    - rtx-cli
    - sccache
    - genemichaels
    - evcxr_repl

- rtx
    - neovim
    - node@__
    - python@__
    - jq
    - age
    - ripgrep
- docker

# GUI
- wezterm
- firefox
- discord?

# Settings
- sudoers file, check each OS (include file in main sudoers dir)
- astronvim + user config
    - TODO make own full config
- wezterm
- psqlrc
- git setting
    - global ignore (note cannot be sym linked)
    - global config
    - 

# Notes

.zshenv → .zprofile → .zshrc → .zlogin → .zlogout
^ always    ^login    ^ interactive ^     ^

# OS Specific Settings
- ALL
    - caps lock = escape
    - super + H/L switch workspaces/virutal desktops
    - super + z/c/v undo/copy/paste
    - firefox `ui.key.accelKey` set to `91` on all profiles
- Debian
    - dark mode
    - reboot to windows function in profiles
    - xfce_debian_setup in fastmail notes, check that list
    - U luancher
- OSx
    - dark mode
    - spotlight only calculator and local apps
    - 
- Windows?
- Android?


# Other things
- Sleep disabled/caff



# Misc

```sh
# Reboot directly to Windows
# Inspired by http://askubuntu.com/questions/18170/how-to-reboot-into-windows-from-ubuntu
reboot_to_windows ()
{
    windows_title=$(grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
    sudo grub-reboot "$windows_title" && sudo reboot
}
alias reboot-to-windows='reboot_to_windows'

```