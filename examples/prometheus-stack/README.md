
`cluster-up.sh` starts a Kind cluster and install the Prometheus stack

- …using the Helm `kube-prometheus-stack` [^3fH9j]chart

[^3fH9j]: Prometheus Stack, Helm Chart  
<https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack>

```bash
# Alertmanager
kubectl port-forward service/alertmanager-operated 9093:9093 -n $namespace &

# Grafana
kubectl port-forward service/prom-stack-grafana 3000:80 -n $namespace &

# Prometheus Alertmanager
kubectl port-forward service/prom-stack-kube-prometheus-alertmanager 9093:9093 -n $namespace &

# Prometheus Operator
kubectl port-forward service/prom-stack-kube-prometheus-operator 443:443 -n $namespace &

# Prometheus
kubectl port-forward service/prom-stack-kube-prometheus-prometheus 9090:9090 -n $namespace &

# kube-state-metrics
kubectl port-forward service/prom-stack-kube-state-metrics 8080:8080 -n $namespace &

# Prometheus Node Exporter
kubectl port-forward service/prom-stack-prometheus-node-exporter 9100:9100 -n $namespace &

# Prometheus Operated
kubectl port-forward service/prometheus-operated 9090:9090 -n $namespace &
```
