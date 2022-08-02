#!/bin/bash
NAMESPACE=${1:-default}
kubectl get namespace $NAMESPACE | read ERR &&
  kubectl get -n $NAMESPACE pods -o yaml | yq '.items[] | select(.status.phase=="Failed" and .status.reason=="Evicted") | .metadata.name' | xargs -I{} kubectl delete -n $NAMESPACE pod {} ||
  echo -n "$ERR" && exit 1 
