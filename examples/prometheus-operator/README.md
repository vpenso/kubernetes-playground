
`cluster-up.sh` starts a Kind cluster and install `prometheus-operator`[^t456G]

[^t456G]: Prometheus Operator  
<https://prometheus-operator.dev/docs>  
<https://github.com/prometheus-operator>

Example is this directory illustrate a configuration to scrape external resources…

- …based on a custom scrape config[^k4Fg2]

[^k4Fg2]: ScrapeConfig CRD, Prometheus Operator Documentation  
<https://prometheus-operator.dev/docs/developer/scrapeconfig>

```bash
kubectl kustomize . | kubectl apply -f -
```
