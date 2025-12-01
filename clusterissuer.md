1clusterissuer.yaml








``` 


# letsencrypt-production-clusterissuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # 이메일 주소: sangbinlee9@gmail.com
    email: sangbinlee9@gmail.com
    server: https://acme-v02.api.letsencrypt.org/directory # Production 서버 URL
    privateKeySecretRef:
      name: letsencrypt-prod-key
    solvers:
    - http01:
        ingress:
          class: nginx

```





# certificate
12certificate.yaml


 


```
# Certificate: dev9.shop 도메인에 대한 인증서 요청
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: dev9-shop-cert
  # 이 Certificate를 사용할 서비스/Ingress가 있는 네임스페이스
  namespace: default
spec:
  # 발급된 인증서가 저장될 Secret 이름
  secretName: dev9-shop-tls 
  # 인증서 발급에 사용할 ClusterIssuer 지정
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  # 인증서를 발급받을 도메인 목록
  dnsNames:
  - dev9.shop
  - dev.dev9.shop


```










```
sangbinlee9@k8s-master1:~$ kubectl apply -f 12certificate.yaml
Warning: spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
certificate.cert-manager.io/dev9-shop-cert created
```









```
kubectl describe certificate dev9-shop-cert -n default
```





```

# Order 삭제 (현재 진행 중인 Order)
kubectl delete order dev9-shop-cert-1-1060837548 -n default
kubectl delete order shop-tls-secret-1-1055312325 -n default

# Challenge 삭제 (이름을 일일이 지정하거나, 한꺼번에 삭제)
kubectl delete challenge --all -n default



```





```

# Certificate 삭제
kubectl delete certificate dev9-shop-cert -n default

# Certificate YAML 파일을 다시 적용하여 재시작
kubectl apply -f 12certificate.yaml
```





```

# NGINX Ingress Controller가 설치된 네임스페이스에서 파드 상태 확인
kubectl get pods -n ingress-nginx # (혹은 default, kube-system 등 설치된 네임스페이스)
```





```

단계 3: Ingress 설정 확인 (매우 중요)
http01 Challenge가 성공하려면, 443 포트 대신 80 포트로 들어오는 /.(well-known)/acme-challenge/ 경로의 요청이 NGINX Ingress Controller를 통해 cert-manager의 Challenge Responder 파드로 정확히 전달되어야 합니다.

NGINX Ingress Controller가 현재 클러스터에 정상적으로 설치 및 운영 중인지 다시 한번 확인해주세요.

Bash

# NGINX Ingress Controller가 설치된 네임스페이스에서 파드 상태 확인
kubectl get pods -n ingress-nginx # (혹은 default, kube-system 등 설치된 네임스페이스)

```





```


	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

```





```

sangbinlee9@k8s-master1:~$
sangbinlee9@k8s-master1:~$ kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml
namespace/metallb-system created
customresourcedefinition.apiextensions.k8s.io/bfdprofiles.metallb.io created
customresourcedefinition.apiextensions.k8s.io/bgpadvertisements.metallb.io created
customresourcedefinition.apiextensions.k8s.io/bgppeers.metallb.io created
customresourcedefinition.apiextensions.k8s.io/communities.metallb.io created
customresourcedefinition.apiextensions.k8s.io/ipaddresspools.metallb.io created
customresourcedefinition.apiextensions.k8s.io/l2advertisements.metallb.io created
customresourcedefinition.apiextensions.k8s.io/servicebgpstatuses.metallb.io created
customresourcedefinition.apiextensions.k8s.io/servicel2statuses.metallb.io created
serviceaccount/controller created
serviceaccount/speaker created
role.rbac.authorization.k8s.io/controller created
role.rbac.authorization.k8s.io/pod-lister created
clusterrole.rbac.authorization.k8s.io/metallb-system:controller created
clusterrole.rbac.authorization.k8s.io/metallb-system:speaker created
rolebinding.rbac.authorization.k8s.io/controller created
rolebinding.rbac.authorization.k8s.io/pod-lister created
clusterrolebinding.rbac.authorization.k8s.io/metallb-system:controller created
clusterrolebinding.rbac.authorization.k8s.io/metallb-system:speaker created
configmap/metallb-excludel2 created
secret/metallb-webhook-cert created
service/metallb-webhook-service created
deployment.apps/controller created
daemonset.apps/speaker created
validatingwebhookconfiguration.admissionregistration.k8s.io/metallb-webhook-configuration created
sangbinlee9@k8s-master1:~$ kubectl get pods -n metallb-system
NAME                          READY   STATUS    RESTARTS   AGE
controller-6599cd9c46-wwb5m   1/1     Running   0          93s
speaker-c5jjs                 1/1     Running   0          93s
speaker-d84fd                 1/1     Running   0          93s
speaker-dcqpf                 1/1     Running   0          93s
speaker-m4t44                 1/1     Running   0          93s
speaker-n7lnp                 1/1     Running   0          93s
speaker-qsjzw                 1/1     Running   0          93s
speaker-r5b7s                 1/1     Running   0          93s
sangbinlee9@k8s-master1:~$


```





