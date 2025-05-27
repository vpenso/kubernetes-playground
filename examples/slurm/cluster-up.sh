#!/usr/bin/env bash

kind create cluster --config etc/kind-config.yaml

# start cloud provider
cloud-provider-kind 2>cloud-provider.log &

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install cert-manager \
	jetstack/cert-manager \
	--namespace cert-manager --create-namespace \
	--set crds.enabled=true

helm install prometheus \
	prometheus-community/kube-prometheus-stack \
	--namespace prometheus --create-namespace \
	--set installCRDs=true

helm install slurm-operator \
	oci://ghcr.io/slinkyproject/charts/slurm-operator \
        --namespace=slinky --create-namespace \
        --values=etc/slurm-operator-values.yaml \
        --version=0.2.1

helm install slurm \
	oci://ghcr.io/slinkyproject/charts/slurm \
	--namespace=slurm --create-namespace \
  	--values=etc/slurm-values.yaml \
	--version=0.2.1 

