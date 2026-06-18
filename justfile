set shell := ["bash", "-c"]

system_os := `uname`
hostname := `hostname -s`
user := `whoami`
is_nixos := `if [ -f /etc/NIXOS ]; then echo "true"; else echo "false"; fi`

flake_target := if system_os == "Darwin" {
    ".#" + hostname
} else {
    if is_nixos == "true" {
        ".#" + hostname
    } else {
        ".#" + user + "@" + hostname
    }
}

switch_cmd := if system_os == "Darwin" {
    "sudo darwin-rebuild switch --flake " + flake_target
} else {
    if is_nixos == "true" {
        "sudo nixos-rebuild switch --flake " + flake_target
    } else {
        "home-manager switch --flake " + flake_target
    }
}

build_cmd := if system_os == "Darwin" {
    "darwin-rebuild build --flake " + flake_target
} else {
    if is_nixos == "true" {
        "nixos-rebuild build --flake " + flake_target
    } else {
        "home-manager build --flake " + flake_target
    }
}

# Show help (default)
default:
    @just --list

# Log in to GitHub CLI
login-gh:
    gh auth login --hostname=github.com --git-protocol=https --scopes=notifications,read:packages,read:org,read:project

# Build configuration and commit changes with diff
build:
    #!/usr/bin/env bash
    set -Eeuo pipefail

    git add .
    if git diff --cached --exit-code &>/dev/null; then
        echo "[INF] No changes to commit"
        exit 0
    fi

    diff="$(nix-diff-summary)"

    git commit --template=<(echo "feat(nix): Update configuration"; echo; echo "$diff")

# Apply configuration
switch:
    @echo "[INF] Switching to new configuration for {{flake_target}}..."
    {{switch_cmd}}

# Update flake and custom packages, then build/diff/commit
update:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    trap 'rm -f ./result ./diff' EXIT
    
    echo "[INF] Updating custom packages..."
    ./home/nixos/bin/nix-package-update .
    
    echo "[INF] Updating root flake..."
    nix flake update
    
    echo "[INF] Building and checking for changes..."
    {{build_cmd}}
    
    nix-diff-summary > ./diff
    
    if ! [ -s ./diff ]; then
        echo "[INF] No updates found"
        exit 0
    fi
    
    echo "[INF] Updates found:"
    cat ./diff
    
    git add flake.lock home/nixos/.config/home-manager/packages/
    
    if git diff --cached --exit-code &>/dev/null; then
        echo "[INF] No changes to commit"
        exit 0
    fi
    
    LATEST_MSG="$(git show --format=format:%s --quiet)"
    if [ "$LATEST_MSG" = "chore(nix): Update flake" ] && ! git log --exit-code origin/main..main &>/dev/null; then
        echo "[INF] Amending unpushed update commit..."
        git commit --amend --file=<(echo "chore(nix): Update flake"; echo; cat ./diff)
    else
        echo "[INF] Creating new update commit..."
        git commit --file=<(echo "chore(nix): Update flake"; echo; cat ./diff)
    fi

# Compatibility/Legacy targets
alias darwin-switch := switch
alias hm-switch := switch
alias hm-update := update
alias hm-build := build
alias nix-switch := switch
alias nix-update := update



