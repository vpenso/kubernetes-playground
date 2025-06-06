#!/usr/bin/env bash

kind create cluster --config etc/kind-config.yaml

name=$( grep name etc/kind-config.yaml | cut -d: -f2 | tr -d ' ')
kubectl label node $name-control-plane node.kubernetes.io/exclude-from-external-load-balancers-

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

namespace=example
helm_log=helm-install.log
password="password1234!"
echo "Install Prometheus sTack to namespace $namespace ...$helm_log"
helm install prom-stack prometheus-community/kube-prometheus-stack \
        --create-namespace --namespace $namespace \
        --set grafana.adminPassword="$password" > $helm_log
echo "Grafana admin/$password"
