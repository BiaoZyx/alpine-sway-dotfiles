# Alpine-Sway-Dotfiles
## Introduction
### What is it?
This repo is the dot files of my sway on Alpine Linux. It keeps simple and easy to read. And there is something else to help me setup my Alpines. Hope it can help you.
It's best to use it on Alpine Linux, but you can fork it and use it on other distros.  

### Why there isn't a `setup.sh`?
There isn't a `setup.sh` because I'm afraid of that it may cover your configs. So you'd better backup some parts of your configs and then copy the configs in this repo to your system by yourself.

## Requirements
### Core packages
#### System
1.  `bash`
2.  `cmd:env`
3.  `cmd:dbus-launch`
4.  `dbus`
5.  `dbus-x11`
6.  `cmd:seatd-launch`
7.  `seatd`
8.  `doas` (Optional: `doas-sudo-shim`)
9.  `elogind`
10. `udisks2` 
11. `polkit-elogind`

#### Audio
1.  `alsa-utils`
2.  `pipewire`
3.  `pipewire-alsa`
4.  `pipewire-pulse`
5.  `pipewire-tools`
6.  `pulseaudio-utils`
7.  `wireplumber`
8.  `wireplumber-lang`
9.  `wireplumber-libs`
10. `wireplumber-logind`
11. `wayland-pipewire-idle-inhibit`

> Optional:
>   - pavucontrol
>   - pavucontrol-lang

#### Desktop
1.  `sway`
2.  `swaybg`
3.  `swayidle`
4.  `swaylock-effects`
5.  `swaylockd`
6.  `waybar`
7.  `xwayland`
8.  `wl-clipboard`
9.  `cliphist`
10. `fnott`
11. `rofi` or `fuzzel` *\(Fuzzel for default. Change the default one in `~/.config/waybar/config` and `~/.config/sway/config.d/keybindings.sway`\)*
12. `grimshot`
13. `foot`

#### Font
1. `font-noto`
2. `font-noto-cjk`
3. `font-noto-emoji`
4. `font-noto-music`
5. `font-jetbrains-mono-nerd`

## The way to install
First, I recommend you to run `su -c 'setup-desktop sway'`, then some packages like `sway`, `swaybg` will be installed automaticly.
Then, install the packages above and copy the configs in `user-home/.config/`:
```sh
# Make sure you're in the repo path
mkdir -p ~/.config && cp ./user-home/.config/{sway,swaylock,waybar,fuzzel,fnott,foot} ~/.config/
```
