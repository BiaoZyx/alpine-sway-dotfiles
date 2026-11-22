# Alpine-Sway-Dotfiles

Sway window manager dotfiles for Alpine Linux — kept simple and readable, with a few helpers for getting Alpine set up.

## Introduction

This is a minimal, tweakable Sway setup for Alpine Linux. It favors clarity over cleverness, so you can read each config and adjust it to fit your own workflow. All shell scripts are POSIX `sh` (no bash required), and it's written for Alpine but portable — fork it and adapt it to any other distro.

> There's intentionally no `setup.sh`. Automating the copy would risk clobbering configs you already have. Instead, back up your existing configs and copy the ones here over yourself.
> Some configs/comments are in Chinese (qutebrowser, waybar scripts). You may want to rewrite them for your own locale.

### Screenshots

Normal mode with a foot terminal:

![Normal mode with a foot terminal](./screenshot1.png)

Privacy indicator (mic muted / camera / location / screen sharing / recording):

![Privacy Indicator](./screenshot2.png)

## What's included

- **Sway** with 10 workspaces, Vim-style focus keys, gestures, scratchpad, screenshot/recording bindings.
- **Waybar** with workspace/layout indicator (H/V/T/S), privacy indicator (mic mute, camera, location, screen sharing, recording red dot), volume/network/cpu/memory/clock/battery/tray/power, and a system-info panel on `$mod+i`.
- **Power menu** on `$mod+x` or by clicking the power element; the waybar-triggered one is anchored under the button and closes on focus loss.
- **Automation**: media is paused before lock/suspend; waybar is restarted after suspend; audio services are restarted from a clean state on login.
- **Launcher**: fuzzel (app menu, clipboard menu, power menu).
- **Apps**: foot, fuzzel, fnott, qutebrowser, Helix, cliphist, fcitx5 configs.

## Config layout

The main `config` is deliberately tiny: it only loads fragments, starts the session, and exports variables. Everything else is split by responsibility, so you can find and tweak one thing without reading the whole setup:

```text
~/.config/sway/
├── config                 # entry point: includes, startup.sh, D-Bus env
└── config.d/
    ├── binds.sway         # keys, gestures, resize mode (bindsym/bindgesture)
    ├── idle.sway          # swayidle, suspend, idle inhibition
    ├── input.sway         # keyboard / touchpad settings
    ├── rules.sway         # per-window rules (currently Firefox PiP)
    └── theme.sway         # borders, gaps, wallpaper, cursor
```

Reusable commands live in `scripts/` instead of being inlined into keybindings: `startup.sh`, `screenshot.sh`, `record.sh`, `sysinfo.sh`, `restart_waybar.sh`, `fuzzel-drun.sh`. That keeps `binds.sway` to a readable "key -> script" mapping.

> File extension: Sway's `include config.d/*` does not care about suffixes. `.sway` is just a convention used here; it is not required by Sway.

## Getting the repo

```sh
git clone https://github.com/BiaoZyx/alpine-sway-dotfiles.git
cd alpine-sway-dotfiles
```

All commands below assume you are in this directory.

## Requirements

All shell scripts use POSIX `sh` (busybox ash is enough); `bash` is **not** required.

### System

Needed for the session, D-Bus, permissions and suspend:

- `dbus` (`dbus-daemon`, `dbus-send`, `dbus-update-activation-environment`)
- `dbus-x11` (`dbus-launch`)
- `seatd` (`seatd-launch`)
- `doas` or `sudo`
- `elogind` (`loginctl`, suspend/lock)
- `polkit-elogind`
- `udisks2`
- `greetd` + `greetd-tuigreet` (login manager and its TUI greeter)

```sh
doas apk add dbus dbus-x11 seatd doas elogind polkit-elogind udisks2 greetd greetd-tuigreet
```

### Audio

Pipewire stack plus the tools used by scripts/waybar (`pw-dump`, `wpctl`, `pactl`, `amixer`):

