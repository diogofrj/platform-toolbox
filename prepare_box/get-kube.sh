#!/bin/bash

# Define variáveis
VAGRANT_KEY_PATH="$(pwd)/.vagrant/machines/control-plane/virtualbox/private_key"
CONTROL_PLANE_IP="192.168.56.10"
KUBE_CONFIG_PATH="$HOME/.kube"

# Cria diretório .kube se não existir
mkdir -p "$KUBE_CONFIG_PATH"

# Copia o arquivo de configuração usando a chave privada do Vagrant
scp -i "$VAGRANT_KEY_PATH" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    "vagrant@${CONTROL_PLANE_IP}:/home/vagrant/.kube/config" \
    "$KUBE_CONFIG_PATH/config"

# Ajusta as permissões
chmod 600 "$KUBE_CONFIG_PATH/config"

echo "Kubeconfig copiado para $KUBE_CONFIG_PATH/config"