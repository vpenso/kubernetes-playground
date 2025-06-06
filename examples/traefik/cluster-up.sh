#!/usr/bin/env bash

kind create cluster --config etc/kind-config.yaml

name=$( grep name etc/kind-config.yaml | cut -d: -f2 | tr -d ' ')
kubectl label node $name-control-plane node.kubernetes.io/exclude-from-external-load-balancers-

helm repo add traefik https://helm.traefik.io/traefik
helm repo update

namespace=traefik
echo "Install Traefik to namespace $namespace"
helm install traefik traefik/traefik \
        -n $namespace --create-namespace -f etc/traefik-values.yaml
kubectl -n $namespace get pods
