
Make sure `cloud-provider-kind`[^fg3D4] is installed.

[^fg3D4]: Cloud provider for KIND clusters, GitHub  
<https://github.com/kubernetes-sigs/cloud-provider-kind>

```bash
# start the cluster
kind create cluster --config kind-config.yaml

# start cloud provider
cloud-provider-kind 2>cloud-provider.log &

# start the demo application
kubectl apply -f demo.yaml
```

Check if the load-balancer works as expected…

```bash
# the service should get an external IP
>>> kubectl get service demo
NAME   TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
demo   LoadBalancer   10.96.178.213   172.18.0.5    80:32068/TCP   38s

# query the application (note that two instances should answer)
>>> curl 172.18.0.5/hostname
demo-776b545c66-vcn2f
>>> curl 172.18.0.5/hostname
demo-776b545c66-4sh2c
```

Clean up…

```bash
kubectl delete service/demo deployment/demo
pkill -9 -f cloud-provider-kind
kind cluster delete
```
