# SecureCodeBox Penetration Testing Pipeline on a Kind Cluster


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
