# k8s local env 

1. k8s cluster  in home laptop
```
- master 1 개
- worker 6 개
```

```
sangbinlee9@k8s-master1:~$ kubectl get no -o wide -A
NAME          STATUS   ROLES           AGE     VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
k8s-db1       Ready    <none>          2d20h   v1.34.1   192.168.0.12   <none>        Ubuntu 24.04.2 LTS   6.8.0-87-generic   containerd://2.2.0
k8s-db2       Ready    <none>          2d20h   v1.34.1   192.168.0.13   <none>        Ubuntu 24.04.3 LTS   6.8.0-87-generic   containerd://2.2.0
k8s-master1   Ready    control-plane   2d21h   v1.34.1   192.168.0.5    <none>        Ubuntu 24.04.3 LTS   6.8.0-87-generic   containerd://2.2.0
k8s-worker1   Ready    <none>          2d20h   v1.34.1   192.168.0.20   <none>        Ubuntu 24.04.3 LTS   6.8.0-87-generic   containerd://2.2.0
k8s-worker2   Ready    <none>          2d20h   v1.34.1   192.168.0.21   <none>        Ubuntu 24.04.3 LTS   6.8.0-87-generic   containerd://2.2.0
k8s-worker3   Ready    <none>          2d20h   v1.34.1   192.168.0.15   <none>        Ubuntu 24.04.2 LTS   6.8.0-87-generic   containerd://2.2.0
k8s-worker4   Ready    <none>          2d20h   v1.34.1   192.168.0.14   <none>        Ubuntu 24.04.3 LTS   6.8.0-87-generic   containerd://2.2.0
sangbinlee9@k8s-master1:~$
```

2. network set

```
- containerd
- calico,  
- metallb(192.168.0.240), 
```

3. https set
```
- cert-manager, 
- clusterissuer, 
```
4. pod set
```
deployment. service, ingress
```


