
`cluster-up.sh` starts a Kind cluster and install the Prometheus stack

- …using the Helm `kube-prometheus-stack` [^3fH9j]chart

[^3fH9j]: Prometheus Stack, Helm Chart  
<https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack>

```bash
kubectl port-forward -n example prometheus-server-7b4cd9b7c8-9vkfm 9090:9090
```
