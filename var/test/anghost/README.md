
Anghost[^l7Az2]

[^l7Az2]: Agnositc Host Kubernetes Test Container, GitHub  
<https://github.com/kubernetes/kubernetes/blob/master/test/images/agnhost/README.md>

```bash
>>> kubectl apply -f demo.yaml
>>> kubectl get -o wide service/demo pod/demo            
NAME           TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE SELECTOR
service/demo   NodePort   10.96.239.134   <none>        8080:30080/TCP   54s app=demo

NAME       READY   STATUS    RESTARTS   AGE   IP            NODE               NOMINATED NODE   READINESS GATES
pod/demo   1/1     Running   0          54s   10.244.0.14   kind-control-plane <none>           <none>

# identify the IP of the worker node
>>> kubectl get nodes -o wide
NAME                 STATUS   ROLES           AGE   VERSION   INTERNAL-IP EXTERNAL-IP #…
kind-control-plane   Ready    control-plane   32m   v1.33.1   172.18.0.2  <none>      #…

# access via NodePort
>>> curl http://172.18.0.2:30080/hostname         
demo
>>> curl http://172.18.0.2:30080/clientip 
10.244.0.1:22041

>>> echo $(curl -s 'http://172.18.0.2:30080/shell?cmd=ip+r' | jq .output | tr -d '"')
default via 10.244.0.1 dev eth0 
10.244.0.0/24 via 10.244.0.1 dev eth0 src 10.244.0.14 
10.244.0.1 dev eth0 scope link src 10.244.0.14 
```
