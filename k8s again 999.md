 

# infra (my home) -
```
1. infra (my home) - lgu+ isp 공인 아이피 180.231.93.130 할당 - dev9.shop, dev.dev9.shop, blog.dev9.shop, portfolio.dev9.shop dns 등록 - sangbinlee9@gmail.com - iptime 공유기 포트포워딩 외부 80, 443 내부 80, 443 192.168.0.240(metallb vip) - 노트북 7대 ubuntu 24.04.2 설치 2. k8s cluster 설치하고 싶어 3. master, worker 공통 설치할 내용 4. master에 설치할 내용 5. worker에 설치할 내용 6. worker 중 db(pv) 만 설치할 내용 - worker 1, 2번으로 db 전용으로 하고 싶어(pv) 7. 요청사항 - 답변은 최대한 짧게하기 - 추측하지 않기 - 답변 하기전에 확인하고 답변하기 - 답변 마지막에 현재까지 진행한 스텝을 step 1 부터 현재 스텝까지 한줄씩정리해주기 - 최신 yaml 버전으로 가이드할것(calico, metallb, cert-manager, nginx ingress) - helm이 필요한 경우 이유설명 확인 받은 후 가이드 - metallb vip 192.168.0.240 ( 외부 80, 443 포트포워딩으로 내부 접속아이피로 사용예정) - yaml ( ClusterIssuer, Certificate, deployment, service, ingress, ... ) 은 최대한 하나로 만들어 주기 - 내가 실행할 명령은 복사 되도록하고 내가 실행하고 결과 값을 주면 그 다음 할 내용을 가이드 해주기 - step by step으로 짧고 간단 명료하게 하나씩 가이드 해주기. - 항상 한글로 답변주기 8. k8s cluster 설치 후 worker 1, 2번으로 db 전용으로 설치하고 싶어 9. nginx 홈페이지 3개 만들어줘 (dev, prod) - dev.dev9.shop, dev9.shop, portfolio.dev9.shop 10. wordpress 블로그 만들어줘 - blog.dev9.shop


```


# Step 1. 노드 공통 사전 준비 (master, worker)
```

# 1) 패키지 업데이트
sudo apt update && sudo apt -y upgrade

# 2) 스왑 비활성화
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# 3) 커널 모듈/네트워크 설정
cat <<'EOF' | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<'EOF' | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

# 4) containerd 설치
sudo apt -y install containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl enable --now containerd

# 5) kubeadm/kubelet/kubectl 설치
sudo apt -y install apt-transport-https ca-certificates curl
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/k8s.gpg
echo "deb [signed-by=/etc/apt/trusted.gpg.d/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt -y install kubeadm kubelet kubectl
sudo systemctl enable --now kubelet


```


# Step 2. 마스터 초기화
```
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 


```


# 
```
root@k8s-master1:/home/sangbinlee9# sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16
I1123 03:44:15.609070   21680 version.go:261] remote version is much newer: v1.34.2; falling back to: stable-1.31
[init] Using Kubernetes version: v1.31.14
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action beforehand using 'kubeadm config images pull'
W1123 03:44:16.056828   21680 checks.go:843] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.10" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8s-master1 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.0.5]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8s-master1 localhost] and IPs [192.168.0.5 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8s-master1 localhost] and IPs [192.168.0.5 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "super-admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests"
[kubelet-check] Waiting for a healthy kubelet at http://127.0.0.1:10248/healthz. This can take up to 4m0s
[kubelet-check] The kubelet is healthy after 501.254736ms
[api-check] Waiting for a healthy API server. This can take up to 4m0s
[api-check] The API server is healthy after 5.002106186s
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node k8s-master1 as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node k8s-master1 as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: gl81o8.1hc63t02zjuqoi00
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.0.5:6443 --token gl81o8.1hc63t02zjuqoi00 \
        --discovery-token-ca-cert-hash sha256:8b9826c086078311e6f025263915c16e53b9661dcfd1e59097ba2c2f4ff1144a
root@k8s-master1:/home/sangbinlee9#
  export KUBECONFIG=/etc/kubernetes/admin.conf
root@k8s-master1:/home/sangbinlee9# exit
exit
sangbinlee9@k8s-master1:~$
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
sangbinlee9@k8s-master1:~$



```


