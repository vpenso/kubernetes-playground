Load a container image into the cluster:

```bash
# create a container image
docker build -t sleep:latest .

# start a cluster
Kind create cluster

# load the image into the cluster
kind load docker-image sleep:latest

# use the image
kubectl apply -f example.yaml
```
