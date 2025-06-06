
`cluster-up.sh` starts a Kind cluster and install `prometheus-operator`[^t456G]

[^t456G]: Prometheus Operator  
<https://prometheus-operator.dev/docs>  
<https://github.com/prometheus-operator>

Example is this directory illustrate a configuration to scrape external resources…

- …based on a custom scrape config[^k4Fg2]
- …example targets metrics endpoints outside the Kubernetes cluster

[^k4Fg2]: ScrapeConfig CRD, Prometheus Operator Documentation  
<https://prometheus-operator.dev/docs/developer/scrapeconfig>

```bash
kubectl kustomize . | kubectl apply -f -

# access the Prometheus web interface
kubectl port-forward prometheus-example-prometheus-0 9090:9090
$BROWSER localhost:9090
```

File | Description
-----|------------------
`prometheus.yaml` | Use `prometheus-operator` to start a Prometheus server
`scarp-config.yaml` | Configure scraper targets for Prometheus