# 
```


W1123 03:44:16.056828   21680 checks.go:843] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.10" as the CRI sandbox image.

```


# 
```

kubeadm join 192.168.0.5:6443 --token gl81o8.1hc63t02zjuqoi00 \
        --discovery-token-ca-cert-hash sha256:8b9826c086078311e6f025263915c16e53b9661dcfd1e59097ba2c2f4ff1144a

```


# 
```

kubectl get nodes



sangbinlee9@k8s-master1:~$ kubectl get nodes
NAME          STATUS     ROLES           AGE    VERSION
k8s-master1   NotReady   control-plane   3m9s   v1.31.14

```


# 
```


sangbinlee9@k8s-master1:~$ kubectl get nodes -o wide
NAME          STATUS     ROLES           AGE     VERSION    INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
k8s-master1   NotReady   control-plane   3m34s   v1.31.14   192.168.0.5   <none>        Ubuntu 24.04.3 LTS   6.8.0-88-generic   containerd://1.7.28
sangbinlee9@k8s-master1:~$


```


# 
```

sangbinlee9@k8s-master1:~$ sudo nano /etc/containerd/config.toml
sangbinlee9@k8s-master1:~$ sudo nano /etc/containerd/config.toml
sangbinlee9@k8s-master1:~$ sudo systemctl daemon-reload
sudo systemctl restart containerd
[sudo] password for sangbinlee9:
Sorry, try again.
[sudo] password for sangbinlee9:
sangbinlee9@k8s-master1:~$ sudo systemctl restart kubelet
sangbinlee9@k8s-master1:~$ sudo systemctl status containerd



```


# Step 3. Calico 설치 (네트워크)
마스터에서 Calico를 적용합니다.
```

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: calico-system
---
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
  namespace: calico-system
spec:
  kubernetesProvider: Kubernetes
  cni:
    type: Calico
  calicoNetwork:
    ipPools:
      - cidr: 10.244.0.0/16
        encapsulation: VXLANCrossSubnet
        natOutgoing: Enabled
        nodeSelector: all()
---
apiVersion: operator.tigera.io/v1
kind: APIServer
metadata:
  name: default
  namespace: calico-system
spec: {}
EOF


```


# 
```

curl https://raw.githubusercontent.com/projectcalico/calico/v3.31.2/manifests/calico.yaml -O


kubectl apply -f calico.yaml


Calico는 기본적으로 eBPF dataplane을 활성화하려고 시도합니다.

하지만 일부 CPU(특히 구형 AMD64, 또는 가상화 환경의 제한된 CPU)에서는 eBPF 기능을 지원하지 않아 Pod가 CrashLoopBackOff에 빠집니다.

그래서 ebpf-bootstrap init 컨테이너가 실패 → calico-node 전체가 시작되지 못하는 상태입니다.




```


# 
```
kubectl delete -f calico.yaml

curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

kubectl apply -f calico.yaml


```


# Step 4. 워커 조인
```



```


# Step 5. MetalLB 설치 및 VIP 설정
VIP은 192.168.0.240만 사용합니다.
```



kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml


 
sangbinlee9@k8s-master1:~$ kubectl apply -f vip.yaml
ipaddresspool.metallb.io/vip-pool created
l2advertisement.metallb.io/vip-adv created
sangbinlee9@k8s-master1:~$


kubectl -n metallb-system get pods





sangbinlee9@k8s-master1:~$ kubectl -n metallb-system get pods
NAME                         READY   STATUS    RESTARTS   AGE
controller-78fb49f59-v2xf4   1/1     Running   0          3m18s
speaker-4shph                1/1     Running   0          3m18s
speaker-6kt7r                1/1     Running   0          3m18s
speaker-96wv6                1/1     Running   0          3m18s
speaker-bpjv6                1/1     Running   0          3m18s
speaker-cld6h                1/1     Running   0          3m18s
speaker-s7zc5                1/1     Running   0          3m18s
speaker-ttd8b                1/1     Running   0          3m18s






```