```

sangbinlee9@k8s-master1:~$ cat 0metallb-config.yaml

# metallb-ip-config.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: external-ip-pool
  namespace: metallb-system
spec:
  # 🚨 사용하지 않는 5개의 IP 주소 범위를 설정 (예시)
  # 192.168.0.200 부터 192.168.0.204 까지 5개를 할당.
  # 사용자님의 네트워크 환경에 맞춰 변경해야 합니다.
  addresses:
  - 192.168.0.240-192.168.0.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: basic-l2
  namespace: metallb-system
spec:
  ipAddressPools:
  - external-ip-pool
sangbinlee9@k8s-master1:~$ kubectl apply -f 0metallb-config.yaml
ipaddresspool.metallb.io/external-ip-pool created
l2advertisement.metallb.io/basic-l2 created
sangbinlee9@k8s-master1:~$

```





```
sangbinlee9@k8s-master1:~$ kubectl get pods -n metallb-system
NAME                          READY   STATUS    RESTARTS   AGE
controller-6599cd9c46-wwb5m   1/1     Running   0          60s
speaker-c5jjs                 1/1     Running   0          60s
speaker-d84fd                 1/1     Running   0          60s
speaker-dcqpf                 1/1     Running   0          60s
speaker-m4t44                 1/1     Running   0          60s
speaker-n7lnp                 1/1     Running   0          60s
speaker-qsjzw                 1/1     Running   0          60s
speaker-r5b7s                 1/1     Running   0          60s
sangbinlee9@k8s-master1:~$ kubectl describe svc ingress-nginx-controller -n ingress-nginx
Name:                     ingress-nginx-controller
Namespace:                ingress-nginx
Labels:                   app.kubernetes.io/component=controller
                          app.kubernetes.io/instance=ingress-nginx
                          app.kubernetes.io/name=ingress-nginx
                          app.kubernetes.io/part-of=ingress-nginx
                          app.kubernetes.io/version=1.14.0
Annotations:              <none>
Selector:                 app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
Type:                     LoadBalancer
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.100.120.72
IPs:                      10.100.120.72
Port:                     http  80/TCP
TargetPort:               http/TCP
NodePort:                 http  32029/TCP
Endpoints:                192.168.126.62:80
Port:                     https  443/TCP
TargetPort:               https/TCP
NodePort:                 https  31041/TCP
Endpoints:                192.168.126.62:443
Session Affinity:         None
External Traffic Policy:  Local
Internal Traffic Policy:  Cluster
HealthCheck NodePort:     30998
Events:                   <none>
sangbinlee9@k8s-master1:~$ kubectl describe svc ingress-nginx-controller -n ingress-nginx
Name:                     ingress-nginx-controller
Namespace:                ingress-nginx
Labels:                   app.kubernetes.io/component=controller
                          app.kubernetes.io/instance=ingress-nginx
                          app.kubernetes.io/name=ingress-nginx
                          app.kubernetes.io/part-of=ingress-nginx
                          app.kubernetes.io/version=1.14.0
Annotations:              metallb.io/ip-allocated-from-pool: external-ip-pool
Selector:                 app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
Type:                     LoadBalancer
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.100.120.72
IPs:                      10.100.120.72
LoadBalancer Ingress:     192.168.0.240 (VIP)
Port:                     http  80/TCP
TargetPort:               http/TCP
NodePort:                 http  32029/TCP
Endpoints:                192.168.126.62:80
Port:                     https  443/TCP
TargetPort:               https/TCP
NodePort:                 https  31041/TCP
Endpoints:                192.168.126.62:443
Session Affinity:         None
External Traffic Policy:  Local
Internal Traffic Policy:  Cluster
HealthCheck NodePort:     30998
Events:
  Type    Reason        Age   From                Message
  ----    ------        ----  ----                -------
  Normal  nodeAssigned  4s    metallb-speaker     announcing from node "k8s-worker2" with protocol "layer2"
  Normal  IPAllocated   4s    metallb-controller  Assigned IP ["192.168.0.240"]
sangbinlee9@k8s-master1:~$

```





```
```





```
```





```
```




