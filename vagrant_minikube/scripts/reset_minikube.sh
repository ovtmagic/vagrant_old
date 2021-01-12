#!/bin/bash

kubectlVersion="${1:-v1.17.3}"

f_msg(){
    echo
    echo "--------------------------------------------------------------------------------"
    echo "$1"
    echo "--------------------------------------------------------------------------------"
}

f_error_msg(){
    f_msg "$1"
    exit 1
}

usage(){
    echo "
This script reset minikube installation.
removes minikube and kube configuration and restart minikube

This must be executed as root. Please, run 'sudo -i' first.

It creates a copy of .kube and .minikube folders in folder '/tmp'
after that, you can run script 'copy_minikube_from_root.sh' with your own user to copy minikube configuration to use k8s
commands with your user.

Usage:

  $ ./reset_minikube.sh [-h-|--help]

"
    exit 0
}


# check help
[[ "$1" == "-h" || "$1" == "--help" ]] && usage

# check user root
[[ "$(id -un)" != "root" ]] && f_error_msg "Error. This must be executed as root. Please, run 'sudo -i' first"

f_msg "Minikube is going to be reset"
echo "All minikube information will be deleted"
echo  "Continue (y/n)"
read con

if [ "$con" == "y" ]; then

    f_msg "Getting parameters"

    # Get version of k8s to install
    read -p "Set kubectl version ($kubectlVersion): " pval
    [[ -n "$pval" ]] && kubectlVersion=$pval


    f_msg "Resetting minikube"

    # stop and delete minikube
    minikube stop
    minikube delete
    docker system prune -af
    # remove configuration and files
    rm -fr ~/.kube
    rm -fr ~/.minikube
    rm -rf /var/lib/kubeadm.yaml /data/minikube /var/lib/minikube /var/lib/kubelet /etc/kubernetes

    f_msg " Minikube reset finished"

    f_msg " Starting minikube"
    unset http_proxy https_proxy no_proxy
    minikube start --vm-driver=none --kubernetes-version=${kubectlVersion}
    [[ "$?" != "0" ]] && f_error_msg "Error starting minikube"

    read -p "Upgrade kubectl config for user ${SUDO_USER}(y/n)" upgrade_kubectl
    if [[ "$upgrade_kubectl" == "y" ]]; then
        sudo -i -u ${SUDO_USER}  mkdir -p /home/${SUDO_USER}/.kube
        kubectl config view --flatten | sudo -i -u ${SUDO_USER} tee /home/${SUDO_USER}/.kube/config > /dev/null
    fi

fi
