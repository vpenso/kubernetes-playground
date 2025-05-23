#!/usr/bin/env bash

if ! helm repo list | grep ^kubernetes-dashboard ; then
        helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard
fi
helm install --hide-notes dashboard kubernetes-dashboard/kubernetes-dashboard \
        --namespace kubernetes-dashboard --create-namespace

echo "Wait for Kuberneters dashboard to become ready…"
kubectl -n kubernetes-dashboard wait --for=condition=Ready --timeout -1s \
        $(kubectl -n kubernetes-dashboard get pods -l app=dashboard-kong -o name)

kubectl -n kubernetes-dashboard port-forward svc/dashboard-kong-proxy 8443:443 >/dev/null &
$BROWSER https://localhost:8443

kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
echo "Access token…"
kubectl -n kubernetes-dashboard create token admin-user

