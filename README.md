# Dotfiles

Personal dotfiles for Debian 13 + GNOME + Wayland.

## Quick Start

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
bash install.sh
```

## What's Included

| File | Purpose |
|------|---------|
| `.zshrc` | Zsh config (oh-my-zsh, agnoster theme, plugins, tool paths) |
| `install_zsh.sh` | Installs oh-my-zsh + plugins, symlinks `.zshrc` |
| `backup_gnome.sh` | Backs up GNOME extensions + desktop settings via dconf |
| `restore_gnome.sh` | Restores GNOME config (supports `--dry-run`) |
| `install.sh` | Runs full setup (zsh + optional GNOME restore) |

## Usage

### Backup current GNOME settings

```bash
bash backup_gnome.sh
```

### Restore GNOME settings

```bash
# Preview what would change
bash restore_gnome.sh --dry-run

# Apply
bash restore_gnome.sh
```

A safety backup of your current settings is automatically created before restoring.

### Zsh only

```bash
bash install_zsh.sh
```

## Dependencies

- `zsh`, `git`, `curl` — for shell setup
- `dconf`, `gsettings` — for GNOME backup/restore
- [`gnome-shell-extension-installer`](https://github.com/brunelli/gnome-shell-extension-installer) — for restoring extensions
