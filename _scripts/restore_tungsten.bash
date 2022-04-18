#!/bin/bash

bw list items --search "wolfram alpha api key" | jq -r '.[0].notes' > ~/.wolfram_api_key
