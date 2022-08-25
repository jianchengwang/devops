#!/bin/bash

# chrono @ 2022-04

# https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# https://kubernetes.io/zh/docs/setup/production-environment/container-runtimes/#docker

# sudo vi /etc/hostname
hostnamectl set-hostname master

# fix docker issue
# wget -qO- https://get.docker.com/ | sh
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O
/etc/yum.repos.d/docker-ce.repo
yum -y install docker-ce
systemctl enable docker && systemctl start docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# firewalld
systemctl stop firewalld
systemctl disable firewalld
sed -i 's/enforcing/disabled/' /etc/selinux/config # 永久
# setenforce 0 # 临时

# iptables
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1 # better than modify /etc/sysctl.conf
EOF

sudo sysctl --system

# Disable Swap
sudo swapoff -a
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

# 时间同步
yum install ntpdate -y
ntpdate time.windows.com

# check

echo "please check these files:"
echo "/etc/docker/daemon.json"
echo "/etc/modules-load.d/k8s.conf"
echo "/etc/sysctl.d/k8s.conf"
echo "cat cat /etc/fstab"