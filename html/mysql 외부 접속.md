


sangbinlee9@k8s-master1:~$ kubectl get pod -o wide -A
NAMESPACE        NAME                                                     READY   STATUS    RESTARTS         AGE     IP               NODE          NOMINATED NODE   READINESS GATES
cert-manager     cert-manager-7b9875fbcc-c6g2v                            1/1     Running   5 (5h33m ago)    5d23h   10.244.100.215   k8s-worker3   <none>           <none>
cert-manager     cert-manager-cainjector-948d47c6-nhvms                   1/1     Running   5 (5h37m ago)    5d23h   10.244.194.99    k8s-worker1   <none>           <none>
cert-manager     cert-manager-webhook-78bd84d46b-4v9c5                    1/1     Running   0                4h33m   10.244.194.101   k8s-worker1   <none>           <none>
default          mysql-0                                                  1/1     Running   5 (5h37m ago)    5d22h   10.244.194.97    k8s-worker1   <none>           <none>
default          nginx-dev-59df5bbd9d-sw5cs                               1/1     Running   0                4h33m   10.244.194.102   k8s-worker1   <none>           <none>
default          nginx-portfolio-86d7758489-5g82m                         1/1     Running   0                4h33m   10.244.248.66    k8s-worker6   <none>           <none>
default          nginx-prod-6974f95f66-dh7mb                              1/1     Running   5 (5h37m ago)    5d22h   10.244.194.98    k8s-worker1   <none>           <none>
default          wordpress-5b76b86cc7-92v2t                               1/1     Running   5 (5h37m ago)    5d22h   10.244.194.96    k8s-worker1   <none>           <none>
ingress-nginx    ingress-nginx-controller-58968596dd-mjglx                1/1     Running   5 (5h37m ago)    5d23h   10.244.194.100   k8s-worker1   <none>           <none>
kube-system      calico-kube-controllers-6879d4fcdc-pskz5                 1/1     Running   0                4h33m   10.244.159.139   k8s-master1   <none>           <none>
kube-system      calico-node-cmpvl                                        1/1     Running   5 (5h37m ago)    5d23h   192.168.0.20     k8s-worker1   <none>           <none>
kube-system      calico-node-jgwqn                                        1/1     Running   5 (4h36m ago)    5d23h   192.168.0.14     k8s-worker6   <none>           <none>
kube-system      calico-node-jjvqk                                        1/1     Running   5 (97m ago)      5d23h   192.168.0.21     k8s-worker2   <none>           <none>
kube-system      calico-node-rmfsq                                        1/1     Running   5 (3d10h ago)    5d23h   192.168.0.15     k8s-worker5   <none>           <none>
kube-system      calico-node-sk8m4                                        1/1     Running   5 (6h29m ago)    5d23h   192.168.0.5      k8s-master1   <none>           <none>
kube-system      calico-node-z6r27                                        1/1     Running   5 (5h33m ago)    5d23h   192.168.0.12     k8s-worker3   <none>           <none>
kube-system      calico-node-zj8xd                                        1/1     Running   5 (3d10h ago)    5d23h   192.168.0.13     k8s-worker4   <none>           <none>
kube-system      coredns-7c65d6cfc9-lvvjf                                 1/1     Running   6 (6h29m ago)    6d4h    10.244.159.137   k8s-master1   <none>           <none>
kube-system      coredns-7c65d6cfc9-mjq5n                                 1/1     Running   6 (6h29m ago)    6d4h    10.244.159.138   k8s-master1   <none>           <none>
kube-system      etcd-k8s-master1                                         1/1     Running   26 (6h29m ago)   6d4h    192.168.0.5      k8s-master1   <none>           <none>
kube-system      kube-apiserver-k8s-master1                               1/1     Running   25 (6h29m ago)   6d4h    192.168.0.5      k8s-master1   <none>           <none>
kube-system      kube-controller-manager-k8s-master1                      1/1     Running   22 (6h29m ago)   6d4h    192.168.0.5      k8s-master1   <none>           <none>
kube-system      kube-proxy-6rzk2                                         1/1     Running   22 (6h29m ago)   6d4h    192.168.0.5      k8s-master1   <none>           <none>
kube-system      kube-proxy-dqgnd                                         1/1     Running   14 (5h33m ago)   6d      192.168.0.12     k8s-worker3   <none>           <none>
kube-system      kube-proxy-f2sxx                                         1/1     Running   15 (3d10h ago)   6d      192.168.0.15     k8s-worker5   <none>           <none>
kube-system      kube-proxy-pnj25                                         1/1     Running   15 (3d10h ago)   6d      192.168.0.13     k8s-worker4   <none>           <none>
kube-system      kube-proxy-qxdvb                                         1/1     Running   14 (97m ago)     6d      192.168.0.21     k8s-worker2   <none>           <none>
kube-system      kube-proxy-vjr75                                         1/1     Running   14 (5h37m ago)   6d      192.168.0.20     k8s-worker1   <none>           <none>
kube-system      kube-proxy-x44dv                                         1/1     Running   14 (4h36m ago)   6d      192.168.0.14     k8s-worker6   <none>           <none>
kube-system      kube-scheduler-k8s-master1                               1/1     Running   21 (6h29m ago)   6d4h    192.168.0.5      k8s-master1   <none>           <none>
metallb-system   controller-78fb49f59-4929b                               1/1     Running   0                4h33m   10.244.24.193    k8s-worker4   <none>           <none>
metallb-system   speaker-4shph                                            1/1     Running   10 (97m ago)     5d23h   192.168.0.21     k8s-worker2   <none>           <none>
metallb-system   speaker-6kt7r                                            1/1     Running   10 (5h33m ago)   5d23h   192.168.0.12     k8s-worker3   <none>           <none>
metallb-system   speaker-96wv6                                            1/1     Running   10 (6h29m ago)   5d23h   192.168.0.5      k8s-master1   <none>           <none>
metallb-system   speaker-bpjv6                                            1/1     Running   10 (5h37m ago)   5d23h   192.168.0.20     k8s-worker1   <none>           <none>
metallb-system   speaker-cld6h                                            1/1     Running   8 (3d10h ago)    5d23h   192.168.0.13     k8s-worker4   <none>           <none>
metallb-system   speaker-s7zc5                                            1/1     Running   9 (3d10h ago)    5d23h   192.168.0.15     k8s-worker5   <none>           <none>
metallb-system   speaker-ttd8b                                            1/1     Running   10 (4h36m ago)   5d23h   192.168.0.14     k8s-worker6   <none>           <none>
monitoring       alertmanager-monitoring-kube-prometheus-alertmanager-0   2/2     Running   10 (5h37m ago)   5d22h   10.244.194.95    k8s-worker1   <none>           <none>
monitoring       monitoring-grafana-7d49f8544f-mjx9x                      3/3     Running   15 (5h33m ago)   5d22h   10.244.100.213   k8s-worker3   <none>           <none>
monitoring       monitoring-kube-prometheus-operator-9b6cb6694-sr6cc      1/1     Running   0                4h33m   10.244.100.216   k8s-worker3   <none>           <none>
monitoring       monitoring-kube-state-metrics-7984768b56-4rmh6           1/1     Running   6 (5h32m ago)    5d22h   10.244.100.214   k8s-worker3   <none>           <none>
monitoring       monitoring-prometheus-node-exporter-6nqkc                1/1     Running   5 (3d10h ago)    5d22h   192.168.0.13     k8s-worker4   <none>           <none>
monitoring       monitoring-prometheus-node-exporter-8nj5j                1/1     Running   5 (4h36m ago)    5d22h   192.168.0.14     k8s-worker6   <none>           <none>
monitoring       monitoring-prometheus-node-exporter-8zth8                1/1     Running   5 (3d10h ago)    5d22h   192.168.0.15     k8s-worker5   <none>           <none>
monitoring       monitoring-prometheus-node-exporter-j2s68                1/1     Running   5 (5h37m ago)    5d22h   192.168.0.20     k8s-worker1   <none>           <none>
monitoring       monitoring-prometheus-node-exporter-n5d4t                1/1     Running   5 (97m ago)      5d22h   192.168.0.21     k8s-worker2   <none>           <none>
monitoring       monitoring-prometheus-node-exporter-vvxbs                1/1     Running   5 (5h33m ago)    5d22h   192.168.0.12     k8s-worker3   <none>           <none>
monitoring       monitoring-prometheus-node-exporter-wd5n6                1/1     Running   5 (6h29m ago)    5d22h   192.168.0.5      k8s-master1   <none>           <none>
monitoring       prometheus-monitoring-kube-prometheus-prometheus-0       2/2     Running   0                97m     10.244.126.40    k8s-worker2   <none>           <none>
sangbinlee9@k8s-master1:~$