# Step 6. NGINX Ingress 컨트롤러 설치
```






kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.0/deploy/static/provider/aws/deploy.yaml









kubectl -n ingress-nginx get svc ingress-nginx

kubectl get all -n ingress-nginx







sangbinlee9@k8s-master1:~$ kubectl get all -n ingress-nginx
NAME                                            READY   STATUS    RESTARTS   AGE
pod/ingress-nginx-controller-58968596dd-mjglx   1/1     Running   0          2m47s

NAME                                         TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                      AGE
service/ingress-nginx-controller             LoadBalancer   10.110.128.184   192.168.0.240   80:30479/TCP,443:32321/TCP   2m47s
service/ingress-nginx-controller-admission   ClusterIP      10.106.168.82    <none>          443/TCP                      2m47s

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ingress-nginx-controller   1/1     1            1           2m47s

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/ingress-nginx-controller-58968596dd   1         1         1       2m47s
sangbinlee9@k8s-master1:~$












```


# 
```


sangbinlee9@k8s-master1:~$ kubectl -n ingress-nginx logs ingress-nginx-controller-58968596dd-mjglx
-------------------------------------------------------------------------------
NGINX Ingress controller
  Release:       v1.14.0
  Build:         52c0a83ac9bc72e9ce1b9fe4f2d6dcc8854516a8
  Repository:    https://github.com/kubernetes/ingress-nginx
  nginx version: nginx/1.27.1

-------------------------------------------------------------------------------

W1123 09:17:35.267766       7 client_config.go:667] Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.
I1123 09:17:35.267937       7 main.go:205] "Creating API client" host="https://10.96.0.1:443"
I1123 09:17:35.272154       7 main.go:248] "Running in Kubernetes cluster" major="1" minor="31" git="v1.31.14" state="clean" commit="5e00b99bac504844579ec74886b6cc5c9611ca19" platform="linux/amd64"
I1123 09:17:35.396528       7 main.go:101] "SSL fake certificate created" file="/etc/ingress-controller/ssl/default-fake-certificate.pem"
I1123 09:17:35.406081       7 ssl.go:535] "loading tls certificate" path="/usr/local/certificates/cert" key="/usr/local/certificates/key"
I1123 09:17:35.412985       7 nginx.go:273] "Starting NGINX Ingress controller"
I1123 09:17:35.415758       7 event.go:377] Event(v1.ObjectReference{Kind:"ConfigMap", Namespace:"ingress-nginx", Name:"ingress-nginx-controller", UID:"1543221c-666e-40fb-bd4d-6f0fdda8a204", APIVersion:"v1", ResourceVersion:"28235", FieldPath:""}): type: 'Normal' reason: 'CREATE' ConfigMap ingress-nginx/ingress-nginx-controller
I1123 09:17:36.616075       7 nginx.go:319] "Starting NGINX process"
I1123 09:17:36.616285       7 leaderelection.go:257] attempting to acquire leader lease ingress-nginx/ingress-nginx-leader...
I1123 09:17:36.616741       7 nginx.go:339] "Starting validation webhook" address=":8443" certPath="/usr/local/certificates/cert" keyPath="/usr/local/certificates/key"
I1123 09:17:36.617259       7 controller.go:214] "Configuration changes detected, backend reload required"
I1123 09:17:36.621941       7 leaderelection.go:271] successfully acquired lease ingress-nginx/ingress-nginx-leader
I1123 09:17:36.621989       7 status.go:85] "New leader elected" identity="ingress-nginx-controller-58968596dd-mjglx"
I1123 09:17:36.672096       7 controller.go:228] "Backend successfully reloaded"
I1123 09:17:36.672178       7 controller.go:240] "Initial sync, sleeping for 1 second"
I1123 09:17:36.672231       7 event.go:377] Event(v1.ObjectReference{Kind:"Pod", Namespace:"ingress-nginx", Name:"ingress-nginx-controller-58968596dd-mjglx", UID:"391258ee-1894-4abd-804e-3581e49e077d", APIVersion:"v1", ResourceVersion:"28335", FieldPath:""}): type: 'Normal' reason: 'RELOAD' NGINX reload triggered due to a change in configuration
sangbinlee9@k8s-master1:~$



```


