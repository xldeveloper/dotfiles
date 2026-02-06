#!/bin/bash
# Dotfiles installer - creates symlinks from home directory to this repo
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link_file() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "  backup: $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -sf "$src" "$dest"
    echo "  link: $dest -> $src"
}

echo "Installing dotfiles from $DOTFILES_DIR"
echo ""

# --- Bash ---
echo "[bash]"
link_file "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"

for f in "$DOTFILES_DIR"/bash/.bashrc.*; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    # Skip the .local.example template
    [ "$name" = ".bashrc.local.example" ] && continue
    link_file "$f" "$HOME/$name"
done

# --- Git ---
echo "[git]"
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# --- SSH ---
echo "[ssh]"
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
link_file "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"

# --- Claude ---
echo "[claude]"
mkdir -p "$HOME/.claude"
link_file "$DOTFILES_DIR/claude/statusline.py" "$HOME/.claude/statusline.py"

# --- Codex ---
echo "[codex]"
mkdir -p "$HOME/.codex"
link_file "$DOTFILES_DIR/codex/config.toml" "$HOME/.codex/config.toml"

# --- Gemini ---
echo "[gemini]"
mkdir -p "$HOME/.gemini"
link_file "$DOTFILES_DIR/gemini/settings.json" "$HOME/.gemini/settings.json"
link_file "$DOTFILES_DIR/gemini/GEMINI.md" "$HOME/.gemini/GEMINI.md"

echo ""
echo "Done. Run 'source ~/.bashrc' to reload."
echo ""
echo "Note: Copy bash/.bashrc.local.example to ~/.bashrc.local for machine-specific config."
