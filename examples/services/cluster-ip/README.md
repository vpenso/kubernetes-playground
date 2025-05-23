
Create some pods via a deployment

```bash
→ kubectl create deployment website --replicas=3 --image=httpd

→ kubectl get deploy
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
website   3/3     3            3           2m49s

# all pods have the `app=website` label
→ kubectl get pod --show-labels
NAME                       READY   STATUS    RESTARTS   AGE    LABELS
website-5d755d9996-2h4c2   1/1     Running   0          3m1s   app=website,pod-template-hash=5d755d9996
website-5d755d9996-2vpdm   1/1     Running   0          3m1s   app=website,pod-template-hash=5d755d9996
website-5d755d9996-fck9z   1/1     Running   0          3m1s   app=website,pod-template-hash=5d755d9996
```

Create a ClusterIP service

```bash
→ kubectl apply -f service.yaml

# list the service including IP (only an internal IP)
→ kubectl get service website       
NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
website   ClusterIP   10.96.194.111   <none>        80/TCP    2m11s

# IP is allocated from 
→ kubectl cluster-info dump | grep -m 1 service-cluster-ip-range
                            "--service-cluster-ip-range=10.96.0.0/16"

→ kubectl get endpointslice | grep ^website         
website-5x9x7   IPv4          80      10.244.2.89,10.244.1.133,10.244.1.139 8m41s
```

Query the ClusterIP from a client pod:

```bash
→ kubectl run -it client --image busybox
# communicate cluster internal from the pod
→ wget -qO - http://10.96.194.111
<html><body><h1>It works!</h1></body></html>

# check logs for requests from the client pod
→ kubectl logs -l app=website | grep GET
```

Observer changes after:

```bash
# modify the replication scale
kubectl scale deployment website --replicas=2

# remove a pod
kubectl delete pod website-$name
```

Clean up…

```bash
kubectl delete pod/client service/website deploy/website
```



