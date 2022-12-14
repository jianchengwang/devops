#!/bin/bash

# Get real path
BASEDIR=$(cd `dirname $0` && pwd)
cd ${BASEDIR}

# Log Location on Server.
LOG_LOCATION=${BASEDIR}
exec > >(tee -i $LOG_LOCATION/docker-install.`date +%Y%m%d%H%M%S`.log)
exec 2>&1


# 安装Docker
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
# 安装依赖包
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
# 配置Docker安装包仓库
yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# 安装社区版
yum -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
# 升级xfsprogs
yum -y update xfsprogs
# 加入开机自启
systemctl enable docker
# 启动Docker服务
systemctl start docker
# 测试Docker
docker version
docker run hello-world

# 添加镜像加速
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://ed47r0z0.mirror.aliyuncs.com", "https://registry.docker-cn.com"]
}
EOF
# systemctl daemon-reload
systemctl restart docker

# 安装docker compose
yum update -y nss curl libcurl
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# cp docker-compose-Linux-x86_64 /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose version

# 安装工具软件
yum -y install git net-tools dos2unix sshpass zip unzip

# 安装应用
#docker-compose up -d
# 查看应用列表
#docker-compose ps -a

#cd /root
#ssh-keygen -t rsa -C "jiancheng_wang@yahoo.com"
#cat /root/.ssh/id_rsa.pub