- `alsa-utils`, `pipewire`, `pipewire-alsa`, `pipewire-pulse`, `pipewire-tools`
- `pulseaudio-utils`, `wireplumber`, `wireplumber-logind`
- `wayland-pipewire-idle-inhibit`

```sh
doas apk add alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-tools pulseaudio-utils wireplumber wireplumber-logind wayland-pipewire-idle-inhibit
```

Optional GUI mixer:

```sh
doas apk add pavucontrol pavucontrol-lang
```

### Desktop

Core WM/bar/launcher, screenshot & recording, and helper tools used by the scripts:

- `sway`, `swaybg`, `swayidle`, `swaylock-effects` (provides `swaylock`), `waybar`, `xwayland`
- `wl-clipboard`, `cliphist`, `fnott`, `fuzzel`
- `grimshot`, `wf-recorder`, `slurp` (screenshots/recording)
- `jq` (JSON parsing in waybar scripts), `playerctl` (media keys / pause on lock)
- `fcitx5` (input method)
- `xdg-desktop-portal`, `xdg-desktop-portal-wlr` (screen sharing)

```sh
doas apk add sway swaybg swayidle swaylock-effects waybar xwayland wl-clipboard cliphist fnott fuzzel grimshot wf-recorder slurp jq playerctl fcitx5 xdg-desktop-portal xdg-desktop-portal-wlr
```

### Font

```sh
doas apk add font-noto font-noto-cjk font-noto-emoji font-noto-music font-jetbrains-mono-nerd
```

### Recommended / optional apps

These have configs in the repo but aren't required for the desktop itself:

```sh
doas apk add eza fortune helix qutebrowser
```

## Installation

### 1. Bootstrap `doas`

Every command below uses `doas`. On a fresh Alpine install it is not configured yet, so do this once as root:

```sh
su -
apk add doas
cp /path/to/alpine-sway-dotfiles/etc/doas.conf /etc/doas.conf
adduser <your-username> wheel
exit
```

Replace `/path/to/alpine-sway-dotfiles` with the directory from *Getting the repo*, and `<your-username>` with your login name. Log out and back in so the new group takes effect, then verify with `doas echo ok`.

### 2. Install packages

I recommend running `su -c 'setup-desktop sway'` first; it installs some base packages automatically. Then follow the per-section `apk add` commands in *Requirements* above.

### 3. Copy configs

