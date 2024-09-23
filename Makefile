help:			## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

login-gh:		## Log in to GitHub CLI
	gh auth login --hostname=github.com --git-protocol=https --scopes=read:packages,read:org,read:project

login-ghcr:		## Log in to ghcr container registry
	gh auth token | docker login ghcr.io --username username --password-stdin

switch-nix:		## Apply current NixOS configuration
	@sudo cp etc/nixos/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch

update-hm:	## Update home-manager flake
	nix flake update --flake $$PWD/home/nixos/.config/home-manager/
	home-manager build
	DIFF="$$(nix store diff-closures $$HOME/.local/state/nix/profiles/home-manager ./result)"
	rm ./result
	home-manager switch
	git add home/nixos/.config/home-manager/
	git commit --file=<(echo "hm: Update flake"; echo "$$DIFF")
