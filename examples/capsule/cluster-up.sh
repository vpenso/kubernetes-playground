#!/usr/bin/env bash

set -euo pipefail

kind create cluster --config etc/kind-config.yaml --wait=120s

namespace=capsule-system
echo "Installing Capsule in namespace ${namespace}…"

helm upgrade --install capsule \
    oci://ghcr.io/projectcapsule/charts/capsule \
    --debug --create-namespace -n "$namespace" --version 0.13.11 \
    --set 'proxy.enabled=true' \
    --set 'proxy.certManager.generateCertificates=false' \
    --set 'proxy.options.additionalSANs={localhost}' \
    --set 'proxy.options.generateCertificates=true' \
    --set "proxy.options.leaderElection=true" \
    --set "proxy.options.roleBindingReflector=true" \
    --set "proxy.service.type=NodePort" \
    --set "proxy.kind=DaemonSet" \
    --set "proxy.daemonset.hostNetwork=true" \
    --set "proxy.serviceMonitor.enabled=false" \
    --set "proxy.options.extraArgs={--feature-gates=ProxyClusterScoped=true}" \
    --set 'crds.install=true' \
    --set 'certManager.generateCertificates=false' \
    --set 'tls.enableController=true' \
    --set 'tls.create=true'

# wait for the controller to be ready
kubectl -n "$namespace" rollout status deployment/capsule-controller-manager --timeout=120s

echo ""
echo "Pods in capsule-system:"
kubectl -n "$namespace" get pods

# apply the example tenant and owner
echo ""
echo "Applying tenant resources…"
kubectl apply -f tenant.yaml -f tenant-owner.yaml

echo ""
echo "Capsule is installed and tenant 'solar' is active."
echo ""
echo "Quick test — run as alice:"
echo "  alias kubectl-alice='kubectl --as alice --as-group projectcapsule.dev'"
echo "  kubectl-alice create namespace solar-development"
