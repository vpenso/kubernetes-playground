
```bash
kubectl apply -f service.yaml
kubectl create deployment website --replicas=3 --image=httpd

# later clean up
kubectl delete deployment/website service/website
```

Verify by connecting to the node port:

```bash
# identify the workers hosting the pods
>>> kubectl get pods -o wide    
NAME                       READY   STATUS    RESTARTS   AGE    IP NODE            NOMINATED NODE   READINESS GATES
website-5d755d9996-4dcr2   1/1     Running   0          112s   10.244.2.45        delta-worker2   <none>           <none>
website-5d755d9996-jnd8z   1/1     Running   0          112s   10.244.1.37        delta-worker    <none>           <none>
website-5d755d9996-tcswb   1/1     Running   0          112s   10.244.1.157       delta-worker    <none>           <none>

# select one of the nodes and get the node IP-address
>>> kubectl get nodes delta-worker -o wide
NAME           STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP OS-IMAGE                         KERNEL-VERSION           CONTAINER-RUNTIME
delta-worker   Ready    <none>   28m   v1.33.1   172.18.0.4    <none>      Debian GNU/Linux 12 (bookworm)   6.14.6-200.fc41.x86_64   containerd://2.1.1

# send a GET request to the node port
>>> curl -s 172.18.0.4:30080
<html><body><h1>It works!</h1></body></html>
```
