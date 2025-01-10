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

# Reinicia containerd
systemctl restart containerd
systemctl enable containerd

# Configuração do Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

# Instalação dos pacotes Kubernetes
apt-get update
apt-get install -y kubelet=1.31.0-1.1 kubeadm=1.31.0-1.1 kubectl=1.31.0-1.1
apt-mark hold kubelet=1.31.0-1.1 kubeadm=1.31.0-1.1 kubectl=1.31.0-1.1

# Habilita o encaminhamento IPv4
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
sysctl --system

# Puxa as imagens do Kubernetes
kubeadm config images pull --kubernetes-version=1.31.0

# Inicia o cluster
kubeadm init --kubernetes-version=1.31.0 \
    --pod-network-cidr=192.168.31.0/24 \
    --apiserver-advertise-address=${CONTROL_PLANE_IP}

# Configura o kubeconfig para o root
export KUBECONFIG=/etc/kubernetes/admin.conf

# Configura o kubectl para o usuário vagrant
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Aguarda o apiserver estar pronto (usando kubeconfig explícito)
until kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes; do
    echo "Aguardando apiserver..."
    sleep 10
done

# Instala o Calico usando kubeconfig explícito
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml

# Configurar tolerations para o CoreDNS
kubectl -n kube-system patch deployment coredns --type=json -p='[{"op": "add", "path": "/spec/template/spec/tolerations", "value": [{"key": "node-role.kubernetes.io/master", "effect": "NoSchedule"}, {"key": "node-role.kubernetes.io/control-plane", "effect": "NoSchedule"}]}]'

# Configurar nodeSelector para o CoreDNS
kubectl -n kube-system patch deployment coredns --type=json -p='[{"op": "add", "path": "/spec/template/spec/nodeSelector", "value": {"kubernetes.io/os": "linux"}}]'

# Aguarda os pods do Calico estarem prontos
until kubectl --kubeconfig=/etc/kubernetes/admin.conf get pods -n calico-system | grep -q "Running"; do
    echo "Aguardando pods do Calico..."
    sleep 10
done

# Gera o comando de join e salva em um arquivo
kubeadm token create --print-join-command > /vagrant/join-command.sh
chmod +x /vagrant/join-command.sh
