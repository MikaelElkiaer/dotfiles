help:		## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

switch:		## Apply current home-manager configuration
	home-manager switch

bootstrap:	## Bootstrap Nix home-manager
	home-manager --file $$PWD/.config/home-manager/home.nix switch
