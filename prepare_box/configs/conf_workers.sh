#!/bin/bash

# Desativa swap
swapoff -a
sed -i '/\s*swap\s/ s/^/#/' /etc/fstab

# Instalação do containerd
apt-get update
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y containerd.io

# Instalação do CNI Plugin
wget https://github.com/containernetworking/plugins/releases/download/v1.5.1/cni-plugins-linux-amd64-v1.5.1.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.5.1.tgz

# Configuração do containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Configura o CNI default
cat <<EOF | tee /etc/cni/net.d/10-containerd-net.conf
{
    "cniVersion": "0.4.0",
    "name": "containerd-net",
    "plugins": [
        {
            "type": "bridge",
            "bridge": "cni0",
            "isGateway": true,
            "ipMasq": true,
            "promiscMode": true,
            "ipam": {
                "type": "host-local",
                "ranges": [
                    [{
                        "subnet": "10.88.0.0/16"
                    }]
                ],
                "routes": [
                    { "dst": "0.0.0.0/0" }
                ]
            }
        },
        {
            "type": "portmap",
            "capabilities": {"portMappings": true}
        }
    ]
}
EOF

# Reinicia containerd
systemctl restart containerd
systemctl enable containerd

# Configuração do Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

# Instalação dos pacotes Kubernetes
apt-get update
apt-get install -y kubelet=1.31.0-1.1 kubeadm=1.31.0-1.1
apt-mark hold kubelet=1.31.0-1.1 kubeadm=1.31.0-1.1

# Habilita o encaminhamento IPv4
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
sysctl --system

# Executa o comando de join se existir
if [ -f "/vagrant/join-command.sh" ]; then
    bash /vagrant/join-command.sh
fi