```
sangbinlee9@k8s-master1:~$ kubectl get pod -A -o wide
NAMESPACE        NAME                                       READY   STATUS    RESTARTS      AGE     IP                NODE          NOMINATED NODE   READINESS GATES
cert-manager     cert-manager-69fd4bc5fc-jfd2g              1/1     Running   3 (8h ago)    2d18h   192.168.194.75    k8s-worker1   <none>           <none>
cert-manager     cert-manager-cainjector-85b6d7fc67-lqjl2   1/1     Running   13 (8h ago)   2d18h   192.168.194.77    k8s-worker1   <none>           <none>
cert-manager     cert-manager-webhook-cfbc49fc8-7p64l       1/1     Running   2 (8h ago)    2d18h   192.168.126.30    k8s-worker2   <none>           <none>
default          cm-acme-http-solver-l7gth                  1/1     Running   0             6h25m   192.168.159.193   k8s-db2       <none>           <none>
default          cm-acme-http-solver-ns7vv                  1/1     Running   0             6h25m   192.168.126.35    k8s-worker2   <none>           <none>
default          dev9-dev-deployment-778485854-79tkj        1/1     Running   2 (8h ago)    2d17h   192.168.243.135   k8s-db1       <none>           <none>
default          dev9-prod-deployment-94767f7b7-2cbgs       1/1     Running   2 (8h ago)    2d17h   192.168.194.76    k8s-worker1   <none>           <none>
default          dev9-prod-deployment-94767f7b7-bsclj       1/1     Running   2 (8h ago)    2d17h   192.168.24.195    k8s-worker4   <none>           <none>
default          dev9-prod-deployment-94767f7b7-qxg78       1/1     Running   2 (8h ago)    2d17h   192.168.126.31    k8s-worker2   <none>           <none>
default          nginx-deployment-6f9664446b-pgwdq          1/1     Running   0             7h47m   192.168.126.34    k8s-worker2   <none>           <none>
default          nginx-deployment-6f9664446b-zj7zf          1/1     Running   0             7h47m   192.168.243.136   k8s-db1       <none>           <none>
ingress-nginx    ingress-nginx-controller-cc68b44bd-g8j55   1/1     Running   9 (8h ago)    2d16h   192.168.126.28    k8s-worker2   <none>           <none>
kube-system      calico-kube-controllers-b45f49df6-j9c2l    1/1     Running   2 (8h ago)    2d18h   192.168.243.134   k8s-db1       <none>           <none>
kube-system      calico-node-2l9sk                          1/1     Running   2 (8h ago)    2d18h   192.168.0.20      k8s-worker1   <none>           <none>
kube-system      calico-node-2zghj                          1/1     Running   2 (8h ago)    2d18h   192.168.0.15      k8s-worker3   <none>           <none>
kube-system      calico-node-jdgd9                          1/1     Running   2 (8h ago)    2d18h   192.168.0.14      k8s-worker4   <none>           <none>
kube-system      calico-node-jszpg                          1/1     Running   2 (8h ago)    2d18h   192.168.0.13      k8s-db2       <none>           <none>
kube-system      calico-node-k5hc2                          1/1     Running   2 (8h ago)    2d18h   192.168.0.12      k8s-db1       <none>           <none>
kube-system      calico-node-mjrr2                          1/1     Running   3 (9h ago)    2d18h   192.168.0.5       k8s-master1   <none>           <none>
kube-system      calico-node-qqp7t                          1/1     Running   2 (8h ago)    2d18h   192.168.0.21      k8s-worker2   <none>           <none>
kube-system      coredns-66bc5c9577-g59wf                   1/1     Running   3 (9h ago)    2d18h   192.168.159.135   k8s-master1   <none>           <none>
kube-system      coredns-66bc5c9577-grr96                   1/1     Running   3 (9h ago)    2d18h   192.168.159.136   k8s-master1   <none>           <none>
kube-system      etcd-k8s-master1                           1/1     Running   13 (9h ago)   2d18h   192.168.0.5       k8s-master1   <none>           <none>
kube-system      kube-apiserver-k8s-master1                 1/1     Running   4 (9h ago)    2d18h   192.168.0.5       k8s-master1   <none>           <none>
kube-system      kube-controller-manager-k8s-master1        1/1     Running   5 (9h ago)    2d18h   192.168.0.5       k8s-master1   <none>           <none>
kube-system      kube-proxy-574kf                           1/1     Running   2 (8h ago)    2d18h   192.168.0.12      k8s-db1       <none>           <none>
kube-system      kube-proxy-cv9fn                           1/1     Running   2 (8h ago)    2d18h   192.168.0.14      k8s-worker4   <none>           <none>
kube-system      kube-proxy-jhhzb                           1/1     Running   2 (8h ago)    2d18h   192.168.0.13      k8s-db2       <none>           <none>
kube-system      kube-proxy-m2dgd                           1/1     Running   3 (9h ago)    2d18h   192.168.0.5       k8s-master1   <none>           <none>
kube-system      kube-proxy-rp7kb                           1/1     Running   2 (8h ago)    2d18h   192.168.0.15      k8s-worker3   <none>           <none>
kube-system      kube-proxy-wgmml                           1/1     Running   2 (8h ago)    2d18h   192.168.0.20      k8s-worker1   <none>           <none>
kube-system      kube-proxy-zlnn8                           1/1     Running   2 (8h ago)    2d18h   192.168.0.21      k8s-worker2   <none>           <none>
kube-system      kube-scheduler-k8s-master1                 1/1     Running   5 (9h ago)    2d18h   192.168.0.5       k8s-master1   <none>           <none>
metallb-system   controller-6599cd9c46-qklts                1/1     Running   10 (8h ago)   2d16h   192.168.126.29    k8s-worker2   <none>           <none>
metallb-system   speaker-4mpzm                              1/1     Running   4 (8h ago)    2d16h   192.168.0.13      k8s-db2       <none>           <none>
metallb-system   speaker-8qscd                              1/1     Running   4 (8h ago)    2d16h   192.168.0.15      k8s-worker3   <none>           <none>
metallb-system   speaker-9z6fm                              1/1     Running   4 (8h ago)    2d16h   192.168.0.12      k8s-db1       <none>           <none>
metallb-system   speaker-gfjff                              1/1     Running   11 (9h ago)   2d16h   192.168.0.5       k8s-master1   <none>           <none>
metallb-system   speaker-gs6vg                              1/1     Running   9 (8h ago)    2d16h   192.168.0.21      k8s-worker2   <none>           <none>
metallb-system   speaker-hcvsg                              1/1     Running   8 (8h ago)    2d16h   192.168.0.20      k8s-worker1   <none>           <none>
metallb-system   speaker-jhk56                              1/1     Running   4 (8h ago)    2d16h   192.168.0.14      k8s-worker4   <none>           <none>

```



