#!/usr/bin/env bash

set -euo pipefail

kind create cluster --config etc/kind-config.yaml

name=$(grep '^name:' etc/kind-config.yaml | cut -d: -f2 | tr -d ' ')
kubectl label node "${name}-control-plane" \
    node.kubernetes.io/exclude-from-external-load-balancers-

namespace=forgejo
echo "Installing Forgejo in namespace ${namespace}…"

helm install forgejo oci://code.forgejo.org/forgejo-helm/forgejo \
    -n "$namespace" --create-namespace -f etc/forgejo-values.yaml

# wait for the pod to be ready
kubectl -n "$namespace" rollout status deployment/forgejo --timeout=60s

echo ""
echo "Forgejo is available at http://localhost:8080"
echo "SSH (git) is available on port 2222"
echo "Default admin user: root / root"
