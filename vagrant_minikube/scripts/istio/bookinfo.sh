#!/bin/bash

f_msg(){
    echo "----------------------------------------"
    echo "$1"
    echo "----------------------------------------"
}


f_msg "Configuring label"
kubectl label namespace default istio-injection=enabled
kubectl get ns --show-labels

f_msg "Installing bookinfo app"
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

f_msg "Checking pods and services"
kubectl get pods
kubectl get svc

f_msg "Check that app is running"
kubectl exec -it $(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}') -c ratings -- curl productpage:9080/productpage | grep -o "<title>.*</title>"

f_msg "Ingress gateway"
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl get gateway
kubectl describe gateway bookinfo-gateway
kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml