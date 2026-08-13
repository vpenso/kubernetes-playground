# Forgejo

[`cluster-up.sh`](cluster-up.sh) starts a Kind cluster and installs[^fc6t] Forgejo — a lightweight self-hosted Git server — via Helm with SQLite persistence and NodePort access.

Access the web UI <http://localhost:8080>

```bash
# remove the test cluster
kind delete cluster --name forgejo
```

## Usage

```bash
# bring up the cluster and install Forgejo
./cluster-up.sh

# check the deployment
kubectl -n forgejo get pods
kubectl -n forgejo get svc
kubectl -n forgejo get pvc
```

After installation, visit <http://localhost:8080>. The default admin credentials are `root` / `root`.

> Change them in `etc/forgejo-values.yaml` before running `cluster-up.sh`. Note that `admin` is a reserved name and cannot be used.

Git over SSH is exposed on port `2222`:

```bash
# clone a repository via SSH
git clone ssh://root@localhost:2222/root/example.git
```

## Configuration

File | Description
-----|-------------
`etc/kind-config.yaml` | Configuration for the Kind cluster
`etc/forgejo-values.yaml` | Values passed to the Forgejo Helm chart

### Manual Installation

```bash
# create the cluster
kind create cluster --config etc/kind-config.yaml

name=$(grep '^name:' etc/kind-config.yaml | cut -d: -f2 | tr -d ' ')
kubectl label node "${name}-control-plane" \
    node.kubernetes.io/exclude-from-external-load-balancers-

# install Forgejo via OCI registry (no helm repo add needed)
helm install forgejo oci://code.forgejo.org/forgejo-helm/forgejo \
    -n forgejo --create-namespace -f etc/forgejo-values.yaml
```

Update after modifying the configuration:

```bash
helm upgrade forgejo oci://code.forgejo.org/forgejo-helm/forgejo \
    -n forgejo -f etc/forgejo-values.yaml
```

### Helm Values

Settings from [`etc/forgejo-values.yaml`](etc/forgejo-values.yaml), grouped by category.

#### Service — HTTP

Setting | Value | Description
--------|-------|-------------
`service.http.type` | `NodePort` | Kubernetes service type; avoids needing an Ingress controller
`service.http.port` | `3000` | Internal port Forgejo listens on inside the pod
`service.http.nodePort` | `32080` | NodePort assigned on each cluster node, mapped to host `8080`

#### Service — SSH

Setting | Value | Description
--------|-------|-------------
`service.ssh.type` | `NodePort` | Same as HTTP — direct node access without Ingress
`service.ssh.port` | `22` | Internal port for Git over SSH
`service.ssh.nodePort` | `32022` | Mapped to host `2222` via `kind-config.yaml`

#### Admin User

Setting | Value | Description
--------|-------|-------------
`gitea.admin.username` | `root` | Username auto-created on first boot (`admin` is reserved)
`gitea.admin.password` | `root` | Initial password; change before production use

#### Persistence

Setting | Value | Description
--------|-------|-------------
`persistence.enabled` | `true` | Creates a PVC so repositories, DB, and config survive restarts
`persistence.storageClass` | `standard` | The default StorageClass in Kind clusters
`persistence.size` | `5Gi` | Provisioned disk space

#### Database

Setting | Value | Description
--------|-------|-------------
`database.type` | `sqlite` | Built-in SQLite; simplest option for local testing

#### Cache

Setting | Value | Description
--------|-------|-------------
`cache.enabled` | `false` | No external Redis/cache needed for a single-pod setup

#### Ingress

Setting | Value | Description
--------|-------|-------------
`ingress.enabled` | `false` | Not needed — Kind port mappings + NodePorts provide access directly

---

[^fc6t]: Forgejo  
<https://forgejo.org>

