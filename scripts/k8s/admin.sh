#!/bin/bash

# chrono @ 2022-04

# https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-init/

# 设置yum源
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 安装kubeadm
yum install -y kubelet-1.23.6 kubeadm-1.23.6 kubectl-1.23.6

# check
kubeadm version
kubectl version --client