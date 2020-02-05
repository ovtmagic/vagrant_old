#!/bin/bash

#istioVersion=${1:-1.2.4}
istioVersion=${1:-1.4.3}

f_msg(){
    echo
    echo "----------------------------------------"
    echo "$1"
    echo "----------------------------------------"
}

f_error_msg(){
    f_msg "$1"
    exit 1
}

create_kiali_secret(){
    # kiali user and passwd are "kiali"
    KIALI_USERNAME="a2lhbGk="
    KIALI_PASSPHRASE="a2lhbGk="
    NAMESPACE="istio-system"
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: kiali
  namespace: $NAMESPACE
  labels:
    app: kiali
type: Opaque
data:
  username: $KIALI_USERNAME
  passphrase: $KIALI_PASSPHRASE
EOF
}


# checking tiller
kubectl get pods --all-namespaces|grep tiller
[[ "$?" != "0" ]] && f_error_msg "Tiller is not running"

#setGrafanaKiali=""
setGrafanaKiali="--set grafana.enabled=True --set kiali.enabled=True"

folder=${HOME}/istio
mkdir -p ${folder}
cd ${folder}

f_msg "Getting istio"
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${istioVersion} sh -
#curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.2.4 sh -
cd ./istio-*
sudo mv bin/istioctl /usr/local/bin

# init istio
f_msg "Initializing istio"
kubectl create namespace istio-system
helm install install/kubernetes/helm/istio-init --name istio-init --namespace istio-system
kubectl -n istio-system wait --for=condition=complete job --all

# kiali screct
f_msg "Creating kiali secret"
create_kiali_secret
kubectl describe secret kiali -n istio-system

# install istio
f_msg "Installing istio"
helm install install/kubernetes/helm/istio --name istio --namespace istio-system ${setGrafanaKiali}

# label namespace
f_msg "Setting label istio-injection"
kubectl label namespace default istio-injection=enabled
kubectl get ns --show-labels

# and check
f_msg "Verifying istio installation"
kubectl get pods --namespace=istio-system
kubectl get service -n istio-system istio-ingressgateway