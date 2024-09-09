help:			## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

login-gh:		## Log in to GitHub CLI
	gh auth login --hostname=github.com --git-protocol=https --scopes=read:packages,read:org,read:project

login-ghcr:		## Log in to ghcr container registry
	gh auth token | docker login ghcr.io --username username --password-stdin

build-hm:		## Build current home-manager configuration
	home-manager build --no-out-link

diff-hm:		## See diff between home-manager generations
	nix profile diff-closures --profile ~/.local/state/nix/profiles/home-manager

switch-hm:		## Apply current home-manager configuration
	home-manager switch

switch-nix:		## Apply current NixOS configuration
	@sudo cp etc/nixos/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch

update-flake-hm:	## Update home-manager flake
	nix flake update --flake $$PWD/home/nixos/.config/home-manager/
