#!/bin/bash

cmd=${1:-restart}

if [[ "${cmd}" == "stop" || "${cmd}" == "restart" ]]; then
    echo "Stopping port-forward"
    if [[ -f /tmp/istio.pids ]]; then
        for i in `cat /tmp/istio.pids`
        do
            echo "stopping pid $i"
            sudo kill -TERM $i
        done
        rm /tmp/istio.pids
    fi
fi

if [[ "${cmd}" == "start" || "${cmd}" == "restart" ]]; then
    echo "Stopping starting-forward"
    grafanaPod=$(kubectl -n istio-system get pods|grep grafana|awk '{print $1;}')
    kialiPod=$(kubectl -n istio-system get pods|grep kiali|awk '{print $1;}')
    ingressPod=$(kubectl -n istio-system get pods|grep istio-ingressgateway|awk '{print $1;}')

    sudo kubectl -n istio-system port-forward ${ingressPod} --address 0.0.0.0 80:80 &
    echo $! >> /tmp/istio.pids
    kubectl -n istio-system port-forward ${grafanaPod} --address 0.0.0.0 3000:3000 &
    echo $! >> /tmp/istio.pids
    kubectl -n istio-system port-forward ${kialiPod} --address 0.0.0.0 20001:20001 &
    echo $! >> /tmp/istio.pids
fi