Back up anything you already have, then copy the configs (make sure you're in the repo root):

```sh
# Core desktop configs
mkdir -p ~/.config
for d in sway swaylock waybar fuzzel fnott foot fontconfig; do cp -r "./user-home/.config/$d" ~/.config/; done

# Optional app configs
for d in helix qutebrowser; do cp -r "./user-home/.config/$d" ~/.config/; done

# Shell / editor dotfiles
for f in profile zshrc p10k.zsh fzf.zsh vimrc; do cp "./user-home/.$f" ~/; done
mkdir -p ~/.vim && cp -r ./user-home/.vim/. ~/.vim/

# Themes, cursor and wallpapers
mkdir -p ~/.local/share
for d in fcitx5 icons; do cp -r "./user-home/.local/share/$d" ~/.local/share/; done
mkdir -p ~/Pictures && cp -r ./user-home/Pictures/. ~/Pictures/

# Make sure the scripts stay executable
chmod +x ~/.config/sway/scripts/*.sh ~/.config/waybar/scripts/*.sh ~/.config/qutebrowser/userscripts/save_links
```

Note: qutebrowser's generated files (`autoconfig.yml`, `links.js`, `quickmarks.js`, `qsettings/`) are intentionally ignored and not part of the repo.

Display manager: this repo uses **greetd + tuigreet** only (lightdm is not included). To install its configured greeter:

```sh
doas cp ./etc/greetd/config.toml ./etc/greetd/greet.sh /etc/greetd/
doas chmod +x /etc/greetd/greet.sh
```

The greeter defaults to `sway`, offers a session menu (F3), command menu (F2), power menu (F12), remembers the last username, and greets you with `Hello, <USER>!` once known. It uses a compact purple theme matching sway/waybar.

## OpenRC services

Alpine uses OpenRC. These services need to be in the `default` runlevel so they come up on every boot (`setup-desktop sway` may already enable some of them):

```sh
for svc in dbus elogind polkit seatd udisks2 networkmanager greetd; do doas rc-update add "$svc" default; done
```

Start them right now without rebooting:

```sh
for svc in dbus elogind polkit seatd udisks2 networkmanager greetd; do doas rc-service "$svc" start; done
```

Your user must be in the `seat` group for seatd to allow the session:

```sh
doas adduser "$USER" seat
```

Verify with:

```sh
rc-update show default
rc-status
```

Optional system config files included in this repo:

```sh
doas cp ./etc/doas.conf /etc/doas.conf
doas cp ./etc/NetworkManager/conf.d/backend.conf /etc/NetworkManager/conf.d/
```

> `etc/elogind/logind.conf.d/10-elogind.conf` and `etc/elogind/sleep.conf.d/10-elogind.conf` are reference copies of elogind's commented defaults. They are kept here for documentation; normally you do **not** need to overwrite the system files with them.
>
> If you do not use NetworkManager and need Wi-Fi directly, also enable `wpa_supplicant`: `doas rc-update add wpa_supplicant default`.

Finally, reload sway (`$mod+Shift+c`) or log out and back in. Check the config with:

```sh
sway -C -c ~/.config/sway/config
```

## Keybindings (quick reference)

`$mod` is the Super/Windows key. Full list is in `config.d/binds.sway`.

| Keys | Action |
|---|---|
| `$mod+Return` / `$mod+d` | Terminal (foot) / app launcher (fuzzel) |
| `$mod+c` | Clipboard history |
| `$mod+n` / `$mod+Shift+n` | Dismiss notification / clear all |
| `$mod+x` | Power menu |
| `$mod+m` | Toggle microphone mute |
| `$mod+i` | System info panel |
| `$mod+1` … `$mod+0` | Workspace 1 … 10; add Shift to move a window there |
| `$mod+b/v/s/w/e/f` | Layout: horizontal / vertical / stacked / tabbed / toggle / fullscreen |
| `$mod+r` | Resize mode (arrows or h/j/k/l, Enter/Esc to leave) |
| `$mod+minus` / `$mod+Shift+minus` | Show scratchpad / move window to scratchpad |
| `$mod+Alt+L` / `$mod+Shift+S` | Lock / suspend (media is paused first) |
| `$mod+Shift+c` / `$mod+Shift+e` | Reload sway / exit sway |
| `Print` / `Shift+Print` | Screenshot anything / full screen |
| `Ctrl+Print` / `Ctrl+Shift+Print` | Screenshot active window / selected area |
| `$mod+Shift+r` / `$mod+Shift+Ctrl+r` | Record full screen / selected area |
| `$mod+Shift+BackSpace` | Stop recording and save |
| Four-finger swipe left/right | Next / previous workspace |

Screenshots go to `~/Pictures/Screenshots/`, recordings to `~/Videos/Screenrecord/`; both directories are created on demand.

## Troubleshooting

- **No audio / `pw-dump` says "Host is down"**: check `/run/user/1000/pipewire-0` and `pulse/native`. `startup.sh` cleans stale audio processes and waits for both sockets; re-login to rerun it.
- **Waybar frozen after suspend**: `~/.config/sway/scripts/restart_waybar.sh` is called after `loginctl suspend` returns. You can run it manually too.
- **Layout letter stuck on H**: it reads the focused container's parent layout from `swaymsg -t get_workspaces/get_tree`; run `~/.config/waybar/scripts/layout_indicator.sh` to see the value directly.
- **`sh: out of range` from privacy indicator**: means `pw-dump` returned nothing; values are now defaulted to 0, so this should not recur.
- **Config syntax check**: `sway -C -c ~/.config/sway/config`; after editing, `$mod+Shift+c` reloads bindings.

## Updating

```sh
cd alpine-sway-dotfiles
git pull
# re-run the "Copy configs" block above, then:
swaymsg reload
```

Re-login if startup services or the greeter config changed.
