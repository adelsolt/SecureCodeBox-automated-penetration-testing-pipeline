# SecureCodeBox Penetration Testing Pipeline on a Kind Cluster


### Juice Shop is a vulnerable web application that i will perform two type of scans

#### the ZAP-Advenced Scan which will retrieve a finding.json finding 

```
kubectl apply -f zap-advenced-scan-crd.yaml
```

#### Running Nmap scanning and ssh port cracking with Ncrack

First let's create a secret to hold dictionaries to use in brute forcing 

```
printf "root\nadmin\n" > users.txt
printf "THEPASSWORDYOUCREATED\n123456\npassword\n" > passwords.txt
```

```
kubectl create secret generic --from-file users.txt --from-file passwords.txt ncrack-lists
```
#### Running SemGreb scan on a public Github repo

I will be using a secure simple calculator program written in C programming language 

```
kubectl apply -f calculator-scan-semgrep-cdr.yaml
```

Then I will be using a Vulnerable Flask app 

```
kubectl apply -f flask-scan-semgrep-cdr.yaml
```


********************************************************************************************
### Commands Playbook 
Listing SCB pods running:
    sudo kubectl get pods -n securecodebox-system 

Listing SCB services:
    sudo kubectl get svc -n securecodebox-system

Listing scanners:
    sudo kubectl get scantypes

List all Pods in all Namespaces:
    kubectl get pods --all-namespaces

Get scan result:
    kubectl get scans

Get scan findings:
    kubectl get findings -o yaml

Checking the available scan types:
    kubectl get scantypes -n default

Get all kubernetes deployment:
    kubectl get deployments --all-namespaces

Delete a deployment:
    kubectl delete -n NAMESPACE deployment DEPLOYMENT

Creating a unique namespace for each vulnerable apps:
    kubectl create namespace my-namespace

Checking the ingress controller service:
    kubectl get svc -n ingress-nginx

Getting the services IPs in the cluster:
    kubectl describe svc

