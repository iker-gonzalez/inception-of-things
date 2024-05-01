#!/bin/bash

# Create a new k3d cluster
k3d cluster create mycluster

# Set the KUBECONFIG environment variable
echo 'export KUBECONFIG=$(k3d kubeconfig get mycluster)' >> ~/.zshrc

# Create namespaces
kubectl create namespace argocd
kubectl create namespace dev

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
sleep 30

# Create ArgoCD application
cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: wils-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/iker-gonzalez/ioromero'
    targetRevision: HEAD
    path: .
  destination:
    namespace: dev
    server: 'https://kubernetes.default.svc'
  syncPolicy:
    automated: {}
EOF

# Wait for ArgoCD to sync the application
echo "Waiting for ArgoCD to sync the application..."
sleep 30

# Expose the application on port 8888
kubectl -n dev expose deployment wils-app --type=LoadBalancer --port=8888

# Forward the ArgoCD server port
echo "Forwarding the ArgoCD server port to localhost:8080..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
