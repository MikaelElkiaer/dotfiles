help:		## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

gh-login:	## Log in to GitHub CLI
	gh auth login --hostname=github.com --git-protocol=https --scopes=read:packages,read:org

hm-bootstrap:	## Bootstrap home-manager
	nix run home-manager/release-24.05 -- switch -b bak --flake $$PWD/Repositories/GitHub/dotfiles/home/nixos/.config/home-manager/

hm-switch:	## Apply current home-manager configuration
	home-manager switch

nix-bootstrap:>		## Bootstrap NixOS
	sudo cp $$PWD/etc/nixos/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch
	home-manager switch -b bak --flake $$PWD/Repositories/GitHub/dotfiles/home/nixos/.config/home-manager/

nix-switch:	## Apply current NixOS configuration
	@sudo cp etc/nixos/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch
