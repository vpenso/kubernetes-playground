## Traefik

File | Description
-----|--------------
`kind-config.yaml` | Configuration for the Kind Cluster
`traefik-values.yaml` | Configuration for the Traefik Helm chart


```bash
kind create cluster --config ./kind-config.yaml
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -n traefik --create-namespace -f traefik-values.yaml

# update after modification to the Traefik configuration
helm upgrade --install traefik traefik/traefik -n traefik -f traefik-values.yaml
```

Access the Traefik dashboard <http://localhost:9000/dashboard/>

```bash
#…by enabling port forwarding
traefik_pod=$(kubectl -n traefik get pods --selector "app.kubernetes.io/name=traefik" --output=name)
kubectl -n traefik port-forward $traefik_pod 9000:9000
```

Enable Traefik Gateway API support…

```bash
helm upgrade --install traefik traefik/traefik -n traefik \
    --set providers.kubernetesIngress.enabled=false \
    --set providers.kubernetesGateway.enabled=true \
    --set gateway.namespacePolicy=All \
    --set experimental.kubernetesGateway.enabled=true

# check container arguments…
kubectl -n traefik describe deployments.apps traefik

kubectl describe GatewayClass traefik
```

