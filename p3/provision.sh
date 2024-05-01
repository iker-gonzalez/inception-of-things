#!/bin/bash

# Check if the cluster already exists
if ! k3d cluster list | grep -q 'mycluster'; then
  # Create a new k3d cluster
  k3d cluster create mycluster
else
  echo "Cluster 'mycluster' already exists."
fi

# Write the kubeconfig file and switch context
#k3d kubeconfig write mycluster --kubeconfig-switch-context

# Check if the kubeconfig file exists
KUBECONFIG=~/.kube/config
if [ ! -f "$KUBECONFIG" ]; then
  echo "Kubeconfig file not found at $KUBECONFIG"
  exit 1
fi

# Create namespace 'argocd' if it doesn't exist
if ! kubectl get namespace argocd > /dev/null 2>&1; then
  kubectl create namespace argocd
fi

# Create namespace 'dev' if it doesn't exist
if ! kubectl get namespace dev > /dev/null 2>&1; then
  kubectl create namespace dev
fi

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

# Forward the wils-app service port
echo "Forwarding the wils-app service port to localhost:8888..."
kubectl -n dev port-forward svc/wils-app 8888:8888 &

# Forward the ArgoCD server port
echo "Forwarding the ArgoCD server port to localhost:8080..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

# Print ArgoCD initial admin username and password
echo "ArgoCD initial admin credentials:"
echo "Username: admin"
echo -n "Password: "
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo