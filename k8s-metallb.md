
sangbinlee9@k8s-master1:~$ kubectl apply -f 1clusterissuer.yaml
clusterissuer.cert-manager.io/letsencrypt-prod created




sangbinlee9@k8s-master1:~$ kubectl get clusterissuer letsencrypt-prod
NAME               READY   AGE
letsencrypt-prod   True    14s


sangbinlee9@k8s-master1:~$ ^C





sangbinlee9@k8s-master1:~$ kubectl describe clusterissuers letsencrypt-prod
Name:         letsencrypt-prod
Namespace:
Labels:       <none>
Annotations:  <none>
API Version:  cert-manager.io/v1
Kind:         ClusterIssuer
Metadata:
  Creation Timestamp:  2025-11-21T22:56:09Z
  Generation:          1
  Resource Version:    511872
  UID:                 688492d0-42bd-4b20-b7ee-08b6d6b85d4c
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
    Last Private Key Hash:  hF9aPBpP1PYWXa3j0TVKaI6qn5cdRIjcq1VCsKNVBqQ=
    Last Registered Email:  sangbinlee9@gmail.com
  Conditions:
    Last Transition Time:  2025-11-21T22:56:16Z
    Message:               The ACME account was registered with the ACME server
    Observed Generation:   1
    Reason:                ACMEAccountRegistered
    Status:                True
    Type:                  Ready
Events:                    <none>



sangbinlee9@k8s-master1:~$ kubectl get ingress shop-tls-ingress
NAME               CLASS   HOSTS                     ADDRESS         PORTS     AGE
shop-tls-ingress   nginx   dev9.shop,dev.dev9.shop   192.168.0.240   80, 443   30h



sangbinlee9@k8s-master1:~$ kubectl get svc -n ingress-nginx
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.100.120.72   192.168.0.240   80:32029/TCP,443:31041/TCP   8d
ingress-nginx-controller-admission   ClusterIP      10.97.71.225    <none>          443/TCP                      8d



sangbinlee9@k8s-master1:~$ kubectl get certificate
NAME              READY   SECRET            AGE
shop-tls-secret   False   shop-tls-secret   2m2s




sangbinlee9@k8s-master1:~$ kubectl describe certificate shop-tls-secret
            Name:         shop-tls-secret
            Namespace:    default
            Labels:       <none>
            Annotations:  <none>
            API Version:  cert-manager.io/v1
            Kind:         Certificate
            Metadata:
            Creation Timestamp:  2025-11-21T22:55:55Z
            Generation:          1
            Owner References:
                API Version:           networking.k8s.io/v1
                Block Owner Deletion:  true
                Controller:            true
                Kind:                  Ingress
                Name:                  shop-tls-ingress
                UID:                   deb841f1-7848-4c16-89be-60631c193754
            Resource Version:        511808
            UID:                     e78bb542-1f19-4b35-94b3-d77c2067e3a7
            Spec:
            Dns Names:
                dev9.shop
                dev.dev9.shop
            Issuer Ref:
                Group:      cert-manager.io
                Kind:       ClusterIssuer
                Name:       letsencrypt-prod
            Secret Name:  shop-tls-secret
            Usages:
                digital signature
                key encipherment
            Status:
            Conditions:
                Last Transition Time:        2025-11-21T22:55:55Z
                Message:                     Issuing certificate as Secret does not exist
                Observed Generation:         1
                Reason:                      DoesNotExist
                Status:                      False
                Type:                        Ready
                Last Transition Time:        2025-11-21T22:55:55Z
                Message:                     Issuing certificate as Secret does not exist
                Observed Generation:         1
                Reason:                      DoesNotExist
                Status:                      True
                Type:                        Issuing
            Next Private Key Secret Name:  shop-tls-secret-4x5hb
            Events:
            Type    Reason     Age    From                                       Message
            ----    ------     ----   ----                                       -------
            Normal  Issuing    2m16s  cert-manager-certificates-trigger          Issuing certificate as Secret does not exist
            Normal  Generated  2m15s  cert-manager-certificates-key-manager      Stored new private key in temporary Secret resource "shop-tls-secret-4x5hb"
            Normal  Requested  2m15s  cert-manager-certificates-request-manager  Created new CertificateRequest resource "shop-tls-secret-1"
