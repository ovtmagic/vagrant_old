#!/bin/bash


f_msg(){
    echo
    echo "----------------------------------------"
    echo "$1"
    echo "----------------------------------------"
}

#if [[ "$1" == "" ]];then
#    echo "Missing IP address"
#3    exit 0
#fi
ipAddress=${1:-"$(minikube ip)"}
ipMask=${2:-24}

f_msg "IP address: ${ipAddress}"

folder=$(dirname $0)
f_msg $folder
#exit 0

f_msg "Installing MetalLB"
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml
kubectl get pods -n metallb-system

#f_msg "Applying configmap /tmp/${configmapFile}"
#configmapFile="configmap_metallb.yaml"
#cp ${folder}/${configmapFile} /tmp
#sed -i "s/__IP_ADDRESS__/$ipAddress\/${ipMask}/g" /tmp/${configmapFile}
#kubectl get service -n istio-system istio-ingressgateway
#kubectl apply -f /tmp/${configmapFile}

f_msg "Applying configmap /tmp/${configmapFile}"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: custom-ip-space
      protocol: layer2
      addresses:
      - ${ipAddress}/${ipMask}
EOF

f_msg "Checking MetalLB"
kubectl get pods -n metallb-system

f_msg "Checking MetalLB configmap"
kubectl get pods -n metallb-system
kubectl get service -n istio-system istio-ingressgateway