# 
```
sangbinlee9@k8s-master1:~$ kubectl get all -n ingress-nginx
NAME                                            READY   STATUS    RESTARTS   AGE
pod/ingress-nginx-controller-58968596dd-mjglx   1/1     Running   0          2m47s

NAME                                         TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                      AGE
service/ingress-nginx-controller             LoadBalancer   10.110.128.184   192.168.0.240   80:30479/TCP,443:32321/TCP   2m47s
service/ingress-nginx-controller-admission   ClusterIP      10.106.168.82    <none>          443/TCP                      2m47s

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ingress-nginx-controller   1/1     1            1           2m47s

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/ingress-nginx-controller-58968596dd   1         1         1       2m47s



```


# Step 7. cert-manager 설치 방식 확인 요청
```
Step 7. Helm 설치 및 cert-manager 배포


```


# Step 7. Helm 설치 및 cert-manager 배포
```

# 1) Helm 설치
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 2) cert-manager CRD 및 Helm repo 추가
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.3/cert-manager.crds.yaml
helm repo add jetstack https://charts.jetstack.io
helm repo update

# 3) cert-manager 설치
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.15.3


```


# cert-manager 설치 확인
```
kubectl -n cert-manager get pods


sangbinlee9@k8s-master1:~$ kubectl -n cert-manager get pods
NAME                                     READY   STATUS    RESTARTS   AGE
cert-manager-7b9875fbcc-c6g2v            1/1     Running   0          42s
cert-manager-cainjector-948d47c6-nhvms   1/1     Running   0          42s
cert-manager-webhook-78bd84d46b-kbfnn    1/1     Running   0          42s
sangbinlee9@k8s-master1:~$


```


# Step 8. ClusterIssuer + NGINX 홈페이지(dev, prod, portfolio) + WordPress 블로그(blog) 통합 YAML
```

cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: sangbinlee9@gmail.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-dev
spec:
  replicas: 1
  selector: {matchLabels: {app: nginx-dev}}
  template:
    metadata: {labels: {app: nginx-dev}}
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports: [{containerPort: 80}]
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-dev
spec:
  selector: {app: nginx-dev}
  ports: [{port: 80, targetPort: 80}]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-prod
spec:
  replicas: 1
  selector: {matchLabels: {app: nginx-prod}}
  template:
    metadata: {labels: {app: nginx-prod}}
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports: [{containerPort: 80}]
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-prod
spec:
  selector: {app: nginx-prod}
  ports: [{port: 80, targetPort: 80}]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-portfolio
spec:
  replicas: 1
  selector: {matchLabels: {app: nginx-portfolio}}
  template:
    metadata: {labels: {app: nginx-portfolio}}
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports: [{containerPort: 80}]
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-portfolio
spec:
  selector: {app: nginx-portfolio}
  ports: [{port: 80, targetPort: 80}]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: 1
  selector: {matchLabels: {app: wordpress}}
  template:
    metadata: {labels: {app: wordpress}}
    spec:
      nodeSelector: {kubernetes.io/hostname: k8s-worker1}
      containers:
      - name: wordpress
        image: wordpress:6.6
        env:
        - name: WORDPRESS_DB_HOST
          value: mysql-service
        - name: WORDPRESS_DB_USER
          value: wpuser
        - name: WORDPRESS_DB_PASSWORD
          value: wppass
        - name: WORDPRESS_DB_NAME
          value: wpdb
        ports: [{containerPort: 80}]
---
apiVersion: v1
kind: Service
metadata:
  name: wordpress
spec:
  selector: {app: wordpress}
  ports: [{port: 80, targetPort: 80}]
---
################## ingress
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  ingressClassName: nginx
  rules:
  - host: dev.dev9.shop
    http:
      paths:
      - path: /
        pathType: Prefix
        backend: {service: {name: nginx-dev, port: {number: 80}}}
  - host: dev9.shop
    http:
      paths:
      - path: /
        pathType: Prefix
        backend: {service: {name: nginx-prod, port: {number: 80}}}
  - host: portfolio.dev9.shop
    http:
      paths:
      - path: /
        pathType: Prefix
        backend: {service: {name: nginx-portfolio, port: {number: 80}}}
  - host: blog.dev9.shop
    http:
      paths:
      - path: /
        pathType: Prefix
        backend: {service: {name: wordpress, port: {number: 80}}}
  tls:
  - hosts:
    - dev.dev9.shop
    - dev9.shop
    - portfolio.dev9.shop
    - blog.dev9.shop
    secretName: web-tls
EOF


```


