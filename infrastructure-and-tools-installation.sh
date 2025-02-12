#!/bin/bash

# Docker
set -e  
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

docker --version

# Kind
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo cp ./kind /usr/local/bin/kind
rm -rf kind

kind --version


# Helm
curl -fsSL https://baltocdn.com/helm/signing.asc | sudo tee /etc/apt/keyrings/helm.asc > /dev/null
sudo apt install -y apt-transport-https
echo "deb [signed-by=/etc/apt/keyrings/helm.asc] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list > /dev/null
sudo apt update
sudo apt install -y helm

helm version

# Kubectl 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version

# JQ
sudo apt install -y jq

jq --version


# Ingress controller
        kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml
        kubectl wait --namespace kube-system \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s
        kubectl get svc -n ingress-nginx


# SecureCodeBox Operator
helm --namespace securecodebox-system upgrade --install --create-namespace securecodebox-operator oci://ghcr.io/securecodebox/helm/operator
        # Verified deployment with "sudo kubectl get pods -n securecodebox-system"
        # Port Forward MinIo instance with "kubectl port-forward -n securecodebox-system service/securecodebox-operator-minio --address 0.0.0.0 9001:9001"
        # "AccessKey (admin): sudo kubectl get secret securecodebox-operator-minio -n securecodebox-system -o=jsonpath='{.data.root-user}' | base64 --decode; echo"
        # "SecretKey (Password): kubectl get secret securecodebox-operator-minio -n securecodebox-system -o=jsonpath='{.data.root-password}' | base64 --decode; echo"


# Installing SCB scanners(this is a list of multiple scanners i will only using nmap, zap, nikto)
helm upgrade --install nmap oci://ghcr.io/securecodebox/helm/nmap
helm upgrade --install cascading-scans oci://ghcr.io/securecodebox/helm/cascading-scans
helm upgrade --install zap-advanced oci://ghcr.io/securecodebox/helm/zap-advanced
cat <<EOF | helm upgrade --install ncrack oci://ghcr.io/securecodebox/helm/ncrack --values -
scannerJob:
  extraVolumes:
    - name: ncrack-lists
      secret:
        secretName: ncrack-lists
  extraVolumeMounts:
    - name: ncrack-lists
      mountPath: "/ncrack/"
cascadingRules:
  enabled: true
EOF
helm upgrade --install semgrep oci://ghcr.io/securecodebox/helm/semgrep
helm upgrade --install wpscan oci://ghcr.io/securecodebox/helm/wpscan
helm upgrade --install whatweb oci://ghcr.io/securecodebox/helm/whatweb


# Listing installed scanners "kubectl get scantypes"


# Installing Vulnerable Scanning Targets 

## Installing juice-shop-app
#kubectl create namespace juice-shop-app
helm upgrade --install juice-shop oci://ghcr.io/securecodebox/helm/juice-shop #--namespace juice-shop-app 

# Apply port forwarding to access the app on localhost with "kubectl --namespace juice-shop-app port-forward service/juice-shop 3000:3000"
# kubectl apply -f juice-shop-ingress.yaml 
# kubectl describe ingress juice-shop-ingress -n juice-shop-app

## Installing the ol-wordpress-app
#kubectl create namespace old-wordpress-app
helm upgrade --install old-wordpress oci://ghcr.io/securecodebox/helm/old-wordpress #--namespace old-wordpress-app





















