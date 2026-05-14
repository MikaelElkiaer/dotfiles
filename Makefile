.ONESHELL:
.PHONY: help build update switch

# Detect host information
OS := $(shell uname)
HOSTNAME := $(shell hostname -s)
USER := $(shell whoami)

# Set targets and commands based on OS
ifeq ($(OS), Darwin)
    # On Darwin, we use nix-darwin which manages the whole system including Home Manager
    FLAKE_TARGET := .#$(HOSTNAME)
    SWITCH_CMD := sudo darwin-rebuild switch --flake $(FLAKE_TARGET)
    BUILD_CMD := darwin-rebuild build --flake $(FLAKE_TARGET)
    CURRENT_PROFILE := /run/current-system
else
    # On Linux, we currently manage Home Manager via flake
    FLAKE_TARGET := .#$(USER)@$(HOSTNAME)
    SWITCH_CMD := home-manager switch --flake $(FLAKE_TARGET)
    BUILD_CMD := home-manager build --flake $(FLAKE_TARGET)
    CURRENT_PROFILE := $(HOME)/.local/state/nix/profiles/home-manager
endif

help:			## Show this help
	@
	echo "# Help"
	sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

login-gh:		## Log in to GitHub CLI
	@
	gh auth login --hostname=github.com --git-protocol=https --scopes=notifications,read:packages,read:org,read:project

build:			## Build configuration and commit changes with diff
	@
	set -e
	trap 'rm -f ./result ./diff' EXIT
	echo "[INF] Building configuration for $(FLAKE_TARGET)..."
	$(BUILD_CMD)
	echo "[INF] Comparing with current profile..."
	nix store diff-closures $(CURRENT_PROFILE) ./result | \
		sed -E -e '/[ε∅] → [ε∅]/d' -e '/^source:/d' > ./diff
	
	if [ -s ./diff ]; then
		echo "[INF] Changes found:"
		cat ./diff
	else
		echo "[INF] No changes found."
		exit 0
	fi
	
	git add .
	if git diff --cached --exit-code &>/dev/null; then
		echo "[INF] No changes to commit"
		exit 0
	fi
	
	git commit --file=<(echo "feat(nix): Update configuration"; echo; cat ./diff)

switch:			## Apply configuration
	@
	echo "[INF] Switching to new configuration for $(FLAKE_TARGET)..."
	$(SWITCH_CMD)

update:			## Update flake and custom packages, then build/diff/commit
	@
	set -Eeuo pipefail
	trap 'rm -f ./result ./diff' EXIT
	
	echo "[INF] Updating custom packages..."
	# Run package update script from the repo
	./home/nixos/bin/nix-package-update .
	
	echo "[INF] Updating root flake..."
	nix flake update
	
	echo "[INF] Building and checking for changes..."
	$(BUILD_CMD)
	
	nix store diff-closures $(CURRENT_PROFILE) ./result | \
		sed -E -e '/[ε∅] → [ε∅]/d' -e '/^source:/d' > ./diff
	
	if ! [ -s ./diff ]; then
		echo "[INF] No updates found"
		exit 0
	fi
	
	echo "[INF] Updates found:"
	cat ./diff
	
	git add flake.lock home/nixos/.config/home-manager/packages/
	
	# Determine if there are staged changes
	if git diff --cached --exit-code &>/dev/null; then
		echo "[INF] No changes to commit"
		exit 0
	fi
	
	# Create or amend commit
	LATEST_MSG="$$(git show --format=format:%s --quiet)"
	if [ "$$LATEST_MSG" = "chore(nix): Update flake" ] && ! git log --exit-code origin/main..main &>/dev/null; then
		echo "[INF] Amending unpushed update commit..."
		git commit --amend --file=<(echo "chore(nix): Update flake"; echo; cat ./diff)
	else
		echo "[INF] Creating new update commit..."
		git commit --file=<(echo "chore(nix): Update flake"; echo; cat ./diff)
	fi

# Compatibility/Legacy targets
darwin-switch: switch
hm-switch: switch
hm-update: update
hm-build: build

nix-switch:		## Apply current NixOS configuration (non-flake)
	@
	sudo cp etc/nixos/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch

nix-update:		## Update nix packages (channels)
	@
	nix-channel --update

