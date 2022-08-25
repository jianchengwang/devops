#!/bin/bash

# chrono @ 2022-04

# https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-init/

# init k8s
# --apiserver-advertise-address=192.168.10.210
kubeadm init \
--apiserver-advertise-address=192.168.3.150 \
--image-repository registry.aliyuncs.com/google_containers \
--service-cidr=10.96.0.0/12 \
--pod-network-cidr=10.244.0.0/16

# enable kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# check
kubectl version
kubectl get node

# kubeadm join 192.168.10.210:6443 --token tlx8h6.nqq9ae0x6n311ur2 \
#   --discovery-token-ca-cert-hash sha256:3ad1e8a51484ec125e2394f03eb3c0429f467a88b432a9408faef6d00f197e87

# get join token
# kubeadm token list
# kubeadm token create --print-join-command
# openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'

