
 




kubectl drain k8s-worker3 --ignore-daemonsets --delete-emptydir-data
kubectl drain k8s-worker4 --ignore-daemonsets --delete-emptydir-data
kubectl drain k8s-workerdb1 --ignore-daemonsets --delete-emptydir-data
kubectl drain k8s-workerdb2 --ignore-daemonsets --delete-emptydir-data



sangbinlee9@k8s-master1:~$ kubectl get no
NAME            STATUS                        ROLES           AGE     VERSION
k8s-master1     Ready                         control-plane   5d14h   v1.34.1
k8s-worker1     Ready                         <none>          5d13h   v1.34.1
k8s-worker2     Ready                         <none>          5d13h   v1.34.1

k8s-worker3     NotReady,SchedulingDisabled   <none>          12h     v1.34.1
k8s-worker4     NotReady,SchedulingDisabled   <none>          12h     v1.34.1
k8s-workerdb1   NotReady,SchedulingDisabled   <none>          12h     v1.34.1
k8s-workerdb2   NotReady,SchedulingDisabled   <none>          12h     v1.34.1




905503C4M$
905503C4M$
AD@1A7P28E


kubectl delete node k8s-worker3
kubectl delete node k8s-worker4
kubectl delete node k8s-workerdb1
kubectl delete node k8s-workerdb2





#################################
#################################
#################################
#################################
#################################
#################################  worker node 초기화

#################################






sudo kubeadm reset
sudo kubeadm reset --force


rm -rf $HOME/.kube



sudo rm -rf /etc/cni/net.d