sangbinlee9@k8s-master1:~$ kubectl get no -o wide -A
NAME          STATUS   ROLES           AGE    VERSION    INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
k8s-master1   Ready    control-plane   6d4h   v1.31.14   192.168.0.5    <none>        Ubuntu 24.04.3 LTS   6.8.0-88-generic   containerd://1.7.28
k8s-worker1   Ready    <none>          6d     v1.31.14   192.168.0.20   <none>        Ubuntu 24.04.3 LTS   6.8.0-88-generic   containerd://1.7.28
k8s-worker2   Ready    <none>          6d     v1.31.14   192.168.0.21   <none>        Ubuntu 24.04.3 LTS   6.8.0-88-generic   containerd://1.7.28
k8s-worker3   Ready    <none>          6d     v1.31.14   192.168.0.12   <none>        Ubuntu 24.04.3 LTS   6.8.0-88-generic   containerd://1.7.28
k8s-worker4   Ready    <none>          6d     v1.31.14   192.168.0.13   <none>        Ubuntu 24.04.3 LTS   6.8.0-88-generic   containerd://1.7.28
k8s-worker5   Ready    <none>          6d     v1.31.14   192.168.0.15   <none>        Ubuntu 24.04.3 LTS   6.8.0-88-generic   containerd://1.7.28
k8s-worker6   Ready    <none>          6d     v1.31.14   192.168.0.14   <none>        Ubuntu 24.04.3 LTS   6.8.0-88-generic   containerd://1.7.28


sangbinlee9@k8s-master1:~$ nslookup mysql.dev9.shop
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   mysql.dev9.shop
Address: 180.231.93.130

sangbinlee9@k8s-master1:~$



2. mysql.dev9.shop 3306으로 외부에서 접속원함.


3. iptime 공유기  포트포워딩 세팅: ip, port 