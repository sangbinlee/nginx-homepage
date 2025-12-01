

 

# 
```
```

 

# 
```
```

 

# 초기화: 기존 설치 제거

```
```
# Ingress 리소스 제거:


```
NGINX Ingress:
cert-manager:
MetalLB
Calico(Manifest 설치였다면):

  kubectl delete ingress --all -A
  kubectl delete ns ingress-nginx || true

  kubectl delete ns cert-manager || true 
  kubectl delete crd $(kubectl get crd | grep cert-manager | awk '{print $1}') || true

  kubectl delete ns metallb-system || true

  kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml || true
  ```


```
sangbinlee9@k8s-master1:~$ kubectl delete ingress --all -A

ingress.networking.k8s.io "cm-acme-http-solver-242zm" deleted from default namespace
ingress.networking.k8s.io "cm-acme-http-solver-b5xb7" deleted from default namespace
ingress.networking.k8s.io "shop-tls-ingress" deleted from default namespace
sangbinlee9@k8s-master1:~$

```
 

# 재설치 1: Calico(CNI)
```


설치: kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml

확인:

kubectl -n kube-system get pods | grep calico

모든 calico-node, calico-kube-controllers가 Running이어야 합니다.

kubectl get nodes 로 Ready 상태 확인.



```

 

# 재설치 2: MetalLB(VIP 제공)
```

kubectl create ns metallb-system


  apiVersion: metallb.io/v1beta1
  kind: IPAddressPool
  metadata:
    name: vip-pool
    namespace: metallb-system
  spec:
    addresses:
      - 192.168.0.240-192.168.0.240
  ---
  apiVersion: metallb.io/v1beta1
  kind: L2Advertisement
  metadata:
    name: l2adv
    namespace: metallb-system
  spec:
    ipAddressPools:
      - vip-pool



적용: kubectl apply -f vip-pool.yaml

확인:

kubectl -n metallb-system get pods

speaker/controller가 Running.

L2 모드라면 동일 서브넷의 스위치/ARP 응답이 가능한지(중복 IP 없음) 확인.




```



# 재설치 3: NGINX Ingress Controller
```

kubectl create ns ingress-nginx



확인:

kubectl -n ingress-nginx get svc LoadBalancer 타입의 Service가 EXTERNAL-IP로 192.168.0.240을 가져야 합니다.

kubectl -n ingress-nginx get pods controller가 Running.

내부에서 테스트: curl -H "Host: dev9.shop" http://<클러스터내IP>:<nodePort> 또는 VIP로: curl -H "Host: dev9.shop" http://192.168.0.240










```

# 재설치 4: cert-manager 및 발급자 설정
```

ClusterIssuer

kubectl apply -f 1clusterissuer.yaml














```

# 애플리케이션 Ingress 및 테스트
```
4ingress.yaml


적용 후 확인:

kubectl describe ingress shop-tls-ingress

kubectl -n cert-manager describe certificate shop-tls-secret

kubectl -n cert-manager logs deploy/cert-manager, cert-manager-webhook

curl -H "Host: dev9.shop" http://192.168.0.240
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```

# 
```
```