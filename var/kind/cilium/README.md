
Install `cilium` & `hubble` CLI …see [`cilium-install`](bin/cilium-install)

[`cluster-up.sh`](cluster-up.sh) starts the Kind cluster and installs
Cilium[^kl3F2] & Hubble[^Ty71A]…

[^kl3F2]: Cilium Quick Installation, Cilium Documentation  
<https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/>

[^Ty71A]: Setting up Hubble Observability, Cilium Documentation  
<https://docs.cilium.io/en/stable/observability/hubble/setup/#hubble-setup>

File | Description
-----|--------------------
`etc/kind-config.yaml` | Configuration for the Kind Kubernetes cluster
`etc/cilium-config.yaml` | Configuration for the Cilium Kubernetes CNI plugin

### Operations

```bash
# validate that Cilium has been properly installed
cilium status --wait

# (optional) …validate proper network connectivity:
cilium connectivity test

# upgrade after modifying the configuration
cilium upgrade -f etc/cilium-config.yaml
```
```bash

# …create a port forward to the Hubble service
cilium hubble port-forward

# …validate that you can access the Hubble API
hubble status
# …query the flow API and look for flows
hubble observe

# open the Hubble UI in your browser
cilium hubble ui
```

