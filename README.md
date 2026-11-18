# dotfiles

My MacBook setup as one Nix flake: [nix-darwin](https://github.com/nix-darwin/nix-darwin) for the system and
[home-manager](https://github.com/nix-community/home-manager) for everything in my home directory. One command
rebuilds the whole machine.

The NixOS desktop config I used before lives in the [`archive/nixos`](https://github.com/PavelHolman/dotfiles/tree/archive/nixos) branch.

## What's in it

| File | What it sets up |
| --- | --- |
| [`flake.nix`](flake.nix) | Inputs (nixpkgs 26.05 + unstable, nix-darwin, home-manager, catppuccin) and the system: Touch ID for `sudo`, Caps Lock → Escape, key repeat, Finder and screenshot defaults |
| [`home.nix`](home.nix) | The home-manager entry point that imports the modules below |
| [`home/terminal.nix`](home/terminal.nix) | Ghostty, zsh (oh-my-zsh, autosuggestions, syntax highlighting), Starship, zellij, Helix, fzf, zoxide, eza, ripgrep, bat, yazi, btop, direnv, and a few aliases (`cat`→bat, `grep`→rg, `rm`→trash) |
| [`home/git.nix`](home/git.nix) | Git with signed commits, delta, lazygit, gitui, and a different commit email per folder (`~/deels`, `~/poqet`, `~/merica`, `~/dev/fit`, …) |
| [`home/dev.nix`](home/dev.nix) | VS Code, rustup, Poetry, devenv |
| [`home/fonts.nix`](home/fonts.nix) | JetBrains Mono (Nerd Font) as the default monospace font |
| [`home/macos.nix`](home/macos.nix) | Menu-bar apps: Hidden Bar, Stats, SketchyBar |
| [`home/theme.nix`](home/theme.nix) | [Catppuccin](https://github.com/catppuccin/nix) everywhere (Mocha, mauve accent) |
| [`home/theme-sync.nix`](home/theme-sync.nix) | Makes the terminal tools follow macOS Light/Dark mode (below) |

## Light/Dark theme sync

The Catppuccin module bakes in a single flavor, so `theme-sync.nix` adds the light (Latte) variant of each tool's theme
next to the dark (Mocha) one, and a small zsh layer picks the right one for the current macOS appearance:

1. **bat** detects the terminal background by itself.
2. **Starship, delta and eza** switch through environment variables, checked on every prompt or invocation.
3. **btop, gitui, zellij, Helix, yazi and lazygit** read their theme once at startup, so a zsh wrapper passes the right
   theme file when you launch them.

Ghostty follows the system appearance natively. Tools started by GUI apps (for example VS Code's git integration) keep
the dark theme, because the switching happens in the interactive shell.

## Use

```sh
# first time: install Nix, then
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles

# afterwards
sudo darwin-rebuild switch --flake ~/dotfiles
```

The configuration is named `PJ-MacBook-Pro` and the user `pavelholman`; change both in `flake.nix` before using it on
another machine.
