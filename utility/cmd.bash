#!/bin/bash
# -*- coding: utf-8 -*-
# Instalar minikube con tres nodos
# Para trabajar con el balanceador de carga Metallb
# Despues de instalar los nodos se debe realizar una cambio en los ns kube-system y kube proxy
# Este la instrccion que realizo
# $ KUBE_EDITOR=nano kubectl edit configmap -n kube-system kube-proxy
# Modificar los parametros de la documentación -> https://metallb.universe.tf/installation/
_create_node() {
    minikube start --nodes 3 -p multinode
}

_add_addons() {
    minikube -p multinode addons enable registry &&
        minikube -p multinode addons enable storage-provisioner &&
        minikube -p multinode addons enable volumesnapshots &&
        minikube -p multinode addons enable metallb &&
        minikube -p multinode addons enable ingress &&
        minikube -p multinode addons enable ingress-dns &&
        minikube -p multinode addons enable default-storageclass &&
        minikube -p multinode addons enable csi-hostpath-driver &&
        minikube -p multinode addons enable dashboard &&
        minikube -p multinode addons enable metrics-server
}

_get_configmap() {
    kubectl get configmap -n kube-system kube-proxy -o yaml | sed -e "s/strictARP: false/strictARP: true/" | sed -e "s/mode: \"\"/mode: \"ipvs\"/" | kubectl apply -f - -n kube-system
}

_change_rol_node() {
    kubectl label node multinode-m02 node-role.kubernetes.io/worker=worker &&
        kubectl label node multinode-m03 node-role.kubernetes.io/worker=worker &&
        kubectl get nodes
}

_change_profile() {
    minikube profile multinode
}

_get_pods_metallb() {
    kubectl get all -n metallb-system
}

_create_lb() {
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml
}

_create_pool() {
    cd ../k8s/metallb/ &&
        kubectl apply -f IPAddressPool.yaml -n metallb-system
}

_create_L2() {
    cd ../k8s/metallb/ &&
        kubectl apply -f L2Advertisement.yaml -n metallb-system
}

_create_registry() {
    kubectl create secret generic regcred --from-file=.dockerconfigjson="$HOME"/.docker/config.json --type=kubernetes.io/dockerconfigjson -n default
}

_validate_function() {
    salida=$?
    if [ $salida -ne 0 ]; then
        if [ $salida -eq 1 ]; then echo "General error"; fi
        if [ $salida -eq 2 ]; then echo "Misuse of shell builtins"; fi
        if [ $salida -eq 126 ]; then echo echo "Command invoked cannot execute"; fi
        if [ $salida -eq 127 ]; then echo "command not found"; fi
        if [ $salida -eq 128 ]; then echo "Invalid argument"; fi
        set -o pipefail
        exit $salida
    else
        echo "Done"
        exit $salida
    fi
}

# this subshell is a scope of try
# try
(
    # this flag will make to exit from current subshell on any error
    # inside it (all functions run inside will also break on any error)
    set -e
    _create_node
    _add_addons
    _change_profile
    _change_rol_node
    _get_configmap
    _get_pods_metallb
    _create_pool
    _create_L2
    _create_registry
    _validate_function
    # do more stuff here
)
# and here we catch errors
# catch