# CNI 설정 파일 삭제
sudo rm -rf /etc/cni/net.d/*

# Kubernetes 설정 파일 및 데이터 디렉토리 삭제 (kubeadm reset에서 처리되지 않은 경우)
sudo rm -rf /etc/kubernetes/*
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf /var/lib/cni/*


sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t raw -F && sudo iptables -t mangle -F


#################################  worker node 정상확인
root@k8s-workerdb2:/home/sangbinlee9# sudo systemctl status containerd
● containerd.service - containerd container runtime
     Loaded: loaded (/usr/local/lib/systemd/system/containerd.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-11-06 23:04:18 UTC; 6min ago
       Docs: https://containerd.io
    Process: 11207 ExecStartPre=/sbin/modprobe overlay (code=exited, status=0/SUCCESS)
   Main PID: 11208 (containerd)
      Tasks: 8
     Memory: 18.7M (peak: 20.2M)
        CPU: 1.567s
     CGroup: /system.slice/containerd.service
             └─11208 /usr/local/bin/containerd

Nov 06 23:04:18 k8s-workerdb2 containerd[11208]: time="2025-11-06T23:04:18.623277607Z" level=error msg="failed t>
Nov 06 23:04:18 k8s-workerdb2 containerd[11208]: time="2025-11-06T23:04:18.649105128Z" level=info msg="Start sub>
Nov 06 23:04:18 k8s-workerdb2 containerd[11208]: time="2025-11-06T23:04:18.649556177Z" level=info msg="Start rec>
Nov 06 23:04:18 k8s-workerdb2 containerd[11208]: time="2025-11-06T23:04:18.649809559Z" level=info msg=serving...>
Nov 06 23:04:18 k8s-workerdb2 containerd[11208]: time="2025-11-06T23:04:18.651356651Z" level=info msg=serving...>
Nov 06 23:04:18 k8s-workerdb2 containerd[11208]: time="2025-11-06T23:04:18.868410214Z" level=info msg="Start eve>
Nov 06 23:04:18 k8s-workerdb2 containerd[11208]: time="2025-11-06T23:04:18.868506367Z" level=info msg="Start cni>
Nov 06 23:04:18 k8s-workerdb2 containerd[11208]: time="2025-11-06T23:04:18.868537085Z" level=info msg="Start str>
Nov 06 23:04:18 k8s-workerdb2 containerd[11208]: time="2025-11-06T23:04:18.868710913Z" level=info msg="container>
Nov 06 23:04:18 k8s-workerdb2 systemd[1]: Started containerd.service - containerd container runtime.
lines 1-22/22 (END)

#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################
#################################







sudo systemctl restart kubelet




kubeadm join 192.168.0.5:6443 --token 2ja4zz.2ars98vbiztpq9rd --discovery-token-ca-cert-hash sha256:c0dccb8afe669926c9d17c4f7767d99f7ce8c1c090a1e023b03c21a0cbd6ba59







#################################
################################# join
#################################

# 새 토큰 생성
sudo kubeadm token create
# 생성된 토큰을 사용하여 Join 명령어 출력 (토큰과 해시를 직접 입력해야 할 수도 있음)
# 또는
sudo kubeadm token create --print-join-command


sudo kubeadm token create --print-join-command

#################################
#################################
#################################












1. Check your OS version
	lsb_release -a

2. Swap configuration 
	sudo swapoff -a
	free -h

	sudo sed -i.bak '/swap/ s/^/#/' /etc/fstab
	cat /etc/fstab | grep swap



#################################
#################################
#################################

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# 필요한 sysctl 파라미터를 설정하면, 재부팅 후에도 값이 유지된다.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1





net.ipv4.ip_forward                 = 1
EOF

# 재부팅하지 않고 sysctl 파라미터 적용하기
sudo sysctl --system








#################################
#################################
#################################








3. Installing a container runtime


	Installing containerd
				wget https://github.com/containerd/containerd/releases/download/v2.1.4/containerd-2.1.4-linux-amd64.tar.gz
				tar Cxzvf /usr/local containerd-2.1.4-linux-amd64.tar.gz


	systemd 
				sudo mkdir -p /usr/local/lib/systemd/system
				wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service -O /usr/local/lib/systemd/system/containerd.service
				systemctl daemon-reload
				systemctl enable --now containerd

	Installing runc
				wget https://github.com/opencontainers/runc/releases/download/v1.3.2/runc.amd64
				install -m 755 runc.amd64 /usr/local/sbin/runc


	Installing CNI plugins
				wget https://github.com/containernetworking/plugins/releases/download/v1.8.0/cni-plugins-linux-amd64-v1.8.0.tgz
				mkdir -p /opt/cni/bin
				tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.8.0.tgz



 





Initializing your control-plane node 
	sudo kubeadm init --pod-network-cidr=192.168.0.0/16




 Installing a Pod network add-on
 
	 Install Calico

			Manifest
					 curl https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/calico.yaml -O
					 kubectl apply -f calico.yaml
					 
					 kubectl get nodes
					kubectl get pods -n kube-system

 
 metallb
 
	

	kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml 
 kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml
 
 
	sangbinlee9@k8s-master1:~$ cat  metallb-config.yaml
	apiVersion: metallb.io/v1beta1
	kind: IPAddressPool
	metadata:
	  name: default-pool
	  namespace: metallb-system
	spec:
	  addresses:
	  - 192.168.0.240-192.168.0.250
	---
	apiVersion: metallb.io/v1beta1
	kind: L2Advertisement
	metadata:
	  name: default
	  namespace: metallb-system
	spec:
	  ipAddressPools:
	  - default-pool

	 
	sangbinlee9@k8s-master1:~$ kubectl apply -f metallb-config.yaml
	ipaddresspool.metallb.io/default-pool created
	l2advertisement.metallb.io/default created

 
 Adding more control plane nodes
 
 
 
 Adding worker nodes
	 
	 
	Then you can join any number of worker nodes by running the following on each as root:

	kubeadm join 192.168.0.5:6443 --token uq8ng5.mqlovhs2yjq6j5ma \
			--discovery-token-ca-cert-hash sha256:c077c687303062b62f4eb47f55ff903b8b8cc290e3a6      
			
			
	kubeadm token create --print-join-command
				
				 

NGINX Ingress Controller
					
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.3/deploy/static/provider/cloud/deploy.yaml				
	
		
		kubectl get pods -n ingress-nginx
		kubectl get svc -n ingress-nginx



cert-manager
	https://cert-manager.io/docs/installation/
	
		
		kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.1/cert-manager.yaml
		
		kubectl get pods -n cert-manager



Let's Encrypt ClusterIssuer 생성

	clusterissuer.yaml
	
			
		apiVersion: cert-manager.io/v1
		kind: ClusterIssuer
		metadata:
		  name: letsencrypt-http
		spec:
		  acme:
			server: https://acme-v2.api.letsencrypt.org/directory
			email: sangbinlee9@gmail.com
			privateKeySecretRef:
			  name: letsencrypt-http-private-key
			solvers:
			- http01:
				ingress:
				  class: nginx
	
	
	kubectl apply -f clusterissuer.yaml



NGINX 웹 서버 배포 + Service 생성
	HTTPS Ingress 리소스 생성
	
	
	# 1. cert-manager 설치 (CRDs 및 컨트롤러)
# 참고: 최신 버전은 공식 문서에서 확인 가능
# 이 블록은 별도 적용 권장: https://cert-manager.io/docs/installation/
# 아래는 cert-manager 설치 생략 (보통 별도 적용)

# 2. ClusterIssuer (Let's Encrypt HTTP-01)
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
::
  name: letsencrypt-http
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: sangbinlee9@gmail.com  # ← 본인의 이메일로 변경
    privateKeySecretRef:
      name: letsencrypt-http-private-key
    solvers:
    - http01:
        ingress:
          class: nginx

---

# 3. NGINX 웹 서버 Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-web
  template:
    metadata:
      labels:
        app: nginx-web
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80

---

# 4. NGINX 웹 서버 Service
apiVersion: v1
kind: Service
metadata:
  name: nginx-web
spec:
  selector:
    app: nginx-web
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

---

# 5. Ingress 리소스 (HTTPS + 자동 인증서 발급)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-http
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - dev9.shop  # ← 실제 도메인으로 변경
    secretName: nginx-web-tls
  rules:
  - host: dev9.shop  # ← 실제 도메인으로 변경
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-web
            port:
              number: 80




 
sangbinlee9@k8s-master1:~$ kubectl apply -f nginx-https.yaml
clusterissuer.cert-manager.io/letsencrypt-http created
deployment.apps/nginx-web unchanged
service/nginx-web unchanged
ingress.networking.k8s.io/nginx-ingress unchanged
sangbinlee9@k8s-master1:~$




kubectl delete certificate nginx-web-tls
kubectl delete certificaterequest nginx-web-tls-1
kubectl delete clusterissuer letsencrypt-http
kubectl delete ingress nginx-ingress
kubectl delete secret letsencrypt-http-private-key
kubectl delete secret nginx-web-tls




kubectl get certificate  
kubectl get certificaterequest  
kubectl get clusterissuer  
kubectl get ingress  
kubectl get secret  
kubectl get secret  




192.168.0.20B0:5A:DA:3E:69:AF유선연결 (AX2004M/LAN 4) : 자동할당
k8s-worker1

1192.168.0.21F0:92:1C:5E:D8:C0유선연결 (AX2004M/LAN 2) : 자동할당


k8s-worker2




k8s-master1


70:5D:CC:FD:A3:D2



os 


나의 첫번째 앱 : 모든 영역 추천 유투부  플레이어




시스템 구축
1.  os    설치  Ubuntu 24.04.3 LTS
	확인
		lsb_release -a
		
		
2. h/w확인
	df -h		
	free -h
					
				# Swap 즉시 비활성화
				sudo swapoff -a
				# 재부팅 시에도 Swap 비활성화를 유지하도록 /etc/fstab 파일에서 Swap 라인을 주석 처리
				sudo sed -i '/ swap / s/^/#/' /etc/fstab	
		
3. Timezone) 변경 명령어
		date
	
		변경
			sudo timedatectl set-timezone Asia/Seoul
		확인
			timedatectl

#######################################
sudo apt update && sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl gnupg


#######################################
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# 필요한 sysctl 파라미터를 설정하면, 재부팅 후에도 값이 유지된다.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 재부팅하지 않고 sysctl 파라미터 적용하기
sudo sysctl --system



####################################### Containerd


https://github.com/containerd/containerd/blob/main/docs/getting-started.md


sudo mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml



#######################################'
sudo containerd config default | sudo tee /etc/containerd/config.toml
# SystemdCgroup을 true로 설정 (kubelet 기본 설정과 일치시키기 위함)
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml






SystemdCgroup = true  이게 없어서 수동으로 추가 하는게 맞냐?



# containerd 재시작
sudo systemctl restart containerd
sudo systemctl enable containerd 
sudo systemctl status containerd



#######################################


# `/etc/apt/keyrings` 디렉터리가 존재하지 않으면, curl 명령 전에 생성해야 한다. 아래 참고사항을 읽어본다.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg 


# 이 명령어는 /etc/apt/sources.list.d/kubernetes.list 에 있는 기존 구성을 덮어쓴다.
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list




sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl



sudo systemctl enable --now kubelet





####################################### cgroup 드라이버 구성 


 
 


#######################################   calico
curl https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/calico.yaml -O

kubectl apply -f calico.yaml




#######################################  kubeadm join


sangbinlee9@k8s-worker1:~$ sudo su
[sudo] password for sangbinlee9:
Sorry, try again.
[sudo] password for sangbinlee9:
root@k8s-worker1:/home/sangbinlee9# kubeadm join 192.168.0.5:6443 --token ovenmz.4elr3mggpnwml03g \
--discovery-token-ca-cert-hash sha256:c0dccb8afe669926c9d17c4f7767d99f7ce8c1c090a1e023b03c21a0cbd6ba59
[preflight] Running pre-flight checks
[preflight] Reading configuration from the "kubeadm-config" ConfigMap in namespace "kube-system"...
[preflight] Use 'kubeadm init phase upload-config kubeadm --config your-config-file' to re-upload it.
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/instance-config.yaml"
[patches] Applied patch of type "application/strategic-merge-patch+json" to target "kubeletconfiguration"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-check] Waiting for a healthy kubelet at http://127.0.0.1:10248/healthz. This can take up to 4m0s
[kubelet-check] The kubelet is healthy after 1.002310481s
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.









####################################### MetalLB


# 1. MetalLB 설치 매니페스트 적용 (v0.15.2 버전)
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml



kubectl get pods -n metallb-system





####################################### # metallb-config.yaml


# metallb-config.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  namespace: metallb-system
  name: my-ip-pool
spec:
  addresses:
  - 192.168.1.240-192.168.1.250 # <-- **사용 가능한 IP 범위로 변경하세요**
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  namespace: metallb-system
  name: my-l2-advertisement
spec:
  ipAddressPools:
  - my-ip-pool



#######################################



kubectl apply -f metallb-config.yaml



####################################### Nginx Ingress Controller 및 Cert-Manager 설치




kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.3/deploy/static/provider/cloud/deploy.yaml



kubectl get pods --namespace=ingress-nginx
kubectl get service ingress-nginx-controller --namespace=ingress-nginx




#######################################



sangbinlee9@k8s-master1:~$ kubectl get service ingress-nginx-controller --namespace=ingress-nginx
NAME                       TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller   LoadBalancer   10.108.56.190   192.168.0.240   80:31492/TCP,443:31469/TCP   8m5s







#######################################  cert-manager



kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.1/cert-manager.yaml



kubectl get pods --namespace cert-manager





#######################################  cert-setup.yaml

# ClusterIssuer: 인증서 발급자 정의 (Let's Encrypt Staging)
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    # 사용자님의 이메일 주소로 변경하세요.
    email: sangbinlee9@gmail.com 
    # 테스트 환경 (Staging) 서버 주소
    server: https://acme-staging-v02.api.letsencrypt.org/directory 
    privateKeySecretRef:
      # ACME 계정 키를 저장할 Secret 이름 (자동 생성됨)
      name: letsencrypt-staging-key 
    solvers:
    - http01:
        ingress:
          # 사용하고 있는 Ingress Controller의 클래스 이름
          class: nginx 
---
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
    name: letsencrypt-staging
    kind: ClusterIssuer
  # 인증서를 발급받을 도메인 목록
  dnsNames:
  - dev9.shop
  - dev.dev9.shop
  # - www.dev9.shop # 필요한 경우 추가

#######################################

kubectl apply -f cert-setup.yaml



#######################################


#######################################  포트포워드 설정

80
192.168.0.240

443
192.168.0.240

#######################################



# 1. Certificate 삭제 (Order 및 CertificateRequest도 함께 삭제됨)
kubectl delete certificate dev9-shop-cert -n default

# 2. 잠시 기다린 후 (약 30초) Certificate YAML을 다시 적용합니다.
kubectl apply -f cert-setup.yaml 
# 또는 Ingress Annotation을 사용했다면 Ingress YAML을 다시 적용합니다.
#######################################

kubectl get certificate dev9-shop-cert -n default


kubectl get secret dev9-shop-tls -n default

#######################################


# 1. Certificate 삭제 (Order 및 CertificateRequest도 함께 삭제됨)
kubectl delete certificate dev9-shop-cert -n default

# 2. 잠시 기다린 후 (약 30초) Certificate YAML을 다시 적용합니다.
kubectl apply -f cert-setup.yaml 
# 또는 Ingress Annotation을 사용했다면 Ingress YAML을 다시 적용합니다.



ㅇ#######################################


kubectl describe certificate dev9-shop-cert -n default





#######################################   nginx-all-in-one.yaml




# 1. NGINX Deployment: NGINX Pod들을 정의하고 관리합니다.
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-web
spec:
  replicas: 2 # 2개의 Pod을 유지합니다.
  selector:
    matchLabels:
      app: nginx-web
  template:
    metadata:
      labels:
        app: nginx-web # Service가 찾을 Selector입니다.
    spec:
      containers:
      - name: nginx
        image: nginx:latest # 공식 NGINX Docker 이미지를 사용합니다.
        ports:
        - containerPort: 80 # NGINX의 기본 포트입니다.

---
# 2. NGINX Service: Deployment의 Pod들로 트래픽을 라우팅합니다.
apiVersion: v1
kind: Service
metadata:
  name: nginx-web-service # ⭐️ 이 이름이 Ingress의 'backend.service.name'으로 사용됩니다.
spec:
  selector:
    app: nginx-web # Deployment의 Pod들을 바라봅니다.
  ports:
    - protocol: TCP
      port: 80 # Service의 포트 (Ingress가 연결할 포트)
      targetPort: 80 # Pod의 컨테이너 포트

---
# 3. NGINX Ingress: 외부 트래픽을 Service로 연결하고 TLS/SSL을 적용합니다.
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  namespace: default
  # 💡 cert-manager를 사용해 TLS 인증서를 자동 발급하려면 아래 주석을 해제하세요.
  # annotations:
  #   cert-manager.io/cluster-issuer: "letsencrypt-prod" 
spec:
  ingressClassName: nginx # 👈 설치한 Ingress Controller의 클래스 이름 (대부분 nginx)
  tls:
  - hosts:
    - dev9.shop # 👈 실제 사용할 도메인으로 변경하세요.
    secretName: dev9-shop-tls # 👈 발급된 인증서 Secret 이름으로 변경하세요.
  rules:
  - host: dev9.shop # 👈 실제 사용할 도메인으로 변경하세요.
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-web-service # 👈 위에서 정의한 Service 이름입니다.
            port:
              number: 80 # Service의 포트 번호입니다.














#######################################   nginx-all-in-one.yaml





sangbinlee9@k8s-master1:~$ kubectl apply -f nginx-all-in-one.yaml
deployment.apps/nginx-deployment created
service/nginx-web-service created
ingress.networking.k8s.io/nginx-ingress created
sangbinlee9@k8s-master1:~$ kubectl get deploy,svc,ing












#######################################

kubectl get deploy,svc,ing


#######################################



nginx.ingress.kubernetes.io/force-ssl-redirect: "true"







#######################################


wordpress
wordpress
wordpress
wordpress
wordpress
wordpress
wordpress
wordpress
wordpress
wordpress


#######################################  Installing Helm
https://helm.sh/docs/intro/install/#from-script



# 1. 설치 스크립트 다운로드
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# 2. 실행 권한 부여
chmod 700 get_helm.sh

# 3. 스크립트 실행하여 Helm 설치
./get_helm.sh



helm version




#######################################




#######################################  결제용 디비   PostgreSQL

쇼핑몰
유투브 플레이어 - 나이별, 취미별, 관심별, 월드 top 100, 실시간 top 100, 국내 탑100, 사용자별 추천 top 100, 

유익한 정보(건강, 여행, ... ) 
돈버는 정보 (top 100) 
건강 정보 (top 100)
쇼핑 top 100 - 
주말 장보기 top 100

데이터를 모은다.
- 광고 비즈니스를 한다(가성비 좋은거, 비싼거, 싼거 )






####################################### db 설치 

PersistentVolumeClaim (PVC) 


및 PersistentVolume (PV): 워드프레스 데이터와 MySQL 데이터를 영구적으로 저장할 스토리지를 설정합니다.

핵심 데이터 (계정, 결제): PostgreSQL로 안정성을 확보

캐싱/세션 (빠른 임시 데이터): Redis (키-값 저장소)로 초고속 처리

유연한 데이터 (로그, 피드): MongoDB로 빠른 개발 및 확장성 확보






애플리케이션	데이터 특성	추천 DB	추천 이유	K8s 배포 방식
1. 쇼핑몰	정확성, 무결성 (결제, 주문, 재고)	PostgreSQL	강력한 ACID 트랜잭션으로 돈, 재고의 정확성을 보장합니다.	StatefulSet으로 안정적인 영구 저장소(PVC) 확보
2. 개인 블로그	유연성, 빠른 조회 (게시글, 댓글)	MongoDB	스키마가 유연하여 콘텐츠 구조 변경이 쉽고, JSON 형태의 데이터 관리에 최적입니다.	StatefulSet 또는 Deployment + 외부 DB
3. 실시간 채팅	초고속 응답, 휘발성 (메시지, 세션, 캐시)	Redis	인메모리 데이터베이스로 가장 빠른 읽기/쓰기 속도를 제공합니다.	StatefulSet 또는 Deployment (클러스터 모드)







1. 관계형 DB 표준: PostgreSQL (쇼핑몰에 필수)
쇼핑몰의 주문, 결제, 재고는 1원도 틀리면 안 되며, 여러 테이블 간의 관계가 명확해야 합니다. PostgreSQL은 이 요구사항을 완벽하게 만족합니다.

쇼핑몰 활용:

사용자 및 주문 데이터: 사용자 정보, 주문 내역, 결제 트랜잭션 관리.

재고 관리: 재고 수량의 정확한 증가/감소 처리를 트랜잭션으로 보장.

K8s 배포 팁
PostgreSQL은 상태가 있는(Stateful) 애플리케이션이므로, Kubernetes에서 StatefulSet 리소스를 사용하여 배포해야 합니다. 이는 데이터가 저장되는 **PersistentVolumeClaim (PVC)**이 안정적으로 유지되도록 보장합니다.

2. 유연한 NoSQL: MongoDB (블로그에 적합)
블로그나 CMS(콘텐츠 관리 시스템)는 게시글이나 댓글의 구조가 언제든지 변할 수 있고, 관계형 DB의 복잡한 JOIN 없이 문서 단위로 빠르게 데이터를 읽어오는 것이 중요합니다.

블로그 활용:

게시글/댓글 저장: 게시글 전체 내용(본문, 태그, 첨부파일 정보 등)을 하나의 JSON(BSON) 문서로 저장하여 조회 속도 향상.

메타데이터 관리: 사용자의 설정이나 앱의 환경 설정 등 구조가 비정형적인 데이터 저장.

K8s 배포 팁
MongoDB도 상태를 유지해야 하므로, StatefulSet을 사용하여 배포하며, 필요에 따라 복제본(Replica Set)을 구성하여 고가용성(HA)을 확보하는 것이 좋습니다.

3. 인메모리 NoSQL: Redis (채팅, 캐싱에 최적)
실시간 채팅 메시지를 영구적으로 저장하는 용도보다는, 실시간 세션 관리, 임시 메시지 저장, 모든 앱의 캐싱 처리에 Redis가 핵심적으로 사용됩니다.

실시간 채팅 활용:

세션/토큰 관리: 로그인한 사용자 세션, 인증 토큰을 저장하여 빠르게 인증 처리.

메시지 큐: 실시간으로 들어오는 짧은 메시지를 일시적으로 저장/전달하는 큐 역할.

모든 앱의 캐싱:

PostgreSQL이나 MongoDB에서 자주 조회되는 데이터를 Redis에 저장하여 DB 부하를 줄이고 응답 속도를 극대화합니다 (예: 쇼핑몰의 인기 상품 목록, 블로그의 최근 게시글 목록).

K8s 배포 팁
Redis 역시 StatefulSet으로 배포하여 데이터 영속성을 유지하거나, 클러스터 모드로 배포하여 수평 확장을 쉽게 할 수 있습니다. 캐싱 용도로만 사용할 경우 데이터를 잃어도 상관없기 때문에 Deployment로 구성할 수도 있습니다.






#######################################   



워드프레스 설치를 위해 이전에 말씀드린 Helm 설치부터 시작해서, 쇼핑몰, 블로그, 채팅 서비스 구축에 필요한 핵심 데이터베이스들인 PostgreSQL, MongoDB, Redis까지 Helm을 이용해 하나씩 Kubernetes에 배포해 보겠습니다.




#######################################

# Bitnami Repository 추가
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update





#######################################



helm install dev9-wordpress bitnami/wordpress \
  --set mariadb.auth.rootPassword=wordpressk8stjfcldhksfy! \
  --set wordpressPassword=wordpressk8stjfcldhksfy! \
  --set service.type=LoadBalancer


kubectl get svc dev9-wordpress











#######################################

helm install dev9-wordpress bitnami/wordpress \
  --set mariadb.auth.rootPassword=k8sWordPressRootPassword \
  --set mariadb.auth.database=k8sWordPressDb \
  --set mariadb.auth.username=k8sWordPressUser \
  --set mariadb.auth.password=k8sWordPressPwd \
  --set wordpressUsername=wpAdmin \
  --set wordpressPassword=wpAdminPwd \
  --set wordpressEmail=sangbinlee9@gmail.com \
  --namespace wordpress --create-namespace


kubectl get all -n wordpress
kubectl get pvc -n wordpress

 

#######################################

# 현재 배포된 헬름 릴리즈 제거
helm uninstall dev9-wordpress --namespace wordpress


#######################################


**PVC (Persistent Volume Claim)**가 생성되어 DB 데이터가 클러스터 노드의 디스크에 지속적으로 저장되도록 설정됩니다. 로컬 환경에서는 StorageClass가 올바르게 구성되어 있어야 PV가 생성됩니다.


StorageClass가 올바르게 구성되어 있는지 확인 하는 명령어 



#######################################  Local Path Provisioner 설치 (권장)



# 1. Local Path Provisioner 배포 파일 다운로드 및 적용
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.26/deploy/local-path-storage.yaml


# 2. StorageClass 생성 확인
kubectl get sc

# 3. Provisioner Pod 구동 확인 (namespace는 'local-path-storage')
kubectl get pod -n local-path-storage

kubectl -n local-path-storage get pod
## 오류발생시 로그확인
kubectl -n local-path-storage logs -f -l app=local-path-provisioner

#######################################



helm install my-wordpress bitnami/wordpress \
  --set mariadb.auth.rootPassword=k8sWordPressRootPassword \
  --set wordpressPassword=k8sWordPressPwd \
  --set service.type=LoadBalancer \
  --namespace wordpress-ns --create-namespace


helm upgrade my-wordpress bitnami/wordpress \
  --namespace wordpress-ns \
  --set service.type=ClusterIP \
  --set ingress.enabled=true \
  --set ingress.hostname=blog.dev9.shop \
  --set ingress.ingressClassName=nginx \
  --set wordpressScheme=http \
  --reuse-values


#######################################



No resources found
sangbinlee9@k8s-master1:~$ kubectl get pvkubectl get pv^C
sangbinlee9@k8s-master1:~$ ^C
sangbinlee9@k8s-master1:~$ ^C
sangbinlee9@k8s-master1:~$ ^C
sangbinlee9@k8s-master1:~$ helm install my-wordpress bitnami/wordpress \
  --set mariadb.auth.rootPassword=k8sWordPressRootPassword \
  --set wordpressPassword=k8sWordPressPwd \
  --set service.type=LoadBalancer \
  --namespace wordpress-ns --create-namespace
I1103 23:18:53.038844  144795 warnings.go:110] "Warning: spec.SessionAffinity is ignored for headless services"
NAME: my-wordpress
LAST DEPLOYED: Mon Nov  3 23:18:52 2025
NAMESPACE: wordpress-ns
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: wordpress
CHART VERSION: 27.1.3
APP VERSION: 6.8.3

⚠ WARNING: Since August 28th, 2025, only a limited subset of images/charts are available for free.
    Subscribe to Bitnami Secure Images to receive continued support and security updates.
    More info at https://bitnami.com and https://github.com/bitnami/containers/issues/83267

** Please be patient while the chart is being deployed **

Your WordPress site can be accessed through the following DNS name from within your cluster:

    my-wordpress.wordpress-ns.svc.cluster.local (port 80)

To access your WordPress site from outside the cluster follow the steps below:

1. Get the WordPress URL by running these commands:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace wordpress-ns -w my-wordpress'

   export SERVICE_IP=$(kubectl get svc --namespace wordpress-ns my-wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
   echo "WordPress URL: http://$SERVICE_IP/"
   echo "WordPress Admin URL: http://$SERVICE_IP/admin"

2. Open a browser and access WordPress using the obtained URL.

3. Login with the following credentials below to see your blog:

  echo Username: user
  echo Password: $(kubectl get secret --namespace wordpress-ns my-wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d)
WARNING: Rolling tag detected (bitnami/wordpress:latest), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html
WARNING: Rolling tag detected (bitnami/apache-exporter:latest), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html
WARNING: Rolling tag detected (bitnami/os-shell:latest), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html

WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for production. For production installations, please set the following values according to your workload needs:
  - resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
sangbinlee9@k8s-master1:~$







#######################################
#######################################
#######################################
#######################################
#######################################
#######################################
#######################################
#######################################
#######################################
#######################################









#######################################   wordpress helm 설치 

PersistentVolumeClaim (PVC) 및 PersistentVolume (PV): 워드프레스 데이터와 MySQL 데이터를 영구적으로 저장할 스토리지를 설정합니다.


#######################################


















4. 집에 노트북 3대에 Ubuntu 24.04.3 LTS 설치 후 용 k8s 치cluster 설치 스텝 

Kubeadm을 사용한 K8s 설치 기본 단계 (Master/Worker 공통)





sangbinlee9@k8s-master1:~$ history
    1  df
    2  df -h
    3  free
    4  free -h
    5  df -h
    6  lsb_release -a
    7  lsb_release
    8  clear
    9  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
   10  sudo fdisk -l | grep '^Disk'
   11  df -h
   12  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
   13  ll /
   14  ll /sw*
   15  free -h
   16  df -h
   17  date
   18  df -h
   19  free -h
   20  df
   21  df
   22  free -h
   23  ll /sw*
   24  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
   25  sudo fdisk -l | grep '^Disk'
   26  lsb_release
   27  lsb_release -a
   28  history
sangbinlee9@k8s-master1:~$











lg u+ isp 로 iptime 공유기로 포트포워딩으로 집에서 dev9.shop  sangbinlee9@gmail.com 으로 노트북에 우분투 설치하고  k8s  를 하고  calico, metallb, nginx ingress, cert-manager, let's encrypt nginx 홈페이지 만들고 있는데 사이트에 연결할 수 없다고 나와 점검해줄래?


공인 아이피 180.231.93.149
도메인 dev9.shop
iptime 공유기 :
1. 포트포워딩 외부(80, 443) -> 192.168.0.241 내부(80, 443)

[외부 브라우저]  →  [도메인 DNS A레코드]  →  [공인 IP (ipTIME)]  
→  [ipTIME 공유기 포트포워딩]  →  [노트북 K8s 노드: 80/443]  
→  [MetalLB EXTERNAL-IP]  →  [Ingress Controller]  →  [Service / Pod]


NAME                                 TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.98.72.101   192.168.0.241   80:30284/TCP,443:32206/TCP   26h


2. DHCP 서버 설정 192.168.0.2 ~ 192.168.0.254
이메일 sangbinlee9@gmail.com


labtop 3대 - master 1대, workder 2대
os : ubuntu 24.04.2 LTS 

swapoff



containerd-2.1.4
systemd
runc v1.3.2
cni v1.8.0


Kubernetes v1.34.

kubeadm, kubelet, kubectl

kubeadm init --pod-network-cidr=192.168.0.0/16

calico v3.31.0
metallb v0.15.2
ingress nginx controller v1.13.3
cert-manager v1.19.1

kubeadm join

ClusterIssuer (Let's Encrypt HTTP-01)


https nginx 홈페이지 만들려고 하는데 

secret 부분이 안되는거 같아 .   
원인 파악하고 https로 nginx 홈페이지 만들자





MetalLB

	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.3/deploy/static/provider/cloud/deploy.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.3/deploy/static/provider/baremetal/deploy.yaml 
 

kubectl get svc -n ingress-nginx
kubectl get pods -n ingress-nginx

    kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.3/deploy/static/provider/baremetal/deploy.yaml







$ kubectl get pods --namespace cert-manager

NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-5c6866597-zw7kh               1/1     Running   0          2m
cert-manager-cainjector-577f6d9fd7-tr77l   1/1     Running   0          2m
cert-manager-webhook-787858fcdb-nlzsq      1/1     Running   0          2m






kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.1/cert-manager.yaml





































설치 순서 요약
단계	구성 요소	설명
1️⃣	nginx ingress controller	외부에서 클러스터로 들어오는 HTTP/HTTPS 요청을 처리할 진입점
2️⃣	cert-manager	인증서 발급을 자동화하는 컨트롤러
3️⃣	ClusterIssuer	cert-manager가 사용할 인증서 발급자 설정
4️⃣	nginx 서비스 + Ingress	실제 서비스와 도메인을 연결하고, 인증서 요청 트리거
5️⃣	인증 확인	인증서 발급 성공 여부 및 HTTPS 접속 테스트






워드프레스 비밀번호	

k8stjfcldhksfy!
k8stjfcldhksfy!





워드프레스 관리자 ID			dev9k8sadmin
워드프레스 비밀번호			dev9k8stjfcldhksfy!
DB 이름									dev9k8sdbwordpress
DB 사용자								dev9k8sdbuser
DB 비밀번호							dev9k8sdbk8stjfcldhksfy!
PVC 용량	5Gi
도메인	blog.dev9.shop




Kubernetes 클러스터


Kubernetes 클러스터 구축 Step-by-Step
✅ 1단계: 사전 준비
모든 노드에서 swapoff 실행 및 /etc/fstab에서 swap 항목 주석 처리

고정 IP 설정 (예: master: 192.168.0.5, worker1: 192.168.0.20, worker2: 192.168.0.21)

공유기에서 포트 포워딩: 6443, 10250, 30000~32767 등

✅ 2단계: containerd 설치
bash
sudo apt update
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
✅ 3단계: Kubernetes 패키지 설치
bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
✅ 4단계: 마스터 노드 초기화
bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
✅ 5단계: kubectl 설정
bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
✅ 6단계: CNI 네트워크 플러그인 설치
Flannel:

bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
또는 Calico:

bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
✅ 7단계: 워커 노드 클러스터 참여
마스터 노드에서 출력된 kubeadm join 명령어를 워커 노드에서 실행

✅ 8단계: 클러스터 확인
bash
kubectl get nodes
이제 클러스터가 완성되면 Helm, Ingress Controller, 모니터링 도구(Grafana, Prometheus) 등을 추가로 설치할 수 있습니다. 원하시면 kubeadm init 출력 예시나 join 명령어 구성도 도와드릴게요!






setup k8s

 
sudo systemctl stop ufw
sudo systemctl disable ufw
sudo ufw disable

 
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

 


wget https://github.com/containerd/containerd/releases/download/v2.1.4/containerd-2.1.4-linux-amd64.tar.gz
tar Cxzvf /usr/local  containerd-2.1.4-linux-amd64.tar.gz


sudo mkdir -p /usr/local/lib/systemd/system
sudo curl -o /usr/local/lib/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
systemctl daemon-reload
systemctl enable --now containerd



wget  https://github.com/opencontainers/runc/releases/download/v1.3.2/runc.amd64
wget  https://github.com/opencontainers/runc/releases/download/v1.3.2/runc.sha256sum
sha256sum -c runc.sha256sum 2>&1 | grep runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc
runc --version





wget  https://github.com/containernetworking/plugins/releases/download/v1.8.0/cni-plugins-linux-amd64-v1.8.0.tgz
sha256sum cni-plugins-linux-amd64-v1.8.0.tgz

sha256:ab3bda535f9d90766cccc90d3dddb5482003dd744d7f22bcf98186bf8eea8be6

wget https://github.com/containernetworking/plugins/releases/download/v1.8.0/cni-plugins-linux-amd64-v1.8.0.tgz.sha256



mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.8.0.tgz


###################################
###################################
###################################
###################################
고부하 대비 설정

Ingress-Nginx controller replica 3 이상

PodDisruptionBudget 적용 → 유지보수 시도에도 가용성 확보

MetalLB / NodePort → 사설 IP 환경에서 로드밸런싱 가능

HTTP/2 + Keep-Alive → 대량 동시 접속 최적화dddddddddddddddddddddddddddddddddddddddddddddd







노드 스펙: CPU 8~16코어, 메모리 16~64GB 이상



목표
	1. 10만명 동시 접속가능 nginx 홈페이지
	2. 10만명 동시 접속 부하 테스트
	
자원
	1. 도메인 portfolio.dev9.store
	2. 이메일 sangbinlee9@gmail.com
	3. iptime 공유기
	4. os : ubuntu 24.04.2 LTS
	5. 마스터 노드 3개 
	6. 워커 노드 4개
주의사항
	1. 설치 명령어 node 위치 표시 - master인지 worker 인지 반드시 표시
	
설치 순서
	1. ubuntu 24.04.2 LTS
		- swap  설정
		- 방화벽 설정  ufw
			체크 포인트: 외부에서 접속할 MetalLB IP를 허용해야 함
			
	2. containerd 설치
		- systemd cgroup 드라이버 확인 - 이건 확인 필요함.
		containerd config dump | grep SystemdCgroup
		
	3. k8s   설치 
		- kubeadm, kubelet, kubectl    - master, worker 모두 설치 
		- kubeadm init → 마스터 초기화
		- kubeadm join → 워커 노드 추가
		
		
	4. CNI 설치(Calico)	
		- 정책 
		
		❗ 확인 포인트: Calico 설치 후 Pod-to-Pod 통신 확인
		❗ 정책 적용 전 Pod 배포 시 연결 안 될 수 있음
		
		
	5. MetalLB 설치
		- IP 풀 설정
		❗ 확인 포인트: IP 풀은 외부에서 접근 가능한 내부 IP 범위로 설정
		- Layer2 모드 또는 BGP 모드
		
		
	6. Ingress Controller 설치
		- nginx-ingress 설치
		- LoadBalancer 서비스 연결
		
		LoadBalancer 서비스 → MetalLB IP와 연결 확인 필요
		
	7. nginx Deployment
		- kubectl create deployment nginx-web --image=nginx:latest
		- kubectl expose deployment nginx-web --port=80 --type=LoadBalancer	
		
		❗ Pod 수 최소 5~10개 이상, HPA 전까지는 수동 설정 필요
		
		
	8. Horizontal Pod Autoscaler
		-kubectl autoscale deployment nginx-web --cpu-percent=50 --min=5 --max=50
		
		❗ CPU, 메모리 리소스 요청/제한(resource request/limit) 반드시 설정
		
	9. HTML 콘텐츠 배포
		- ConfigMap 또는 PVC로 정적 파일 제공		
		❗ 정적 파일 많은 경우 PVC(Volume)로 배포 추천
		
		
	10. TLS 인증서 → cert-manager + Let’s Encrypt 자동 발급
	❗ cert-manager 설치 후 Issuer/ClusterIssuer 생성 필요
	
	11. 공유기 - 포트포워딩 설정 - MetalLB
	
	포트 80,443 TCP 외부 → MetalLB IP 포워딩
	
	12.	모니터링 & 로깅
		- Prometheus + Grafana
		- Loki/ELK
	❗ Prometheus/Grafana 먼저 설치 후 Loki/ELK 설치 추천
 



Pod 수

	nginx Pod 10~20개 이상으로 수평 확장 (HPA 사용)

	HPA(Horizontal Pod Autoscaler)로 CPU/메모리 기준 자동 스케일링


LoadBalancer & 외부 트래픽 처리

	MetalLB (bare-metal)

	외부 IP 풀 충분히 확보

	L2 또는 BGP 모드 설정

Ingress Controller

	nginx-ingress 또는 Traefik 추천

	SSL Termination, 호스트 기반 라우팅 가능

	여러 워커 노드로 트래픽 분산




3️⃣ nginx 설정 최적화

	Worker & Connection 설정

	worker_processes auto;
	worker_connections 10240;  # 최대 동시 연결 수
	multi_accept on;


	Keepalive & Buffer

	keepalive_timeout 조정 (5~15s)

	client_body_buffer_size, client_max_body_size 조정

	캐싱

	HTML, 이미지, CSS 등 정적 자원 캐싱



필요하면 CDN 연계

4️⃣ Pod Autoscaling

	CPU 50~70% 이상 시 자동 scale-out

	kubectl autoscale deployment nginx-web --cpu-percent=50 --min=5 --max=50

5️⃣ 모니터링 & 로깅

Prometheus + Grafana: Pod/Node CPU, 메모리, 네트워크 모니터링

ELK 또는 Loki: nginx access/error 로그 수집

장애 대비: Node/Pod health check, readinessProbe/livenessProbe

6️⃣ 트래픽 시뮬레이션

hey 또는 locust 같은 부하 테스트 툴로 10만 명 동시 접속 시 성능 검증

필요 시 Horizontal Pod Autoscaler + Node Autoscaler 조합

💡 결론:

단일 Pod nginx → 절대 10만 명 감당 불가

멀티 워커 노드 + HPA + LoadBalancer + Ingress 구조 필요

nginx 설정 + 캐싱 + 모니터링 필수

원하면 제가 지금까지 논의한 내용을 반영해서 10만 명 동시 접속 가능한 nginx 홈페이지용 Kubernetes 아키텍처 + 설치/배포 스크립트까지 설계해 드릴 수 있습니다.

그대로 진행할까요?



############ k8s cluster (쿠버네티스 1.34)

uname -r 


lsb_release -a

timedatectl
sudo timedatectl set-timezone Asia/Seoul
timedatectl
date


############  1. 스왑 구성



sudo swapoff -a


/etc/fstab

systemd.swap


	sudo sed -i.bak '/swap/ s/^/#/' /etc/fstab
	cat /etc/fstab | grep swap


############ 2. 컨테이너 런타임 설치
############ 2-1. 컨테이너 런타임 설치

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# 필요한 sysctl 파라미터를 설정하면, 재부팅 후에도 값이 유지된다.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 재부팅하지 않고 sysctl 파라미터 적용하기
sudo sysctl --system



############ 2-2. cgroup 드라이버




cgroupDriver: systemd

 

############ 2-3 컨테이너 런타임 
Step 1: Installing containerd


	wget https://github.com/containerd/containerd/releases/download/v2.2.0/containerd-2.2.0-linux-amd64.tar.gz
	tar Cxzvf /usr/local containerd-2.2.0-linux-amd64.tar.gz



systemd

	sudo mkdir -p /usr/local/lib/systemd/system
	sudo curl -o /usr/local/lib/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
	systemctl daemon-reload
	systemctl enable --now containerd

Step 2: Installing runc
	wget	https://github.com/opencontainers/runc/releases/download/v1.3.3/runc.amd64
	 install -m 755 runc.amd64 /usr/local/sbin/runc
	runc --version

Step 3: Installing CNI plugins
	wget https://github.com/containernetworking/plugins/releases/download/v1.8.0/cni-plugins-linux-amd64-v1.8.0.tgz
	mkdir -p /opt/cni/bin
	tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.8.0.tgz



############ 2-4 Config Guide   /etc/containerd/config.toml


systemd cgroup 드라이버 환경 설정하기 
	mkdir -p /etc/containerd
	containerd config default > /etc/containerd/config.toml
	cat /etc/containerd/config.toml | grep SystemdCgroup
	sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

  cat /etc/containerd/config.toml | grep sandbox

		
	sudo systemctl restart containerd
	sudo systemctl status containerd
	
	
	
 

############  
############  
############  
############  
############  
############  
############  
############  
############  
############  










############ 3. kubeadm, kubelet 및 kubectl 설치

sudo apt-get update
# apt-transport-https는 더미 패키지일 수 있다. 그렇다면 해당 패키지를 건너뛸 수 있다
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# `/etc/apt/keyrings` 디렉터리가 존재하지 않으면, curl 명령 전에 생성해야 한다. 아래 참고사항을 읽어본다.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg


# 이 명령어는 /etc/apt/sources.list.d/kubernetes.list 에 있는 기존 구성을 덮어쓴다.
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet




############  kubeadm init (마스터 노드)


sudo su
sudo kubeadm reset

sudo kubeadm init --pod-network-cidr=192.168.0.0/16


############ 재설치
############ 재설치
############ 재설치
############ 재설치
############ 재설치
############ 재설치
############ 재설치
############ 재설치
############ 재설치
			현재 진행 상태:

					Step 1: kubeadm reset을 통해 기존 설정을 제거.

					Step 2: 새로운 IP를 사용하여 kubeadm init을 재실행.

					Step 3: kubectl 사용을 위한 환경 설정.

					Step 4: CNI (Pod Network Add-on) 재설치.  - calico

					Step 5: 워커 노드 재연결 (선택 사항).









############  Calico 설치 (마스터 노드)

https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises#install-calico


curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/calico.yaml 

kubectl apply -f calico.yaml







kubectl delete -f calico.yaml

curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

kubectl apply -f calico.yaml














############  kubeadm join (워커 노드)






sudo su
sudo kubeadm reset





kubeadm join 192.168.0.5:6443 --token 0wvjya.f7nm2ovx71hen6pn \
        --discovery-token-ca-cert-hash sha256:5a72d9f593d283aa6a0a5f843f21ed4852732a0c65d7edfa11f992d2eb729513





















############  MetalLB 재설치 (Load Balancer)
############  MetalLB 재설치 (Load Balancer)
############  MetalLB 재설치 (Load Balancer)
############  MetalLB 재설치 (Load Balancer)
############  MetalLB 재설치 (Load Balancer)
############  MetalLB 재설치 (Load Balancer)
############  MetalLB 재설치 (Load Balancer)
############  MetalLB 재설치 (Load Balancer)
############  MetalLB 재설치 (Load Balancer)
############  MetalLB 재설치 (Load Balancer)



# 릴리스 이름 확인
helm list -n cert-manager

# 삭제 (릴리스 이름이 cert-manager인 경우)
helm uninstall cert-manager -n cert-manager




kubectl delete crd -l app.kubernetes.io/name=cert-manager


 




############ MetalLB 설치 (마스터 노드 또는 클러스터에 배포)
############ MetalLB 설치 (마스터 노드 또는 클러스터에 배포)
############ MetalLB 설치 (마스터 노드 또는 클러스터에 배포)
############ MetalLB 설치 (마스터 노드 또는 클러스터에 배포)



1. MetalLB 재설치 (Load Balancer)
                                          MetalLB는 온프레미스 쿠버네티스 환경에서 LoadBalancer 타입의 서비스를 사용할 수 있게 해줍니다.

                                          1단계: 기존 리소스 정리 (선택 사항)
                                          기존에 설치된 MetalLB가 있다면 먼저 네임스페이스를 삭제하여 정리합니다. (새로 설치하는 경우 건너뛰셔도 됩니다.)

                                          Bash

                                          kubectl delete namespace metallb-system
                                          2단계: Kube-proxy 설정 (Strict ARP)
                                          MetalLB가 정상 작동하려면 kube-proxy의 strictARP 모드가 켜져 있어야 합니다.

                                          Bash

                                          kubectl get configmap kube-proxy -n kube-system -o yaml | \
                                          sed -e "s/strictARP: false/strictARP: true/" | \
                                          kubectl apply -f - -n kube-system
 


                                          kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

                                          kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml
                                          



############ Helm을 통해 설치하며

                                        sudo apt-get install curl gpg apt-transport-https --yes
                                        curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
                                        echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
                                        sudo apt-get update
                                        sudo apt-get install helm

                                        # 1. Helm Repository 추가
                                        helm repo add metallb https://metallb.github.io/metallb

                                        # 2. MetalLB 설치 (네임스페이스 자동 생성)
                                        helm install metallb metallb/metallb --create-namespace --namespace metallb-system

                                        # 3. Pod 상태 확인 (Controller와 Speaker Pod가 Running 상태인지 확인)
                                        kubectl get pods -n metallb-system









############  metallb-ip-config.yaml


#  kubectl apply -f 0metallb-config.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: external-ip-pool
  namespace: metallb-system
spec:
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



 


############ 


 
 kubectl apply -f 0metallb-config.yaml


kubectl get pods -n metallb-system











확인 
	sangbinlee9@k8s-master1:~$ kubectl apply -f metallb-ip-config.yaml
	ipaddresspool.metallb.io/external-ip-pool unchanged
	l2advertisement.metallb.io/basic-l2 unchanged
	sangbinlee9@k8s-master1:~$ kubectl get IPAddressPools -A
	NAMESPACE        NAME               AUTO ASSIGN   AVOID BUGGY IPS   ADDRESSES
	metallb-system   external-ip-pool   true          false             ["192.168.0.240-192.168.0.250"]
	sangbinlee9@k8s-master1:~$ kubectl get L2Advertisement -A
	NAMESPACE        NAME       IPADDRESSPOOLS         IPADDRESSPOOL SELECTORS   INTERFACES
	metallb-system   basic-l2   ["external-ip-pool"]
	sangbinlee9@k8s-master1:~$


############ 


재개할 다음 단계
	MetalLB 설치 및 설정이 완료되었으므로, 이전 답변의 1단계부터 다시 진행하면 됩니다.

	MetalLB 설치 (완료)

	Nginx Ingress Controller 설치 (Service에 IP가 할당되는지 확인)

	Cert-Manager 설치

	Let's Encrypt ClusterIssuer 생성

	Nginx 웹사이트 배포 및 Ingress를 통한 HTTPS 설정

 



############ ingress-nginx
https://kubernetes.github.io/ingress-nginx/deploy/#quick-start



// kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.0/deploy/static/provider/baremetal/deploy.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.0/deploy/static/provider/cloud/deploy.yaml

############ Helm 설치 명령어 (MetalLB 환경)

helm list -A


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create namespace ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx

kubectl get svc -n ingress-nginx
# EXTERNAL-IP에 MetalLB가 할당한 IP가 표시되는지 확인합니다.





############ Cert-Manager 설치

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.1/cert-manager.yaml
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.1/cert-manager.yaml



kubectl get pods --namespace cert-manager

kubectl get pods -n ingress-nginx
 


kubectl get clusterissuer letsencrypt-prod


############ Cert-Manager 설치

helm install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.19.1 \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

kubectl get pods -n cert-manager

############ 
############ 
############ 
############    2. cert-manager Helm 재설치
############    2. cert-manager Helm 재설치
############    2. cert-manager Helm 재설치
############    2. cert-manager Helm 재설치
############    2. cert-manager Helm 재설치





# 1. 이전 Certificate 및 Secret 삭제
kubectl delete certificate shop-tls-secret --ignore-not-found=true

# 2. Ingress 리소스를 포함한 YAML 파일 삭제
kubectl delete -f 4ingress.yaml --ignore-not-found=true

# 3. 실패한 모든 Order 리소스 삭제
kubectl delete order --all --ignore-not-found=true

# 4. Helm 릴리스 삭제 (cert-manager)
helm uninstall cert-manager --namespace cert-manager



kubectl rollout status deployment cert-manager -n cert-manager
kubectl rollout status deployment cert-manager-webhook -n cert-manager
kubectl rollout status deployment cert-manager-cainjector -n cert-manager



############ 
############ 
############ 
############ 
############ Let's Encrypt ClusterIssuer 설정



kubectl apply -f 1clusterissuer.yaml
 

############ 
 
kubectl get clusterissuer letsencrypt-prod
############ 

 
		  
		  
		  
############ 
############ 
############ 




kubectl apply -f 1clusterissuer.yaml


############ 


								sangbinlee9@k8s-master1:~$ kubectl apply -f 1clusterissuer.yaml
								clusterissuer.cert-manager.io/letsencrypt-prod created
								sangbinlee9@k8s-master1:~$ kubectl describe clusterissuers letsencrypt-prod
								Name:         letsencrypt-prod
								Namespace:
								Labels:       <none>
								Annotations:  <none>
								API Version:  cert-manager.io/v1
								Kind:         ClusterIssuer
								Metadata:
								  Creation Timestamp:  2025-11-11T14:28:18Z
								  Generation:          1
								  Resource Version:    4241
								  UID:                 748ed1dd-70a5-48d3-a29d-8d39685c8669
								Spec:
								  Acme:
									Email:  sangbinlee9@gmail.com
									Private Key Secret Ref:
									  Name:  letsencrypt-prod-key
									Server:  https://acme-v02.api.letsencrypt.org/directory
									Solvers:
									  http01:
										Ingress:
										  Class:  nginx
								Status:
								  Acme:
									Last Private Key Hash:  HTWgHGgcYAVqTyZ6cXyoE0zbfclzj6j4pkikQqsH7Ww=
									Last Registered Email:  sangbinlee9@gmail.com
								  Conditions:
									Last Transition Time:  2025-11-11T14:28:19Z
									Message:               The ACME account was registered with the ACME server
									Observed Generation:   1
									Reason:                ACMEAccountRegistered
									Status:                True
									Type:                  Ready
								Events:                    <none>
								sangbinlee9@k8s-master1:~$

############ 
############ 
############ 

kubectl get clusterissuer  letsencrypt-prod -o yaml
kubectl get clusterissuer letsencrypt-staging -o yaml
kubectl get clusterissuer letsencrypt-production -o yaml






############  Ingress 리소스 재설정


Nginx Ingress Controller와 Cert-Manager를 설정했으므로 하나의 Ingress 리소스를 사용하여
이를 위해 Ingress 리소스의 rules와 tls 섹션을 수정해야 합니다.



############ 
############ 
kubectl get ingress shop-tls-ingress
kubectl get svc -n ingress-nginx





kubectl get certificate
kubectl describe certificate <certificate-name>
DNS 설정:



############ 
############ 
############ 
############ 
배포 순서 요약
가장 먼저 해야 할 단계는 Deployment와 Service 생성입니다.

	Deployment (배포):

		무엇: 애플리케이션의 코드가 담긴 컨테이너 이미지를 구동하고 관리합니다.

		역할: 웹 서버(Pod)가 실제로 동작하게 합니다.

	Service (서비스):

		무엇: Deployment로 만들어진 Pod들에 내부 접근 주소를 제공하고 로드 밸런싱을 수행합니다.

		역할: 클러스터 내부에서 애플리케이션에 접근할 수 있게 합니다.

	Cert-Manager & ClusterIssuer 설정:

		무엇: 인증서 관리 시스템을 설치하고, Let's Encrypt 같은 인증 기관을 정의합니다.

		역할: HTTPS를 위한 인증서 발급 준비를 마칩니다.

	Ingress (인그레스):

		무엇: **외부 접근 주소(도메인)**를 정의하고, 인증서 발급을 요청합니다.

		역할: 외부에서 접속 가능하게 하고, **TLS(HTTPS)**를 적용합니다.
	############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 백엔드 서비스 (Service) 구성   dev9-service.yaml
 

# dev9-prod-service.yaml (운영 서비스)
apiVersion: v1
kind: Service
metadata:
  name: dev9-prod-service
spec:
  # Ingress에서 지정된 포트 80으로 들어오는 트래픽을 처리합니다.
  type: ClusterIP 
  ports:
    - port: 80
      targetPort: 8080 # 파드(백엔드 앱)가 실제로 리스닝하는 포트
  selector:
    app: shop-app
    env: prod # 이 셀렉터를 가진 파드에 트래픽을 보냅니다.
---
# dev9-dev-service.yaml (개발 서비스)
apiVersion: v1
kind: Service
metadata:
  name: dev9-dev-service
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 8080
  selector:
    app: shop-app
    env: dev # 이 셀렉터를 가진 파드에 트래픽을 보냅니다.











sangbinlee9@k8s-master1:~$ kubectl apply -f dev9-service.yaml
service/dev9-prod-service created
service/dev9-dev-service created
sangbinlee9@k8s-master1:~$


sangbinlee9@k8s-master1:~$ kubectl apply -f 2deployment.yaml
deployment.apps/dev9-prod-deployment created
deployment.apps/dev9-dev-deployment created
sangbinlee9@k8s-master1:~$ kubectl get  deployment
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
dev9-dev-deployment    1/1     1            1           13s
dev9-prod-deployment   3/3     3            3           13s



















############ 
############ 


-rw-r--r-- 1 root        root             431 Nov 11 23:26 1clusterissuer.yaml
-rw-r--r-- 1 root        root            1165 Nov  9 19:18 2deployment.yaml
-rw-r--r-- 1 root        root             723 Nov  9 11:44 3svc.yaml
-rw-r--r-- 1 root        root            1412 Nov  9 09:12 4ingress.yaml

############ 

kubectl get certificate

############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############  도커 이미지 생성 및 레지스트리 저장


docker login
docker build -t sangbinlee/dev9-nginx:latest .
docker push sangbinlee/dev9-nginx:latest


 

############ 







# shop-backends-deployment.yaml

# 1. 운영 환경 Deployment (dev9.shop)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dev9-prod-deployment
  labels:
    app: shop-app
    env: prod
spec:
  replicas: 3
  selector:
    matchLabels:
      app: shop-app
      env: prod
  template:
    metadata:
      labels:
        app: shop-app
        env: prod
    spec:
      containers:
      - name: nginx-prod-backend
        image: sangbinlee/dev9-nginx:latest 
        ports:
        - containerPort: 80 
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"

---

# 2. 개발 환경 Deployment (dev.dev9.shop)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dev9-dev-deployment
  labels:
    app: shop-app
    env: dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: shop-app
      env: dev
  template:
    metadata:
      labels:
        app: shop-app
        env: dev
    spec:
      containers:
      - name: nginx-dev-backend
        image: sangbinlee/dev9-nginx:latest 
        ports:
        - containerPort: 80 
        resources:
          limits:
            memory: "64Mi"
            cpu: "250m"
			
			
			
############ 




############ 
############ 
############ 백엔드 파드 (Deployment) 구성

 shop-backends-deployment.yaml



############ 



kubectl apply -f shop-backends-deployment.yaml



############ 
############ 
############ 
############ 

############     3. ✅ 실행 순서
Deployment 리소스를 먼저 클러스터에 배포하여 파드를 생성합니다.

Service 리소스를 배포하여 파드들을 묶고 Cluster IP를 할당합니다.

파드와 서비스가 정상적으로 실행되면, Ingress 리소스(shop-tls-ingress.yaml)를 배포하여 외부 트래픽을 라우팅합니다.





# 서비스 확인
kubectl get svc dev9-prod-service dev9-dev-service

# 파드 확인
kubectl get pods -l app=shop-app


############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 










############ 3단계: Ingress 리소스 설정

Ingress YAML 작성:
Ingress 배포: 


kubectl delete -f shop-tls-ingress.yaml
kubectl apply -f shop-tls-ingress.yaml




############ 
############ 
############  check

kubectl describe ingress shop-tls-ingress

kubectl get certificate shop-tls-secret
kubectl get clusterissuer letsencrypt-prod


# 이미 실패했을 Certificate 리소스 삭제 (Cert-Manager가 Ingress를 보고 다시 생성)
kubectl delete certificate shop-tls-secret




############ ✅ 최종 권장 조치 (순서대로 실행)
이미 Service와 Deployment를 배포하셨다고 했으므로, 다음 단계를 순서대로 진행해 주세요.

ClusterIssuer와 Service의 정상 작동 확인:

kubectl get clusterissuer letsencrypt-prod

kubectl get svc dev9-prod-service dev9-dev-service

Deployment 파드의 정상 작동 확인:

kubectl get pods -l app=shop-app (모든 파드가 Running 상태인지 확인)

실패한 Certificate 리소스 삭제 후 재시도 유도:

Bash

  kubectl delete certificate shop-tls-secret
인증서 발급 상태 추적:

Bash

  kubectl get certificate shop-tls-secret --watch
이 명령어로 READY가 True가 될 때까지 기다립니다. (일반적으로 2~5분 소요)

인증서 발급이 완료되면, Ingress가 완벽하게 작동할 것입니다.










############ 
############ 
############ 
############ 
1. ClusterIssuer 배포 (인증서 발급 활성화)


kubectl apply -f letsencrypt-prod-clusterissuer.yaml






############ 
2. 백엔드 Deployment 배포 (트래픽 처리 준비)

kubectl apply -f shop-backends-deployment.yaml

############ 

kubectl delete certificate shop-tls-secret
kubectl get certificate shop-tls-secret --watch


############ 
ClusterIssuer
	- letsencrypt-production-clusterissuer.yaml
	- letsencrypt-staging-clusterissuer.yaml
service : 
	- dev9-service.yaml
Deployment
	- shop-backends-deployment.yaml
ingress
	- shop-tls-ingress.yaml
	- nginx-web-tls


############ 
ClusterIssuer
service : 
Deployment
ingress
 



############ 
############ 
############ 
############ 
############ 



sangbinlee9@k8s-master1:~$ # 1. 멈춰있는 Order 리소스를 삭제합니다. (Challenge도 자동 삭제됨)
kubectl delete order shop-tls-secret-1-1055312325

# 2. Certificate를 삭제합니다. (Ingress가 Certificate를 즉시 재생성하여 ACME 시도를 재개합니다.)
kubectl delete certificate shop-tls-secret
order.acme.cert-manager.io "shop-tls-secret-1-1055312325" deleted from default namespace
certificate.cert-manager.io "shop-tls-secret" deleted from default namespace
sangbinlee9@k8s-master1:~$







sangbinlee9@k8s-master1:~$ kubectl get certificate
NAME              READY   SECRET            AGE
shop-tls-secret   False   shop-tls-secret   64s
sangbinlee9@k8s-master1:~$







sangbinlee9@k8s-master1:~$ kubectl get svc -n ingress-nginx
NAME                                               TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                      AGE
nginx-ingress-ingress-nginx-controller             LoadBalancer   10.110.101.226   192.168.0.240   80:32363/TCP,443:31190/TCP   22h
nginx-ingress-ingress-nginx-controller-admission   ClusterIP      10.104.171.11    <none>          443/TCP                      22h



############ 
############ 
############ 
############ 
############ 
############ 




kubectl edit svc ingress-nginx-controller -n ingress-nginx


















############ 
############ 
############ 
############ 
############ 




############ 4단계: CI/CD 자동화 파이프라인 구축

Docker Image 빌드 환경 설정:  
	Dockerfile을 작성하고, Docker Hub 또는 GitHub Container Registry와 같은 이미지 저장소에 접근 가능한 환경을 구성합니다.

CI/CD 도구 선택 및 설정 (예: GitHub Actions):
	현재 사용하시는 쿠버네티스 클러스터와 CI/CD 도구(예: GitHub Actions, GitLab CI, Jenkins)가 무엇인지 알려주시면, 해당 도구에 맞는 CI/CD 파이프라인 스크립트의 구체적인 예시를 제공해 드릴 수 있습니다.
	
	
	
############ 
############ 
############  shop-tls-ingress.yaml




sangbinlee9@k8s-master1:~$ cat shop-tls-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: shop-tls-ingress
  annotations:
    # 🔒 HTTP 접속을 HTTPS로 강제 리다이렉션합니다.
    nginx.ingress.kubernetes.io/ssl-redirect: "true"

    # 📜 Cert-Manager에게 인증서 발급을 요청하며 사용할 ClusterIssuer 이름 지정
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  # 💡 경고 메시지를 피하기 위해 ingressClassName 필드를 사용합니다.
  #    Nginx Ingress Controller를 사용하는 경우 "nginx"를 사용합니다.
  ingressClassName: "nginx"

  # 🔒 TLS(HTTPS) 설정을 정의합니다.
  tls:
  - hosts:
    - dev9.shop
    - dev.dev9.shop
    # 💡 Cert-Manager가 발급된 인증서를 저장할 Kubernetes Secret 이름
    secretName: shop-tls-secret

  # 🌐 도메인별 트래픽 라우팅 규칙 정의
  rules:
  - host: dev9.shop           # 1. 운영용 도메인
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: dev9-prod-service # 운영 서비스 이름
            port:
              number: 80

  - host: dev.dev9.shop       # 2. 개발용 도메인
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: dev9-dev-service  # 개발 서비스 이름
            port:
              number: 80
sangbinlee9@k8s-master1:~$









	sangbinlee9@k8s-master1:~$ kubectl apply -f shop-tls-ingress.yaml
	ingress.networking.k8s.io/shop-tls-ingress configured
	sangbinlee9@k8s-master1:~$ kubectl get no
	NAME          STATUS   ROLES           AGE   VERSION
	k8s-db1       Ready    <none>          12h   v1.34.1
	k8s-db2       Ready    <none>          12h   v1.34.1
	k8s-master1   Ready    control-plane   13h   v1.34.1
	k8s-worker1   Ready    <none>          12h   v1.34.1
	k8s-worker2   Ready    <none>          12h   v1.34.1
	k8s-worker3   Ready    <none>          12h   v1.34.1
	k8s-worker4   Ready    <none>          12h   v1.34.1
	sangbinlee9@k8s-master1:~$ ll





############   Ingress 설정 확인 명령어



kubectl get ingress shop-tls-ingress

kubectl describe ingress shop-tls-ingress

3. HTTPS 인증서 발급 상태 확인 (Cert-Manager)








############   내 상태인지



sangbinlee9@k8s-master1:~$ kubectl get no
NAME          STATUS   ROLES           AGE   VERSION
k8s-db1       Ready    <none>          12h   v1.34.1
k8s-db2       Ready    <none>          12h   v1.34.1
k8s-master1   Ready    control-plane   13h   v1.34.1
k8s-worker1   Ready    <none>          12h   v1.34.1
k8s-worker2   Ready    <none>          12h   v1.34.1
k8s-worker3   Ready    <none>          12h   v1.34.1
k8s-worker4   Ready    <none>          12h   v1.34.1
sangbinlee9@k8s-master1:~$


내 노트북 7대에 설치한거야.

포트포워딩 192.168.0.240 80, 443 설정한 상태야

callico
metallb
cert-manager





############   db 설치

1. Persistent Volume (PV) 준비 💾


	1단계: 저장소 클래스 (StorageClass) 확인/설정:
	2단계: Persistent Volume Claim (PVC) 준비:
	
	
2. PostgreSQL 배포 (StatefulSet 사용) 🐳


3. 클라이언트 접근 및 관리

7단계: 설치 확인:
	TIP: 프로덕션 환경이라면 **PostgreSQL Operator (예: Patroni)**를 사용하는 것이 백업, 복제, 페일오버 등을 자동화하는 가장 강력한 방법이지만, 간단한 설치 로드맵으로는 위와 같이 StatefulSet을 사용하는 것이 기본입니다.
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 
############ 

