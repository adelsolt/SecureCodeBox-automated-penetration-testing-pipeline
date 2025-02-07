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



# SecureCodeBox Operator
helm --namespace securecodebox-system upgrade --install --create-namespace securecodebox-operator oci://ghcr.io/securecodebox/helm/operator
        # Verified deployment with "sudo kubectl get pods -n securecodebox-system"
        # Port Forward MinIo instance with "kubectl port-forward -n securecodebox-system service/securecodebox-operator-minio 9000:9001"
        # Credientials (admin/password) with "AccessKey (Username): kubectl get secret securecodebox-operator-minio -n securecodebox-system -o=jsonpath='{.data.root-user}' | base64 --decode; echo"
        #                  "SecretKey (Password): kubectl get secret securecodebox-operator-minio -n securecodebox-system -o=jsonpath='{.data.root-password}' | base64 --decode; echo"

# Installing SCB scanners(this is a list of multiple scanners i will only using nmap, zap, nikto)
#helm upgrade --install amass oci://ghcr.io/securecodebox/helm/amass
#helm upgrade --install gitleaks oci://ghcr.io/securecodebox/helm/gitleaks
#helm upgrade --install kube-hunter oci://ghcr.io/securecodebox/helm/kube-hunter
helm upgrade --install nikto oci://ghcr.io/securecodebox/helm/nikto
helm upgrade --install nmap oci://ghcr.io/securecodebox/helm/nmap
#helm upgrade --install ssh-audit oci://ghcr.io/securecodebox/helm/ssh-audit
#helm upgrade --install sslyze oci://ghcr.io/securecodebox/helm/sslyze
#helm upgrade --install trivy oci://ghcr.io/securecodebox/helm/trivy
#helm upgrade --install wpscan oci://ghcr.io/securecodebox/helm/wpscan
helm upgrade --install zap oci://ghcr.io/securecodebox/helm/zap

# Installing Vulnerable Scanning Target Target 
helm upgrade --install juice-shop oci://ghcr.io/securecodebox/helm/juice-shop
#helm upgrade --install old-wordpress oci://ghcr.io/securecodebox/helm/old-wordpress