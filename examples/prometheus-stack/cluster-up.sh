#!/usr/bin/env bash

kind create cluster --config etc/kind-config.yaml

name=$( grep name etc/kind-config.yaml | cut -d: -f2 | tr -d ' ')
kubectl label node $name-control-plane node.kubernetes.io/exclude-from-external-load-balancers-

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

namespace=example
echo "Install Prometheus to namespace $namespace"
helm install prometheus prometheus-community/prometheus \
        --create-namespace --namespace $namespace > helm-install.log
kubectl -n $namespace get pods
