help:			## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

login-gh:		## Log in to GitHub CLI
	gh auth login --hostname=github.com --git-protocol=https --scopes=read:packages,read:org,read:project

login-ghcr:		## Log in to ghcr container registry
	gh auth token | docker login ghcr.io --username username --password-stdin

docker-credhelper:	## Set credential helper
	mkdir --parents ~/.docker/
	touch ~/.docker/config.json
	yq --inplace '.auths as $auths | .credHelpers = ($auths | to_entries | map(.value="secretservice") | from_entries)' ~/.docker/config.json

hm-switch:		## Apply home-manager config
	home-manager switch -b bak

hm-update:		## Update home-manager flake
	@(\
		set -e;\
		trap 'rm --force ./result ./diff' EXIT;\
		nix flake update --flake $$PWD/home/nixos/.config/home-manager/;\
		home-manager build;\
		nix store diff-closures $$HOME/.local/state/nix/profiles/home-manager ./result > ./diff;\
		if [ "$$(git show --format=format:%s --quiet)" = "chore(hm): Update flake" ] && ! git log --exit-code origin/main..main &>/dev/null; then\
		  UNPUSHED="";\
		fi;\
		git add home/nixos/.config/home-manager/;\
		git diff --cached --exit-code &>/dev/null && exit 0;\
		git commit --file=<(echo "chore(hm): Update flake"; echo; cat ./diff) $${UNPUSHED+ --amend};\
	)

nix-switch:		## Apply current NixOS configuration
	@sudo cp etc/nixos/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch

nix-update:		## Update nix packages
	nix-channel --update
