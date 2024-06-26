help:		## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

bootstrap:	## Bootstrap Nix home-manager
	@make rebuild
	home-manager --file $$PWD/home/nixos/.config/home-manager/home.nix switch

gh-login:	## Log in to GitHub CLI
	gh auth login --hostname=github.com --git-protocol=https --scopes=read:packages,read:org

rebuild:	## Apply current NixOS configuration
	@sudo cp etc/nixos/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch

switch:		## Apply current home-manager configuration
	home-manager switch