# 적용 후 확인:
```

...

EOF
clusterissuer.cert-manager.io/letsencrypt-prod created
deployment.apps/nginx-dev created
service/nginx-dev created
deployment.apps/nginx-prod created
service/nginx-prod created
deployment.apps/nginx-portfolio created
service/nginx-portfolio created
deployment.apps/wordpress created
service/wordpress created
ingress.networking.k8s.io/web-ingress created



```


# 
```

kubectl get ingress
kubectl describe ingress web-ingress





sangbinlee9@k8s-master1:~$ kubectl get ingress
kubectl describe ingress web-ingress
NAME          CLASS   HOSTS                                                     ADDRESS         PORTS     AGE
web-ingress   nginx   dev.dev9.shop,dev9.shop,portfolio.dev9.shop + 1 more...   192.168.0.240   80, 443   22s
Name:             web-ingress
Labels:           <none>
Namespace:        default
Address:          192.168.0.240
Ingress Class:    nginx
Default backend:  <default>
TLS:
  web-tls terminates dev.dev9.shop,dev9.shop,portfolio.dev9.shop,blog.dev9.shop
Rules:
  Host                 Path  Backends
  ----                 ----  --------
  dev.dev9.shop
                       /   nginx-dev:80 (10.244.126.7:80)
  dev9.shop
                       /   nginx-prod:80 (10.244.194.67:80)
  portfolio.dev9.shop
                       /   nginx-portfolio:80 (10.244.126.8:80)
  blog.dev9.shop
                       /   wordpress:80 ()
Annotations:           cert-manager.io/cluster-issuer: letsencrypt-prod
Events:
  Type    Reason             Age                From                       Message
  ----    ------             ----               ----                       -------
  Normal  CreateCertificate  22s                cert-manager-ingress-shim  Successfully created Certificate "web-tls"
  Normal  Sync               18s (x2 over 22s)  nginx-ingress-controller   Scheduled for sync
sangbinlee9@k8s-master1:~$


```


# Step 9. DB(PV) 전용 노드 설정 및 MySQL 배포
```
worker1, worker2를 DB 전용으로 지정합니다. 마스터에서 실행:


sangbinlee9@k8s-master1:~$ kubectl label node k8s-worker1 role=db
kubectl label node k8s-worker2 role=db
node/k8s-worker1 labeled
node/k8s-worker2 labeled
sangbinlee9@k8s-master1:~$



```


# MySQL StatefulSet + PVC + Service를 배포합니다:
```

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  accessModes: [ReadWriteOnce]
  resources:
    requests:
      storage: 10Gi
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: mysql
  replicas: 1
  selector:
    matchLabels: {app: mysql}
  template:
    metadata: {labels: {app: mysql}}
    spec:
      nodeSelector: {role: db}
      containers:
      - name: mysql
        image: mysql:8.0
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: rootpass
        - name: MYSQL_DATABASE
          value: wpdb
        - name: MYSQL_USER
          value: wpuser
        - name: MYSQL_PASSWORD
          value: wppass
        ports: [{containerPort: 3306}]
        volumeMounts:
        - name: mysql-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-storage
        persistentVolumeClaim:
          claimName: mysql-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
spec:
  selector: {app: mysql}
  ports:
    - port: 3306
      targetPort: 3306
EOF


```


