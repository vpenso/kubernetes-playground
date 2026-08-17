# Capsule

[`cluster-up.sh`](cluster-up.sh) starts a Kind cluster and installs Capsule[^capsule] — a **multi-tenant access control** system for Kubernetes — with the Capsule Proxy for namespace-scoped views.

[^capsule]: Project Capsule
<https://projectcapsule.dev>

```bash
# remove the test cluster
kind delete cluster --name capsule
```

## Usage

```bash
# bring up the cluster and install Capsule
./cluster-up.sh

# verify the installation
kubectl get pods -n capsule-system

# check the applied tenant
kubectl get tenant solar
```

After `cluster-up.sh` completes, alice can create namespaces under the **solar** tenant with restricted permissions:

```bash
# all following commands run as alice
alias kubectl-alice='kubectl --as alice --as-group projectcapsule.dev'

# create a namespace (prefix enforced by Capsule)
kubectl-alice create namespace solar-development

# the environment label is auto-applied
kubectl get namespace solar-development --show-labels

# label change is restricted to allowed values
kubectl-alice label namespace solar-development environment=test --overwrite

# production namespace with QoS restrictions
kubectl-alice apply -f example-namespace.yaml

# namespace quota enforced (max 2 per tenant)
kubectl-alice create namespace solar-staging  # Forbidden
```

### Capsule Proxy

The Proxy lets tenant users run `kubectl get namespaces` and see only their own:

```bash
# generate a kubeconfig for alice
curl -s https://raw.githubusercontent.com/projectcapsule/capsule/main/hack/create-user.sh | bash -s -- alice solar projectcapsule.dev

# point to the proxy
KUBECONFIG=alice-solar.kubeconfig kubectl config set clusters.kind-capsule.certificate-authority-data "$(kubectl -n capsule-system get secret capsule-proxy -o jsonpath='{.data.ca}')"
KUBECONFIG=alice-solar.kubeconfig kubectl config set clusters.kind-capsule.server https://localhost:9001
export KUBECONFIG=alice-solar.kubeconfig

# alice sees only her namespaces
kubectl get ns -A
```

## Configuration

File | Description
-----|--------------
`etc/kind-config.yaml` | Configuration for the Kind cluster
`tenant.yaml` | Example **solar** tenant with QoS rules
`tenant-owner.yaml` | `TenantOwner` binding for alice

### Manual Installation

```bash
# create the cluster
kind create cluster --config etc/kind-config.yaml --wait=120s

# install Capsule with proxy
helm upgrade --install capsule \
    oci://ghcr.io/projectcapsule/charts/capsule \
    --debug --create-namespace -n capsule-system --version 0.13.11 \
    --set 'proxy.enabled=true' \
    --set 'proxy.certManager.generateCertificates=false' \
    --set 'proxy.options.additionalSANs={localhost}' \
    --set 'proxy.options.generateCertificates=true' \
    --set "proxy.options.leaderElection=true" \
    --set "proxy.options.roleBindingReflector=true" \
    --set "proxy.service.type=NodePort" \
    --set "proxy.kind=DaemonSet" \
    --set "proxy.daemonset.hostNetwork=true" \
    --set "proxy.serviceMonitor.enabled=false" \
    --set "proxy.options.extraArgs={--feature-gates=ProxyClusterScoped=true}" \
    --set 'crds.install=true' \
    --set 'certManager.generateCertificates=false' \
    --set 'tls.enableController=true' \
    --set 'tls.create=true'

# apply tenant resources
kubectl apply -f tenant.yaml -f tenant-owner.yaml
```

Upgrade after modifying configuration:

```bash
helm upgrade --install capsule \
    oci://ghcr.io/projectcapsule/charts/capsule \
    --debug --create-namespace -n capsule-system --version 0.13.11 \
    --set 'proxy.enabled=true' \
    --set 'proxy.certManager.generateCertificates=false' \
    --set 'proxy.options.additionalSANs={localhost}' \
    --set 'proxy.options.generateCertificates=true' \
    --set "proxy.options.leaderElection=true" \
    --set "proxy.options.roleBindingReflector=true" \
    --set "proxy.service.type=NodePort" \
    --set "proxy.kind=DaemonSet" \
    --set "proxy.daemonset.hostNetwork=true" \
    --set "proxy.serviceMonitor.enabled=false" \
    --set "proxy.options.extraArgs={--feature-gates=ProxyClusterScoped=true}" \
    --set 'crds.install=true' \
    --set 'certManager.generateCertificates=false' \
    --set 'tls.enableController=true' \
    --set 'tls.create=true'
```

### Tenant Rules

Rule | Effect
-----|--------
`namespaceOptions.quota: 2` | Max 2 namespaces per tenant
`forceTenantPrefix: true` | Namespaces must start with `solar-`
`environment` label required | Values restricted to `dev`, `test`, `prod`
`environment=prod` QoS | Only `Guaranteed` pods allowed
Non-prod QoS | `BestEffort`, `Burstable`, `Guaranteed` allowed
