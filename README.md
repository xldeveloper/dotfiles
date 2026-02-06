# dotfiles

Configuration shell, git, SSH et outils partagée entre machines et OS.

## Principe

Un seul `.bashrc` sert de **loader** et charge des fichiers additionnels en cascade :

```
.bashrc              commun (toujours chargé)
  └── .bashrc.{os}       linux | darwin | win
        └── .bashrc.wsl      si WSL détecté
  └── .bashrc.{hostname}     par nom de machine
  └── .bashrc.local          overrides locaux (jamais versionné)
```

Chaque couche peut surcharger la précédente. Les fichiers absents sont ignorés silencieusement.

## Structure

```
dotfiles/
├── bash/
│   ├── .bashrc                 # loader + config commune
│   ├── .bashrc.linux           # dircolors, bash-completion
│   ├── .bashrc.darwin          # homebrew, clicolor
│   ├── .bashrc.win             # ssh-agent (Git Bash Windows)
│   ├── .bashrc.wsl             # PATH, NVM
│   └── .bashrc.local.example   # template pour config locale
├── git/
│   └── .gitconfig              # aliases, options de base
├── ssh/
│   └── config                  # template hosts SSH
├── claude/
│   └── statusline.py           # status line Claude Code CLI
├── codex/
│   └── config.toml             # config OpenAI Codex CLI
├── gemini/
│   ├── settings.json           # config Google Gemini CLI
│   └── GEMINI.md               # instructions globales Gemini
├── install.sh                  # installateur (symlinks)
└── .gitignore
```

## Installation

```bash
git clone git@github.com:xldeveloper/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
source ~/.bashrc
```

Le script `install.sh` :
- Crée des **symlinks** de `~/` vers ce repo
- Fait un **backup** automatique (`.bak`) des fichiers existants avant de les remplacer
- Ne touche pas aux clés SSH ni aux credentials

## Ajout d'une nouvelle machine

1. Cloner le repo
2. Lancer `./install.sh`
3. Copier `bash/.bashrc.local.example` vers `~/.bashrc.local` et adapter (proxy, paths custom, etc.)
4. Optionnel : créer un `bash/.bashrc.{hostname}` pour la config spécifique à cette machine

## Fichiers sensibles

Les fichiers suivants ne sont **jamais versionnés** (voir `.gitignore`) :
- `~/.bashrc.local` (overrides locaux)
- Clés SSH (`ssh/id_*`, `ssh/*.pub`)
- Credentials Claude, Codex, Gemini
- `known_hosts`

## AI CLI tools

| Outil | Config dir | Instructions file | Config versionnée |
|---|---|---|---|
| Claude Code | `~/.claude/` | `CLAUDE.md` (par projet) | `statusline.py` |
| OpenAI Codex | `~/.codex/` | `AGENTS.md` (par projet) | `config.toml` |
| Google Gemini | `~/.gemini/` | `GEMINI.md` (global + par projet) | `settings.json`, `GEMINI.md` |

## Environnements supportés

| OS | Fichier | Testé |
|---|---|---|
| Linux (natif) | `.bashrc.linux` | - |
| macOS | `.bashrc.darwin` | - |
| Windows (Git Bash) | `.bashrc.win` | - |
| WSL | `.bashrc.linux` + `.bashrc.wsl` | oui |
