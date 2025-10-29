{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            # WARN: Desktop applications installed this way will not appear in Spotlight
            # - see https://github.com/nix-darwin/nix-darwin/issues/1576
            # - use `homebrew.casks` instead
          ];

          # Manage Homebrew
          # - needs to be installed manually
          # - e.g. `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
          homebrew = {
            enable = true;
            brews = [
              "lastpass-cli"
              "tinyproxy"
            ];
            casks = [
              "1password-cli"
              "alfred"
              "font-hack-nerd-font" # Needed for sketchybar
              "font-noto-sans-mono"
              "font-sketchybar-app-font" # Needed for sketchybar
              "kitty"
              "podman-desktop"
              "trex"
            ];
            # Delete undeclared brews and casks
            onActivation.cleanup = "zap";
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable finger print for sudo
          security.pam.services.sudo_local.enable = true;
          security.pam.services.sudo_local.reattach = true;
          security.pam.services.sudo_local.touchIdAuth = true;

          services.aerospace.enable = true;
          services.aerospace.settings = {
            # Place a copy of this config to ~/.aerospace.toml
            # After that, you can edit ~/.aerospace.toml to your liking

            # It's not necessary to copy all keys to your config.
            # If the key is missing in your config, "default-config.toml" will serve as a fallback

            # You can use it to add commands that run after login to macOS user session.
            # 'start-at-login' needs to be 'true' for 'after-login-command' to work
            # Available commands: https://nikitabobko.github.io/AeroSpace/commands
            after-login-command = [ ];

            # You can use it to add commands that run after AeroSpace startup.
            # 'after-startup-command' is run after 'after-login-command'
            # Available commands : https://nikitabobko.github.io/AeroSpace/commands
            after-startup-command = [ ];

            # Start AeroSpace at login
            start-at-login = false;

            # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
            enable-normalization-flatten-containers = true;
            enable-normalization-opposite-orientation-for-nested-containers = true;

            # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
            # The 'accordion-padding' specifies the size of accordion padding
            # You can set 0 to disable the padding feature
            accordion-padding = 25;

            # Possible values: tiles|accordion
            default-root-container-layout = "accordion";

            # Possible values: horizontal|vertical|auto
            # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
            #               tall monitor (anything higher than wide) gets vertical orientation
            default-root-container-orientation = "auto";

            on-focused-monitor-changed = [ ];
            on-focus-changed = [ "move-mouse window-lazy-center" ];

            # Possible values: (qwerty|dvorak)
            # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
            key-mapping.preset = "qwerty";

            # Gaps between windows (inner-*) and between monitor edges (outer-*).
            # Possible values:
            # - Constant:     gaps.outer.top = 8
            # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
            #                 In this example, 24 is a default value when there is no match.
            #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
            #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
            gaps = {
              inner.horizontal = 0;
              inner.vertical = 0;
              outer.left = 0;
              outer.bottom = 0;
              outer.top = [
                { monitor."built-in retina display" = 0; } # Even if "main" it should be 0 due to notch
                { monitor."main" = 25; } # Leave room for sketchybar
                0
              ];
              outer.right = 0;
            };

            workspace-to-monitor-force-assignment = {
              "1" = "built-in retina display";
              "2" = [
                "secondary"
                "built-in retina display"
              ];
            };

            # See https://nikitabobko.github.io/AeroSpace/guide#exec-env-vars
            exec = {
              # Again, you don't need to copy all config sections to your config.
              inherit-env-vars = true; # If you don't touch "exec" section,
              env-vars = {
                # it will fallback to "default-config.toml"
                PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:\${PATH}";
              };
            };

            on-window-detected = [
              {
                "if".app-id = "net.kovidgoyal.kitty";
                run = "move-node-to-workspace 2";
              }
              {
                "if".app-id = "com.google.Chrome";
                run = "move-node-to-workspace 2";
              }
              {
                "if".app-name-regex-substring = "Gmail|Google Calendar|Google Meet";
                run = "move-node-to-workspace 1";
              }
              {
                "if".app-id = "com.runningwithcrayons.Alfred-Preferences";
                run = "layout floating";
              }
            ];

            # 'main' binding mode declaration
            # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
            # 'main' binding mode must be always presented
            mode.main.binding = {

              # All possible keys:
              # - Letters.        a, b, c, ..., z
              # - Numbers.        0, 1, 2, ..., 9
              # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
              # - F-keys.         f1, f2, ..., f20
              # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
              #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
              # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
              #                   keypadMinus, keypadMultiply, keypadPlus
              # - Arrows.         left, down, up, right

              # All possible modifiers: cmd, alt, ctrl, shift

              # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

              # You can uncomment this line to open up terminal with alt + enter shortcut
              # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
              # alt-enter = 'exec-and-forget open -n /System/Applications/Utilities/Terminal.app'

              # See: https://nikitabobko.github.io/AeroSpace/commands#layout
              alt-shift-t = "layout tiles horizontal vertical";
              alt-shift-a = "layout accordion horizontal vertical";

              # See: https://nikitabobko.github.io/AeroSpace/commands#fullscreen
              alt-shift-f = "fullscreen";

              # See: https://nikitabobko.github.io/AeroSpace/commands#focus
              alt-shift-h = "focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors left";
              alt-shift-j = "focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors down";
              alt-shift-k = "focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors up";
              alt-shift-l = "focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors right";

              # See: https://nikitabobko.github.io/AeroSpace/commands#move
              alt-shift-ctrl-h = "move --boundaries all-monitors-outer-frame --boundaries-action stop left";
              alt-shift-ctrl-j = "move --boundaries all-monitors-outer-frame --boundaries-action stop down";
              alt-shift-ctrl-k = "move --boundaries all-monitors-outer-frame --boundaries-action stop up";
              alt-shift-ctrl-l = "move --boundaries all-monitors-outer-frame --boundaries-action stop right";

              # See: https://nikitabobko.github.io/AeroSpace/commands#resize
              # alt-shift-minus = "resize smart -50";
              # alt-shift-equal = "resize smart +50";

              # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
              # alt-1 = 'workspace 1'
              # alt-2 = 'workspace 2'
              # alt-3 = 'workspace 3'
              # alt-4 = 'workspace 4'
              # alt-5 = 'workspace 5'
              # alt-6 = 'workspace 6'
              # alt-7 = 'workspace 7'
              # alt-8 = 'workspace 8'
              # alt-9 = 'workspace 9'
              # alt-a = 'workspace A' # In your config, you can drop workspace bindings that you don't need
              # alt-b = 'workspace B'
              # alt-c = 'workspace C'
              # alt-d = 'workspace D'
              # alt-e = 'workspace E'
              # alt-f = 'workspace F'
              # alt-g = 'workspace G'
              # alt-i = 'workspace I'
              # alt-m = 'workspace M'
              # alt-n = 'workspace N'
              # alt-o = 'workspace O'
              # alt-p = 'workspace P'
              # alt-q = 'workspace Q'
              # alt-r = 'workspace R'
              # alt-s = 'workspace S'
              # alt-t = 'workspace T'
              # alt-u = 'workspace U'
              # alt-v = 'workspace V'
              # alt-w = 'workspace W'
              # alt-x = 'workspace X'
              # alt-y = 'workspace Y'
              # alt-z = 'workspace Z'

              # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
              # alt-shift-1 = 'move-node-to-workspace 1'
              # alt-shift-2 = 'move-node-to-workspace 2'
              # alt-shift-3 = 'move-node-to-workspace 3'
              # alt-shift-4 = 'move-node-to-workspace 4'
              # alt-shift-5 = 'move-node-to-workspace 5'
              # alt-shift-6 = 'move-node-to-workspace 6'
              # alt-shift-7 = 'move-node-to-workspace 7'
              # alt-shift-8 = 'move-node-to-workspace 8'
              # alt-shift-9 = 'move-node-to-workspace 9'
              # alt-shift-a = 'move-node-to-workspace A'
              # alt-shift-b = 'move-node-to-workspace B'
              # alt-shift-c = 'move-node-to-workspace C'
              # alt-shift-d = 'move-node-to-workspace D'
              # alt-shift-e = 'move-node-to-workspace E'
              # alt-shift-f = 'move-node-to-workspace F'
              # alt-shift-g = 'move-node-to-workspace G'
              # alt-shift-i = 'move-node-to-workspace I'
              # alt-shift-m = 'move-node-to-workspace M'
              # alt-shift-n = 'move-node-to-workspace N'
              # alt-shift-o = 'move-node-to-workspace O'
              # alt-shift-p = 'move-node-to-workspace P'
              # alt-shift-q = 'move-node-to-workspace Q'
              # alt-shift-r = 'move-node-to-workspace R'
              # alt-shift-s = 'move-node-to-workspace S'
              # alt-shift-t = 'move-node-to-workspace T'
              # alt-shift-u = 'move-node-to-workspace U'
              # alt-shift-v = 'move-node-to-workspace V'
              # alt-shift-w = 'move-node-to-workspace W'
              # alt-shift-x = 'move-node-to-workspace X'
              # alt-shift-y = 'move-node-to-workspace Y'
              # alt-shift-z = 'move-node-to-workspace Z'

              # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
              alt-shift-tab = "workspace-back-and-forth";
              # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
              alt-shift-ctrl-tab = "move-workspace-to-monitor --wrap-around next";

              # See: https://nikitabobko.github.io/AeroSpace/commands#mode
              alt-shift-space = "mode service";
            };

            # 'service' binding mode declaration.
            # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
            mode.service.binding = {
              esc = [
                "reload-config"
                "mode main"
              ];
              r = [
                "flatten-workspace-tree"
                "mode main"
              ]; # reset layout
              #s = ['layout sticky tiling', 'mode main'] # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
              f = [
                "layout floating tiling"
                "mode main"
              ]; # Toggle between floating and tiling layout
              # backspace = [
              #   "close-all-windows-but-current"
              #   "mode main"
              # ];

              alt-shift-h = [
                "join-with left"
                "mode main"
              ];
              alt-shift-j = [
                "join-with down"
                "mode main"
              ];
              alt-shift-k = [
                "join-with up"
                "mode main"
              ];
              alt-shift-l = [
                "join-with right"
                "mode main"
              ];
              j = [
                "resize smart -50"
                "mode main"
              ];
              k = [
                "resize smart +50"
                "mode main"
              ];
              ctrl-j = "resize smart -50";
              ctrl-k = "resize smart +50";
            };

            # Notify Sketchybar about workspace change
            exec-on-workspace-change = [
              "/bin/bash"
              "-c"
              "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE"
            ];
          };

          services.sketchybar.enable = true;
          services.sketchybar.config = ''
            # A simple sketchybar config for aerospace users to get started with
            # Not too different from the base starting config!

            # WARN: Default plugin dir does not work in nix-darwin
            # PLUGIN_DIR="''\$CONFIG_DIR/plugins"
            PLUGIN_DIR="~/.config/sketchybar/plugins"

            ##### Bar Appearance #####
            # Configuring the general appearance of the bar.
            # These are only some of the options available. For all options see:
            # https://felixkratz.github.io/SketchyBar/config/bar
            # If you are looking for other colors, see the color picker:
            # https://felixkratz.github.io/SketchyBar/config/tricks#color-picker

            sketchybar --bar position=top display=main height=25 blur_radius=30 color=0x40000000

            ##### Changing Defaults #####
            # We now change some default values, which are applied to all further items.
            # For a full list of all available item properties see:
            # https://felixkratz.github.io/SketchyBar/config/items

            default=(
              padding_left=5
              padding_right=5
              icon.font="Hack Nerd Font:Bold:13.0"
              label.font="Noto Sans Mono:Bold:13.0"
              icon.color=0xffffffff
              label.color=0xffffffff
              icon.padding_left=4
              icon.padding_right=4
              label.padding_left=4
              label.padding_right=4
            )
            sketchybar --default "''\${default[@]}"

            ##### Adding Mission Control Space Indicators #####
            # Let's add some mission control spaces:
            # https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item
            # to indicate active and available mission control spaces.

            SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
            for i in "''\${!SPACE_ICONS[@]}"
            do
              sid="$(($i+1))"
              space=(
                space="$sid"
                icon="''\${SPACE_ICONS[i]}"
                icon.padding_left=7
                icon.padding_right=7
                background.color=0x40ffffff
                background.corner_radius=5
                background.height=25
                label.drawing=off
                script="$PLUGIN_DIR/space.sh"
                click_script="yabai -m space --focus $sid"
              )
              sketchybar --add space space."$sid" left --set space."$sid" "''\${space[@]}"
            done

            ##### Adding Left Items #####
            # We add some regular items to the left side of the bar, where
            # only the properties deviating from the current defaults need to be set

            sketchybar --add item front_app left \
                       --set front_app icon=󰣆 script="$PLUGIN_DIR/front_app.sh" \
                       --subscribe front_app front_app_switched

            ##### Adding Right Items #####
            # In the same way as the left items we can add items to the right side.
            # Additional position (e.g. center) are available, see:
            # https://felixkratz.github.io/SketchyBar/config/items#adding-items-to-sketchybar

            # Some items refresh on a fixed cycle, e.g. the clock runs its script once
            # every 10s. Other items respond to events they subscribe to, e.g. the
            # volume.sh script is only executed once an actual change in system audio
            # volume is registered. More info about the event system can be found here:
            # https://felixkratz.github.io/SketchyBar/config/events

            sketchybar --add item clock right \
                       --set clock update_freq=10 icon=  script="$PLUGIN_DIR/clock.sh" \
                       --add item volume right \
                       --set volume script="$PLUGIN_DIR/volume.sh" \
                       --subscribe volume volume_change \
                       --add item battery right \
                       --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
                       --subscribe battery system_woke power_source_change

            ##### Force all scripts to run the first time (never do this in a script) #####
            sketchybar --update
          '';
          services.sketchybar.extraPackages = [ pkgs.jq ];

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          system.defaults.dock.autohide = true;
          system.defaults.NSGlobalDomain._HIHideMenuBar = true;

          system.primaryUser = "mae";

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      darwinConfigurations."mae-mac-G00T0L7FPY" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}
