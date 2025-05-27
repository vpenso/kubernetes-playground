# Slinky Cluster

Slinky[^f3Glk] …`cluster-up.sh` start a Kind cluster…

[^f3Glk]: Slinky Project, GitHub  
<https://github.com/SlinkyProject>


- …with cloud provider for load-balancing service IPs
- …deploys `cert-manager` and `prometheus` via Helm chars
- …deploys `slurm-operator` [^l78gh] and `slurm` cluster via Helm charts

[^l78gh]: `slurm-operator`, Slinky Documentation  
<https://slinky.schedmd.com/docs/slurm-operator>

```bash
# clean up
kind delete cluster --name slinky
pkill -f cloud-provider-kind
```

Test basic functionality of the cluster…

```bash
>>> kubectl -n slurm exec -it statefulsets/slurm-controller -- bash --login
slurm@slurm-controller-0:/tmp$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug        up   infinite      1   idle debug-0
all*         up   infinite      1   idle debug-0
slurm@slurm-controller-0:/tmp$ srun hostname
debug-0
```

### Configuration

File | Description
-----|-----------------
`etc/slurm-values.yaml` | Configure the Slurm cluster
`etc/slurm-operator-values.yaml` | Configure the Slurm Kubernetes operator