5. 도메인
``` 
- dev9.shop
- dev.dev9.shop 
```
6. 공인 아이피
``` 
- 112.144.100.239
```
   
7. iptime 공유기 포트포워드 설정
```
- 외부 : 80 ,  내부 : 192.168.0.240 80
- 외부 : 443 ,  내부 : 192.168.0.240 443
```


 

8. 이메일 
```
sangbinlee9@gmail.com 
```














```

kubectl describe ingress ingress-nginx



 

ingress-nginx    ingress-nginx-controller             LoadBalancer   10.100.120.72    192.168.0.240   80:32029/TCP,443:31041/TCP   2d16h
shop-tls-ingress            nginx    dev9.shop,dev.dev9.shop   192.168.0.240   80, 443   2d15h
shop-tls-secret   False   shop-tls-secret   3h59m


sangbinlee9@k8s-master1:~$ kubectl get ingress


sangbinlee9@k8s-master1:~$ kubectl get certificate shop-tls-secret


iptime 공유기
192.168.0.240F0:92:1C:5E:D8:C0유선연결 (LAN 2) : 자동할당k8s-worker2


```




sangbinlee9@k8s-master1:~$ kubectl get pod -l app=shop-app 
NAME                                   READY   STATUS    RESTARTS        AGE
dev9-dev-deployment-778485854-79tkj    1/1     Running   2 (5h52m ago)   2d15h
dev9-prod-deployment-94767f7b7-2cbgs   1/1     Running   2 (5h56m ago)   2d15h
dev9-prod-deployment-94767f7b7-bsclj   1/1     Running   2 (5h52m ago)   2d15h
dev9-prod-deployment-94767f7b7-qxg78   1/1     Running   2 (5h55m ago)   2d15h
sangbinlee9@k8s-master1:~$


kubectl get pod -l app=shop-app -o wide


kubectl logs -f 






sangbinlee9@k8s-master1:~$ kubectl get pod -l app=shop-app -o wide -A
NAMESPACE   NAME                                   READY   STATUS    RESTARTS        AGE     IP                NODE          NOMINATED NODE   READINESS GATES
default     dev9-dev-deployment-778485854-79tkj    1/1     Running   2 (5h53m ago)   2d15h   192.168.243.135   k8s-db1       <none>           <none>
default     dev9-prod-deployment-94767f7b7-2cbgs   1/1     Running   2 (5h57m ago)   2d15h   192.168.194.76    k8s-worker1   <none>           <none>
default     dev9-prod-deployment-94767f7b7-bsclj   1/1     Running   2 (5h53m ago)   2d15h   192.168.24.195    k8s-worker4   <none>           <none>
default     dev9-prod-deployment-94767f7b7-qxg78   1/1     Running   2 (5h56m ago)   2d15h   192.168.126.31    k8s-worker2   <none>           <none>
sangbinlee9@k8s-master1:~$









```

         sangbinlee9@k8s-worker2:~$ ip a
         1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
            link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
            inet 127.0.0.1/8 scope host lo
               valid_lft forever preferred_lft forever
            inet6 ::1/128 scope host noprefixroute
               valid_lft forever preferred_lft forever
         2: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
            link/ether f0:92:1c:5e:d8:c0 brd ff:ff:ff:ff:ff:ff
            inet 192.168.0.21/24 metric 100 brd 192.168.0.255 scope global dynamic enp0s25
               valid_lft 4882sec preferred_lft 4882sec
            inet6 fe80::f292:1cff:fe5e:d8c0/64 scope link
               valid_lft forever preferred_lft forever
         3: cali78336d4d911@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default
            link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-6d48aecf-06b4-6830-bf80-83231e45e794
            inet6 fe80::ecee:eeff:feee:eeee/64 scope link
               valid_lft forever preferred_lft forever
         4: calid9d69af2f79@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default
            link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-edf67d5d-80d2-5145-3a35-121872b82963
            inet6 fe80::ecee:eeff:feee:eeee/64 scope link
               valid_lft forever preferred_lft forever
         5: calib1ede1ce236@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default
            link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-694cd180-c43c-933d-a258-8d14e687eedf
            inet6 fe80::ecee:eeff:feee:eeee/64 scope link
               valid_lft forever preferred_lft forever
         6: tunl0@NONE: <NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000
            link/ipip 0.0.0.0 brd 0.0.0.0
            inet 192.168.126.0/32 scope global tunl0
               valid_lft forever preferred_lft forever
         9: cali049679c9630@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default
            link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-7440d7b6-84e5-5e6e-ec8a-f41e65ee6946
            inet6 fe80::ecee:eeff:feee:eeee/64 scope link
               valid_lft forever preferred_lft forever
         12: cali2d92205a98e@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default
            link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-e34a72eb-715f-ca4b-25ce-828441cc232a
            inet6 fe80::ecee:eeff:feee:eeee/64 scope link
               valid_lft forever preferred_lft forever
         13: cali7aaf022baec@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1480 qdisc noqueue state UP group default
            link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-2fb6e08f-aa32-7a60-250a-1397ee6bec2e
            inet6 fe80::ecee:eeff:feee:eeee/64 scope link
               valid_lft forever preferred_lft forever
         sangbinlee9@k8s-worker2:~$


```









