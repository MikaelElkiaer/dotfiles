#!/bin/bash

bw list items --search "ssh - laptop - arch" | jq -r '.[0].fields[] | select(.name=="public") | .value' > ~/.ssh/id_ed25519.pub
chmod 400 ~/.ssh/id_ed25519.pub

bw list items --search "ssh - laptop - arch" | jq -r '.[0].fields[] | select(.name=="private") | .value' > ~/.ssh/id_ed25519
chmod 400 ~/.ssh/id_ed25519