# 확인
```


EOF
persistentvolumeclaim/mysql-pvc created
statefulset.apps/mysql created
service/mysql-service created
sangbinlee9@k8s-master1:~$




kubectl get pods -l app=mysql
kubectl get svc mysql-service



sangbinlee9@k8s-master1:~$ kubectl get pods -l app=mysql
kubectl get svc mysql-service
NAME      READY   STATUS    RESTARTS   AGE
mysql-0   0/1     Pending   0          17s
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
mysql-service   ClusterIP   10.104.191.177   <none>        3306/TCP   17s
sangbinlee9@k8s-master1:~$









```




# mysql-service를 LoadBalancer 타입으로 변경
```







apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  namespace: default
spec:
  type: LoadBalancer
  selector:
    app: mysql
  ports:
    - port: 3306
      targetPort: 3306
      protocol: TCP




kubectl apply -f mysql-service-lb.yaml
kubectl get svc -n default




default          mysql-service                                        LoadBalancer   10.104.191.177   <pending>       3306:32074/TCP                 6d


```


# 
```


sangbinlee9@k8s-master1:~$ kubectl get ipaddresspool -n metallb-system
NAME       AUTO ASSIGN   AVOID BUGGY IPS   ADDRESSES
vip-pool   true          false             ["192.168.0.240-192.168.0.240"]
sangbinlee9@k8s-master1:~$





sangbinlee9@k8s-master1:~$ kubectl apply -f ipaddresspool.yaml






sangbinlee9@k8s-master1:~$ kubectl get svc -A
NAMESPACE        NAME                                                 TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                        AGE
cert-manager     cert-manager                                         ClusterIP      10.110.158.204   <none>          9402/TCP                       6d4h
cert-manager     cert-manager-webhook                                 ClusterIP      10.110.231.65    <none>          443/TCP                        6d4h
default          kubernetes                                           ClusterIP      10.96.0.1        <none>          443/TCP                        6d10h
default          mysql-service                                        LoadBalancer   10.104.191.177   192.168.0.241   3306:32074/TCP                 6d4h
default          nginx-dev                                            ClusterIP      10.108.24.118    <none>          80/TCP                         6d4h
default          nginx-portfolio                                      ClusterIP      10.98.44.143     <none>          80/TCP                         6d4h
default          nginx-prod                                           ClusterIP      10.100.102.25    <none>          80/TCP                         6d4h
default          wordpress                                            ClusterIP      10.106.76.241    <none>          80/TCP                         6d4h
ingress-nginx    ingress-nginx-controller                             LoadBalancer   10.110.128.184   192.168.0.240   80:30479/TCP,443:32321/TCP     6d4h




4. 권장 아키텍처
Ingress는 웹 트래픽(HTTP/HTTPS)에 적합합니다.

DB 서비스(MySQL)는 LoadBalancer로 외부 노출하기보다는:

내부 ClusterIP 유지

운영자가 필요할 때만 VPN/Port-forward로 접근

혹은 Bastion 서버를 통해서만 접근




2. MySQL 접근 제어
방화벽/네트워크 정책: 외부에서 무분별하게 접속하지 못하도록 특정 IP만 허용하세요.

Calico 네트워크 정책을 활용해 접근 제어 가능.

사용자 계정 관리: root 계정은 외부 노출하지 말고, 별도의 제한된 권한 계정을 만들어 사용하세요.

TLS/SSL 암호화: MySQL 연결을 암호화하여 데이터 유출을 방지하세요.




```













# Step 9-1. PV 생성 (worker1, worker2 전용)
```

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv-worker1
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /data/mysql
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - k8s-worker1
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv-worker2
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /data/mysql
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - k8s-worker2
EOF


```


