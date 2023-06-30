#!/bin/bash

bw list items --search "ssh - laptop - arch" | jq -r '.[0].fields[] | select(.name=="public") | .value' | sed 's,\\n,\n,g' > ~/.ssh/id_ed25519.pub
chmod 400 ~/.ssh/id_ed25519.pub

bw list items --search "ssh - laptop - arch" | jq -r '.[0].fields[] | select(.name=="private") | .value' | sed 's,\\n,\n,g' > ~/.ssh/id_ed25519
chmod 400 ~/.ssh/id_ed25519