k8s reset 
```
	노드 아이피가 변경된경우 
	
	
	
	
	
	
	sudo rm -rf /etc/cni/net.d
	
	# IPv4 규칙 초기화
sudo iptables -F && sudo iptables -X
sudo iptables -t nat -F && sudo iptables -t nat -X
sudo iptables -t raw -F && sudo iptables -t raw -X
sudo iptables -t mangle -F && sudo iptables -t mangle -X

# IPv6 규칙 초기화 (선택 사항)
sudo ip6tables -F && sudo ip6tables -X



sudo systemctl daemon-reload
sudo systemctl status kubelet




sangbinlee9@k8s-master1:~$ kubectl get challenge
NAME                                      STATE     DOMAIN          AGE
shop-tls-secret-1-1055312325-3104090271   pending   dev.dev9.shop   111m
shop-tls-secret-1-1055312325-3266165854   pending   dev9.shop       111m
sangbinlee9@k8s-master1:~$



```
 
# Kubernetes 환경 요약

1. 클러스터 구성 및 노드 정보 (1 Master, 6 Worker)
```

클러스터 규모: 7개 노드 (1 Master, 6 Worker)
- Master (Control Plane): 1개 (k8s-master1)
- Worker: 6개 (k8s-db1, k8s-db2, k8s-worker1, k8s-worker2, k8s-worker3, k8s-worker4)

Kubernetes 버전: v1.34.1

운영체제: Ubuntu 24.04.x LTS

컨테이너 런타임: containerd (버전 $2.2.0$)

노드 IP 대역: 192.168.0.x 

```

2. 네트워킹 및 로드 밸런싱
```
CNI (Container Network Interface): Calico (Pod 간 통신 및 네트워크 정책 구현)
Service Load Balancer: MetalLB
- 할당된 IP 주소: $192.168.0.240$ (Layer 2 모드로 예상되며, Ingress Controller Service 등에 사용될 것으로 보입니다.)
```



3. HTTPS/TLS 설정
```
TLS/인증서 관리: cert-manager
ClusterIssuer가 설정되어 있는 것으로 보아, Let's Encrypt와 같은 ACME 서버를 통해 자동으로 인증서를 발급 및 갱신하도록 구성되었을 가능성이 높습니다.
```


4. 배포된 워크로드 (Pod)
```
default 네임스페이스에 3가지 애플리케이션이 배포되어 있습니다:
dev9-dev-deployment (1 Pod)
dev9-prod-deployment (3 Pods)
nginx-deployment (2 Pods)
Ingress Controller: ingress-nginx (ingress-nginx 네임스페이스)가 외부 트래픽을 처리하고 있습니다.

ACME HTTP Solver Pods (cm-acme-http-solver)가 실행 중인 것으로 보아, cert-manager가 인증서 검증(Challenge)을 수행하고 있음을 알 수 있습니다.

```


5. 외부 접근 설정
```
도메인: dev9.shop, dev.dev9.shop
공인 IP: $112.144.100.239
공유기 (iPTIME) 포트 포워딩:
외부 $80 \rightarrow$ 내부 MetalLB IP ($192.168.0.240:80$)
외부 $443 \rightarrow$ 내부 MetalLB IP ($192.168.0.240:443$)
이는 공인 IP ($112.144.100.239$)로 들어오는 HTTP/HTTPS 트래픽이 MetalLB가 할당한 Ingress Controller의 Service IP ($192.168.0.240$)로 전달되도록 구성되었음을 의미합니다.

```