# Step 9-2. PVC 확인
```


EOF
persistentvolume/mysql-pv-worker1 created
persistentvolume/mysql-pv-worker2 created



kubectl get pv
kubectl get pvc




sangbinlee9@k8s-master1:~$ kubectl get pv
kubectl get pvc
NAME               CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM               STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
mysql-pv-worker1   10Gi       RWO            Retain           Bound       default/mysql-pvc                  <unset>                          25s
mysql-pv-worker2   10Gi       RWO            Retain           Available                                      <unset>                          25s
NAME        STATUS   VOLUME             CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
mysql-pvc   Bound    mysql-pv-worker1   10Gi       RWO                           <unset>                 2m39s
sangbinlee9@k8s-master1:~$







```


# Step 10. WordPress 연결 확인
```




kubectl get pods -l app=wordpress
kubectl logs -l app=wordpress





sangbinlee9@k8s-master1:~$ kubectl get pods -l app=wordpress
kubectl logs -l app=wordpress
NAME                         READY   STATUS    RESTARTS   AGE
wordpress-5b76b86cc7-92v2t   1/1     Running   0          7m29s
138.197.191.87 - - [23/Nov/2025:09:31:11 +0000] "GET /login.action HTTP/1.1" 500 2719 "-" "Mozilla/5.0 (l9scan/2.0.033313e23393e2133323e2038313; +https://leakix.net)"
138.197.191.87 - - [23/Nov/2025:09:31:12 +0000] "GET /_all_dbs HTTP/1.1" 500 438 "-" "Mozilla/5.0 (l9scan/2.0.033313e23393e2133323e2038313; +https://leakix.net)"
138.197.191.87 - - [23/Nov/2025:09:31:12 +0000] "GET /.DS_Store HTTP/1.1" 500 2719 "-" "Mozilla/5.0 (l9scan/2.0.033313e23393e2133323e2038313; +https://leakix.net)"
138.197.191.87 - - [23/Nov/2025:09:31:13 +0000] "GET /.env HTTP/1.1" 500 2719 "-" "Mozilla/5.0 (l9scan/2.0.033313e23393e2133323e2038313; +https://leakix.net)"
138.197.191.87 - - [23/Nov/2025:09:31:14 +0000] "GET /.git/config HTTP/1.1" 500 2719 "-" "Mozilla/5.0 (l9scan/2.0.033313e23393e2133323e2038313; +https://leakix.net)"
138.197.191.87 - - [23/Nov/2025:09:31:15 +0000] "GET /s/033313e23393e2133323e2038313/_/;/META-INF/maven/com.atlassian.jira/jira-webapp-dist/pom.properties HTTP/1.1" 500 2719 "-" "Mozilla/5.0 (l9scan/2.0.033313e23393e2133323e2038313; +https://leakix.net)"
138.197.191.87 - - [23/Nov/2025:09:31:16 +0000] "GET /config.json HTTP/1.1" 500 2719 "-" "Mozilla/5.0 (l9scan/2.0.033313e23393e2133323e2038313; +https://leakix.net)"
138.197.191.87 - - [23/Nov/2025:09:31:17 +0000] "GET /telescope/requests HTTP/1.1" 500 2719 "-" "Mozilla/5.0 (l9scan/2.0.033313e23393e2133323e2038313; +https://leakix.net)"
138.197.191.87 - - [23/Nov/2025:09:31:18 +0000] "GET /info.php HTTP/1.1" 500 2719 "-" "Mozilla/5.0 (l9scan/2.0.033313e23393e2133323e2038313; +https://leakix.net)"
138.197.191.87 - - [23/Nov/2025:09:31:19 +0000] "GET /?rest_route=/wp/v2/users/ HTTP/1.1" 500 2719 "-" "Mozilla/5.0 (l9scan/2.0.033313e23393e2133323e2038313; +https://leakix.net)"
sangbinlee9@k8s-master1:~$



```


# https://blog.dev9.shop 연결 성공
```



```


# https://dev9.shop/ 성공
```



```


# https://dev.dev9.shop/ 성공
```



```


# https://portfolio.dev9.shop/ 성공
```



```


