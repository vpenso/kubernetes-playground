`netshoot` container[^d4gFv]…

```bash
# ephemeral container in existing pod
kubectl debug $pod_name -it --image=nicolaka/netshoot

# throw away pod for debugging
kubectl run $pod_name --rm -i --tty --image nicolaka/netshoot
```

[^d4gFv]: `netshoot` Container, Github  
<https://github.com/nicolaka/netshoot>
