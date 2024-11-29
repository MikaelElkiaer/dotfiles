help:			## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

login-gh:		## Log in to GitHub CLI
	gh auth login --hostname=github.com --git-protocol=https --scopes=read:packages,read:org,read:project

login-ghcr:		## Log in to ghcr container registry
	gh auth token | docker login ghcr.io --username username --password-stdin

# INFO: This is currently needed for skopeo
# - to properly use login credentials
docker-credhelper:	## Set credential helper
	mkdir --parents ~/.docker/
	touch ~/.docker/config.json
	yq --inplace '.auths as $$auths | .credHelpers = ($$auths | to_entries | map(.value="secretservice") | from_entries)' ~/.docker/config.json

hm-switch:		## Apply home-manager config
	home-manager switch -b bak

hm-update:		## Update home-manager flake
	@(\
		set -e;\
		# Clean up
		trap 'rm --force ./result ./diff' EXIT;\
		# Update flake
		nix flake update --flake $$PWD/home/nixos/.config/home-manager/;\
		# Create new revision based on current flake
		home-manager build;\
		# Compare new revision with currently applied
		nix store diff-closures $$HOME/.local/state/nix/profiles/home-manager ./result > ./diff;\
		# Determine whether latest commit is a hm-update, and whether it is unpushed
		if [ "$$(git show --format=format:%s --quiet)" = "chore(hm): Update flake" ] && ! git log --exit-code origin/main..main &>/dev/null; then\
		  UNPUSHED="";\
		fi;\
		git add home/nixos/.config/home-manager/flake.nix;\
		# Determine if there are changes
		git diff --cached --exit-code &>/dev/null && exit 0;\
		# Create commit - if latest commit is unpushed, then amend the changes
		git commit --file=<(echo "chore(hm): Update flake"; echo; cat ./diff) $${UNPUSHED+ --amend};\
	)

nix-switch:		## Apply current NixOS configuration
	@sudo cp etc/nixos/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch

nix-update:		## Update nix packages
	nix-channel --update