6. 이메일
````
ACME 챌린지 등록 이메일: sangbinlee9@gmail.com 
(cert-manager의 ClusterIssuer/Issuer 설정에 사용되었을 것으로 예상됩니다.)💡 

````



다음 단계에 대한 제안
````
현재 클러스터가 안정적으로 작동 중이며, 주요 인프라 구성요소(CNI, Load Balancer, Ingress, Cert-Manager)가 모두 Running 상태입니다.


 


````

TODO 
```
```





question
```
1. 이는 공인 IP ($112.144.100.239$)로 들어오는 HTTP/HTTPS 트래픽이 MetalLB가 할당한 Ingress Controller의 Service IP ($192.168.0.240$)로 전달되도록 구성되었음을 의미합니다.  -= 이게 안되고 있어  , 원인과 해결책을 찾아줘


1. dev9.shop, dev.dev9.shop  으로   요청시 페이지를 못찻는 이유
2. worker node 인 db1, db2 에 db 설치방법


Ingress Controller IP 확인: MetalLB가 NGINX Ingress Controller 서비스에 112.144.100.239를 할당했는지 확인합니다.


```





```
sangbinlee9@k8s-master1:~$ kubectl get certificate
NAME              READY   SECRET            AGE
shop-tls-secret   False   shop-tls-secret   4h24m
sangbinlee9@k8s-master1:~$

sangbinlee9@k8s-master1:~$ kubectl describe ingress shop-tls-ingress

```

가장 가능성이 높은 원인:

``` 

	DNS 전파 지연 또는 설정 오류: 112.144.100.239로 A 레코드 설정이 완료되지 않았거나 잘못 설정됨.

	Cert-Manager Challenge 실패: DNS 문제로 인해 Let's Encrypt가 도메인 검증을 하지 못해 인증서 발급에 실패함.

	MetalLB IP 할당 실패: Ingress Controller Service의 EXTERNAL-IP가 설정한 공인 IP와 일치하지 않음.

	어떤 단계를 확인하셨을 때 가장 먼저 문제가 발견되었는지 알려주시면, 그 부분에 초점을 맞춰 해결책을 제시해 드리겠습니다.
``` 
 


```

B. Challenge (도메인 검증) 로그 확인
	READY가 False라면, Order나 Challenge 리소스를 확인하여 실패 이유를 파악해야 합니다.

	Bash

	# Order 리소스 확인 (자동 생성됨)
	kubectl get order
	# Challenge 리소스 확인 (자동 생성됨)
	kubectl get challenge -o wide
	challenge 리소스의 State가 valid가 아니라면, DNS 설정 문제나 Ingress Controller 접근 문제로 인해 Let's Encrypt의 검증 요청이 NGINX Pod까지 도달하지 못했다는 의미입니다.

``` 

```

sangbinlee9@k8s-master1:~$ kubectl get svc -n ingress-nginx
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.100.120.72   192.168.0.240   80:32029/TCP,443:31041/TCP   2d23h
ingress-nginx-controller-admission   ClusterIP      10.97.71.225    <none>          443/TCP                      2d23h
sangbinlee9@k8s-master1:~$


# 마스터 노드(k8s-master1)에서 실행
curl -I 192.168.0.240
```





```
api.dev9.shop
3600
IN
A
112.144.100.239
blog.dev9.shop
3600
IN
A
112.144.100.239
board.dev9.shop
3600
IN
A
112.144.100.239
dev.dev9.shop
3600
IN
A
180.231.93.130
dev9.shop
3600
IN
A
180.231.93.130
jenkins.dev9.shop
3600
IN
A
112.144.100.239
k8s.dev9.shop
3600
IN
A
112.144.100.239
location.dev9.shop
3600
IN
A
112.144.100.239
mail.dev9.shop
3600
IN
A
112.144.100.239
portfolio.dev9.shop
3600
IN
A
112.144.100.239
question.dev9.shop
3600
IN
A
112.144.100.239
www.dev9.shop
3600
IN
A
112.144.100.239
```