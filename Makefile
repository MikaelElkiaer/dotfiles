help:		## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

gh-login:	## Log in to GitHub CLI
	gh auth login --hostname=github.com --git-protocol=https --scopes=read:packages,read:org

hm-bootstrap:	## Bootstrap home-manager
	home-manager --file $$PWD/home/nixos/.config/home-manager/home.nix switch

hm-switch:	## Apply current home-manager configuration
	home-manager switch

nix-switch:	## Apply current NixOS configuration
	@sudo cp etc/nixos/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch
