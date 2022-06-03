#!/bin/bash

kubectl get -A pods -o yaml | yq '.items[] | select(.status.phase=="Failed" and .status.reason=="Evicted") | .metadata.name' | xargs -I{} echo "kubectl delete -A" {}
