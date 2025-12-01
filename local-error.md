kubectl describe service cm-acme-http-solver-x8x2m -n default


curl -v http://dev9.shop



kubectl delete -f 4ingress.yaml
kubectl delete ingress --all -A
# Order, Challenge 리소스 삭제
kubectl delete order --all -A
kubectl delete challenge --all -A
kubectl get certificate -A





sangbinlee9@k8s-master1:~$ kubectl describe certificate







   sangbinlee9@k8s-master1:~$ kubectl delete ingress --all -A
   ingress.networking.k8s.io "cm-acme-http-solver-x244f" deleted from default namespace
   ingress.networking.k8s.io "cm-acme-http-solver-zqwq9" deleted from default namespace
   ingress.networking.k8s.io "shop-tls-ingress" deleted from default namespace
   sangbinlee9@k8s-master1:~$
