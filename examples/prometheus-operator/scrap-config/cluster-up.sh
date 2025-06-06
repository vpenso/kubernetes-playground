#!/usr/bin/env bash

kind create cluster --config etc/kind-config.yaml

name=$( grep name etc/kind-config.yaml | cut -d: -f2 | tr -d ' ')
kubectl label node $name-control-plane node.kubernetes.io/exclude-from-external-load-balancers-

version=$(curl -s https://api.github.com/repos/prometheus-operator/prometheus-operator/releases/latest | jq -cr .tag_name)
echo "Install prometheus-operator $version"
curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/download/${version}/bundle.yaml | kubectl create -f -