# Step 11. Prometheus + Grafana 설치 - 운영/모니터링
```

# 1) prometheus-community repo 추가
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 2) kube-prometheus-stack 설치 (Prometheus + Grafana + Alertmanager 포함)
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace





----------------------------------------



sangbinlee9@k8s-master1:~$ # 1) prometheus-community repo 추가
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 2) kube-prometheus-stack 설치 (Prometheus + Grafana + Alertmanager 포함)
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
"prometheus-community" has been added to your repositories
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "jetstack" chart repository
...Successfully got an update from the "prometheus-community" chart repository
Update Complete. ⎈Happy Helming!⎈
NAME: monitoring
LAST DEPLOYED: Sun Nov 23 09:46:02 2025
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=monitoring"

Get Grafana 'admin' user password by running:

  kubectl --namespace monitoring get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo

Access Grafana local instance:

  export POD_NAME=$(kubectl --namespace monitoring get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=monitoring" -oname)
  kubectl --namespace monitoring port-forward $POD_NAME 3000

Get your grafana admin user password by running:

  kubectl get secret --namespace monitoring -l app.kubernetes.io/component=admin-secret -o jsonpath="{.items[0].data.admin-password}" | base64 --decode ; echo


Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.
sangbinlee9@k8s-master1:~$













```


# 확인
kubectl -n monitoring get pods

watch kubectl -n monitoring get pods


```
Every 2.0s: kubectl -n monitoring get pods                                                                                             k8s-master1: Sun Nov 23 09:48:40 2025

NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-monitoring-kube-prometheus-alertmanager-0   2/2     Running   0          117s
monitoring-grafana-7d49f8544f-mjx9x                      3/3     Running   0          2m7s
monitoring-kube-prometheus-operator-9b6cb6694-d4kxt      1/1     Running   0          2m7s
monitoring-kube-state-metrics-7984768b56-4rmh6           1/1     Running   0          2m7s
monitoring-prometheus-node-exporter-6nqkc                1/1     Running   0          2m7s
monitoring-prometheus-node-exporter-8nj5j                1/1     Running   0          2m7s
monitoring-prometheus-node-exporter-8zth8                1/1     Running   0          2m7s
monitoring-prometheus-node-exporter-j2s68                1/1     Running   0          2m7s
monitoring-prometheus-node-exporter-n5d4t                1/1     Running   0          2m7s
monitoring-prometheus-node-exporter-vvxbs                1/1     Running   0          2m7s
monitoring-prometheus-node-exporter-wd5n6                1/1     Running   0          2m7s
prometheus-monitoring-kube-prometheus-prometheus-0       2/2     Running   0          117s


```






# Step 12. Grafana 접속
Grafana는 기본적으로 ClusterIP로 배포됩니다. 외부 접속을 위해 Ingress를 추가합니다:

```

sangbinlee9@k8s-master1:~$ cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana-ingress
  namespace: monitoring
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  ingressClassName: nginx
  rules:
  - host: grafana.dev9.shop
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: monitoring-grafana
            port:
              number: 80
  tls:
  - hosts:
    - grafana.dev9.shop
    secretName: grafana-tls
EOF
ingress.networking.k8s.io/grafana-ingress created
sangbinlee9@k8s-master1:~$



```


# 확인:
```


sangbinlee9@k8s-master1:~$ kubectl get ingress -n monitoring
NAME                        CLASS    HOSTS               ADDRESS         PORTS     AGE
cm-acme-http-solver-b55w2   <none>   grafana.dev9.shop   192.168.0.240   80        86s
grafana-ingress             nginx    grafana.dev9.shop   192.168.0.240   80, 443   91s
sangbinlee9@k8s-master1:~$




브라우저에서 https://grafana.dev9.shop 접속 → 기본 계정은 admin / prom-operator 입니다.

kubectl -n monitoring get secret monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d


pb1mbn8TVBqfLEIgIK9ZD1bdILRlCfuwZHot84Ot



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








# 백업 전략, 또는 자동 배포(CI/CD) 같은 운영 레벨
```



```


# 보안 강화, 
```



```


#  CI/CD?
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