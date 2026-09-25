# dotfiles

Personal configuration, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Every top-level directory is a **stow package** whose contents mirror the layout
under `$HOME`. So `tmux/.tmux.conf` is linked to `~/.tmux.conf`, and
`herdr/.config/herdr/config.toml` to `~/.config/herdr/config.toml`. Because the
stow directory's parent *is* the target, `stow <pkg>` needs no `-t` flag.

| Package   | Links into                                                        |
| --------- | ----------------------------------------------------------------- |
| `tmux`    | `~/.tmux.conf`                                                    |
| `herdr`   | `~/.config/herdr/{config.toml,status.sh,split-from-root.sh}`       |
| `zsh`     | `~/.zshrc`, `~/.zprofile`                                         |
| `ghostty` | `~/.config/ghostty/{config,themes}`                               |
| `git`     | `~/.gitconfig`, `~/.config/git/ignore`                            |
| `zed`     | `~/.config/zed/settings.json`                                     |
| `nvim`    | `~/.config/nvim` — a submodule of `madhav1233/nvim_new`           |

## Fresh machine

```sh
# 1. The submodule matters — a plain clone leaves nvim/ empty.
git clone --recurse-submodules git@github.com:madhav1233/dotfiles.git ~/dotfiles

# 2. Prerequisites the configs expect to already exist.
brew install stow fzf herdr
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 3. Link everything.
cd ~/dotfiles && stow tmux herdr zsh ghostty git zed nvim

# 4. Install tmux plugins: start tmux, then press prefix + I (C-s I).
```

If oh-my-zsh's installer created its own `~/.zshrc` first, stow will refuse to
overwrite it. Delete that file and re-run `stow zsh`, or use `stow --adopt zsh`
to pull the existing file into the package.

Neovim bootstraps lazy.nvim on first launch; no manual plugin step needed.

## Day to day

```sh
cd ~/dotfiles
stow <pkg>            # link a package
stow -D <pkg>         # unlink
stow -R <pkg>         # relink, e.g. after adding a file to a package
stow -n -v <pkg>      # dry run, showing what would change
stow --adopt <pkg>    # move an existing real file in $HOME into the package
```

Edits go to the files in this repo — the `$HOME` paths are symlinks, so editing
either side is editing the same file. Commit as usual.

### Adding a new package

Recreate the path the file has relative to `$HOME`:

```sh
mkdir -p ~/dotfiles/foo/.config/foo
mv ~/.config/foo/config.yml ~/dotfiles/foo/.config/foo/
cd ~/dotfiles && stow foo
```

### Updating nvim

`nvim/.config/nvim` is a submodule, so it has its own history and remote:

```sh
cd ~/.config/nvim && git add -A && git commit && git push   # commit in nvim_new
cd ~/dotfiles && git add nvim/.config/nvim && git commit    # move the pointer
git submodule update --remote nvim/.config/nvim             # pull it elsewhere
```

## Not in this repo, on purpose

- `~/.config/gh` and `~/.config/github-copilot` — OAuth tokens.
- herdr's runtime state (`*.sock`, `herdr-server.log`, `session.json`) lives
  beside the stowed `config.toml`; only the config and its two helper scripts
  are tracked.
- Zed's `conversations/` and `prompts/` — local data, not configuration.
- `~/.tmux/plugins/*` and `~/.oh-my-zsh` — third-party checkouts, installed by
  their own tooling (see above).

## Notes

- `herdr/.config/herdr/config.toml` mirrors `.tmux.conf`: same `ctrl+s` prefix,
  same `hjkl` pane navigation and `HJKL` resizing, tmux's `"` / `%` splits, with
  the agent panel on separate `alt`-prefixed bindings.
- `status.sh` renders herdr's tab-bar right side (pane directory · workspace),
  standing in for the catppuccin tmux status modules. `split-from-root.sh` backs
  the `prefix+alt+"` / `prefix+alt+%` splits that open at the workspace root.
