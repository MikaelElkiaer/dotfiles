help:			## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

login-gh:		## Log in to GitHub CLI
	gh auth login --hostname=github.com --git-protocol=https --scopes=notifications,read:packages,read:org,read:project

hm-build:		## Build home-manager config
	@(\
		set -e;\
		# Clean up\
		trap 'rm --force ./result ./diff' EXIT;\
		# Build new revision\
		home-manager build;\
		# Compare new revision with current\
		nix store diff-closures $$HOME/.local/state/nix/profiles/home-manager ./result > ./diff;\
		# Add all changes to git\
		git add home/nixos/.config/home-manager/;\
		# Determine if there are changes\
		git diff --cached --exit-code &>/dev/null && exit 0;\
		# Create commit, with diff as message body\
		git commit --template=<(echo; echo; cat ./diff);\
	)

hm-switch:		## Apply home-manager config
	home-manager switch -b bak

hm-update:		## Update home-manager flake
	@(\
		set -e;\
		# Clean up\
		trap 'rm --force ./result ./diff' EXIT;\
		# Update flake\
		nix flake update --flake $$PWD/home/nixos/.config/home-manager/;\
		# Create new revision based on current flake\
		home-manager build;\
		# Compare new revision with currently applied - remove hash change\
		nix store diff-closures $$HOME/.local/state/nix/profiles/home-manager ./result | sed -E '/[ε∅] → [ε∅]/d' > ./diff;\
		# Determine if there are updates\
		if [ -n ./diff ]; then\
			echo "[INF] No updates found" >&2;\
			git restore home/nixos/.config/home-manager/flake.lock;\
			exit 0;\
		fi;\
		# Determine whether latest commit is a hm-update, and whether it is unpushed\
		if [ "$$(git show --format=format:%s --quiet)" = "chore(hm): Update flake" ] && ! git log --exit-code origin/main..main &>/dev/null; then\
		  UNPUSHED="";\
		fi;\
		git add home/nixos/.config/home-manager/flake.lock;\
		# Determine if there are changes\
		git diff --cached --exit-code &>/dev/null && exit 0;\
		# Create commit - if latest commit is unpushed, then amend the changes\
		git commit --file=<(echo "chore(hm): Update flake"; echo; cat ./diff) $${UNPUSHED+ --amend};\
	)

nix-switch:		## Apply current NixOS configuration
	@sudo cp etc/nixos/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch

nix-update:		## Update nix packages
	nix-channel --update
