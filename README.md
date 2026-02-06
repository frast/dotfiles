# Dotfiles (GNU Stow)

This repository is organized into Stow packages.

## Packages

- `bash` -> `~/.bashrc`, `~/.bash_aliases`, `~/.bashrc.d/`
- `bin` -> `~/.local/bin/` (includes `vsc`, `edgec`, and other scripts)
- `git` -> `~/.gitconfig`
- `env` -> `~/.config/environment.d/`
- `sway` -> `~/.config/sway/`
- `foot` -> `~/.config/foot/`
- `nvim` -> `~/.config/nvim/`
- `tmux` -> `~/.tmux.conf`
- `zsh` -> zsh config files
- `x11` -> `~/.XCompose`
- `apps` -> `~/.local/share/applications/` desktop overrides
- `mako` -> `~/.config/mako/config`
- `wofi` -> `~/.config/wofi/style.css`
- `i3status` -> `~/.config/i3status/config`
- `gtk` -> `~/.config/gtk-3.0/settings.ini`
- `display` -> `~/.config/monitors.xml`

## Common Commands

Stow all main packages:

```bash
cd ~/dotfiles
stow -t ~ bash bin git env sway foot nvim tmux zsh x11 apps mako wofi i3status gtk display
```

Stow only one package:

```bash
cd ~/dotfiles
stow -t ~ x11
```

Unstow one package:

```bash
cd ~/dotfiles
stow -D -t ~ x11
```

Restow (relink) one package:

```bash
cd ~/dotfiles
stow -R -t ~ apps
```

## Notes

- `vsc` and `edgec` wrappers in `bin/.local/bin/` enforce the input/compose environment and launch with `--ozone-platform=x11`.
- Desktop launchers are overridden in `apps/.local/share/applications/` to call these wrappers.
