# Traefik

[`cluster-up.sh`](cluster-up.sh) starts a Kind cluster, install & configure Traefik ingress

Access the Traefik dashboard <http://localhost:9000/dashboard/>

```bash
# remove the test cluster
kind delete cluster --name traefik
```

## Usage

Proxy[^kl56g] an application …see [`example.yaml`](example.yaml)

[^kl56g]: Quick Start, Traefik Documentation  
<https://doc.traefik.io/traefik/getting-started/quick-start-with-kubernetes/#proxying-applications>

- …deployment of an application `traefik/whoami`[^fg47j] on port 80
- …service `whoami` on port 80
- …ingress …redirect any incoming requests starting with `/` to the `whoami:80` service

[^fg47j]: Traefik Whoami Server, GitHub  
<https://github.com/traefik/whoami>

```bash
# apply the example application
kubectl apply -f example.yaml

# check the resources
kubectl get service whoami
kubectl get ingress whoami-ingress

# send a GET request
curl localhost:8080
```

## Configuration

File | Description
-----|--------------
`etc/kind-config.yaml` | Configuration for the Kind Cluster
`etc/traefik-values.yaml` | Configuration for the Traefik Helm chart

```bash
# example manual installation of Traefik
kind create cluster --config etc/kind-config.yaml
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -n traefik --create-namespace -f etc/traefik-values.yaml
```

Update after modification to the Traefik configuration…

```bash
helm upgrade --install traefik traefik/traefik -n traefik -f etc/traefik-values.yaml
```

Enabling port forwarding …not required see `etc/kind-config.yaml'

```bash
traefik_pod=$(kubectl -n traefik get pods --selector "app.kubernetes.io/name=traefik" --output=name)
kubectl -n traefik port-forward $traefik_pod 9000:9000
```

### Gateway API

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

