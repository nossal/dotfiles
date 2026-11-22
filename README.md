# dotfiles
![license](https://img.shields.io/github/license/nossal/dotfiles.svg)
![release](https://img.shields.io/github/release/nossal/dotfiles.svg)

:warning: Work in progress :construction:

<!-- ## Features -->

## Requirements
- bash, git and curl
- zsh (bash is used when zsh is not installed)
- gpg, only for the encrypted files in the `ai` module

<!--
## Install
1. Just execute the following code into your zsh session:
```bash
eval "$(curl -sL noss.al/dot)"
```
2. Restart your zsh session.
3. Done.
-->
## Install
Clone the repository and bootstrap the machine with a profile:

```bash
git clone https://github.com/nossal/dotfiles ~/.dotfiles
~/.dotfiles/bin/dot desktop-pessoal
```

The profile is saved to `~/.config/dot/profile`, outside the repository. A
machine without a profile only receives the `base` module.

## Profiles
A profile is a list of modules, defined in `profiles.toml`:

| Profile | Modules |
|---|---|
| `completo` | `system base dev langs ops desktop personal ai work` |
| `desktop-pessoal` | `system base dev langs ops desktop personal ai` |
| `desktop-trabalho` | `system base dev langs ops desktop work` |
| `servidor-pessoal` | `system base server` |
| `servidor-trabalho` | `base server work` |

The operating system is detected separately, so the same profile works on
Fedora and macOS.

## Modules
| Module | Purpose |
|---|---|
| `system` | OS packages and shell setup, requires `sudo` |
| `base` | Shell tools, git, tmux, ssh, starship and mise |
| `dev` | Neovim, lazygit, jj, gpg and development CLIs |
| `langs` | Language runtimes |
| `ops` | Kubernetes and container security tools |
| `desktop` | WezTerm and fonts |
| `personal` | Personal tools such as gopass and rclone |
| `ai` | AI tools, their settings and encrypted credentials |
| `server` | Git overrides for machines without a signing key |
| `work` | Marks machines that use the separate `~/.dotfiles-work` repository |

Each module can define:

- links in a `links.toml` section with the module's name
- mise tools in `mise/tools/<module>.toml`, linked through `links.toml`
- setup scripts in the `[setup]` section of `profiles.toml`

## Usage
```bash
dot                  # Bootstrap with the saved profile
dot <profile>        # Save the profile and bootstrap
dot init <profile>   # Change the profile and sync links only
dot status           # Show the profile, modules and link state
dot profiles         # List available profiles
dot links [profile]  # Create links for the current or given profile
dot tools            # Run setup scripts of the active modules
dot prune            # Uninstall mise tools no longer in the profile
dot update           # Pull and reinstall using the saved profile
dot fix              # Remove broken symbolic links
```

Changing profile removes links from modules that left the profile, but only
when they point to `~/.dotfiles`. Tools stay installed until `dot prune`.

Existing regular files are never overwritten. Decrypted credentials are stored
as git-ignored `.dec` files and are not replaced once created. To decrypt one
again, delete its `.dec` file and run `dot links`.

## License
Copyright (C) 2022 Rodrigo Nossal.

Distributed under an MIT-style license (see LICENSE for details).
