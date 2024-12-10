#!/bin/bash
#by: @diogo-fernandes_enterprise @diogofrj 🐙"
set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Welcome Message
echo ""
echo -e "${GREEN}Instalando ferramentas necessárias para o Platform Engineer Toolbox${NC}"
echo ""
echo -e "${YELLOW}Command Line Tools:${NC}"
echo " 1 - Ansible 📜"
echo " 2 - AWS CLI ☁️" 
echo " 3 - Azure CLI ☁️"
echo " 4 - Azure Developer CLI 🔧"
echo " 5 - Azure Quick Review 🔍"
echo " 6 - AzCopy 📡"
echo " 7 - Docker + LazyDocker 🐳"
echo " 8 - GitLab Runner 🏃‍♂️"
echo " 9 - Google Cloud SDK ☁️"
echo " 10 - HashiCorp Consul 🌐"
echo " 11 - HashiCorp Packer 💿"
echo " 12 - HashiCorp Vault 🔐"
echo " 13 - HashiCorp Vagrant 🛠️"
echo " 14 - Helm ⛵"
echo " 15 - Infracost 💰"
echo " 16 - k3s 🐍"
echo " 17 - k9s 👀"
echo " 18 - Krew 🐶"
echo " 19 - kubectl ☸️"
echo " 20 - Kustomize 🔧"
echo " 21 - minikube 🏗️"
echo " 22 - KIND 🐶"
echo " 23 - HashiCorp Terraform 🌍"
echo " 24 - Terraform Tools | Checkov 🔍"
echo " 25 - Terraform-docs 📜"
echo " 26 - ArgoCD 📜"
echo " 27 - Terragrunt 📜"
echo -e "${YELLOW}Web Tools:${NC}"
echo " 28 - Jenkins 🏗️"
echo -e "${YELLOW}UI Desktop Tools:${NC}"
echo " 29 - Insomnia 📡"
echo " 30 - Postman 📮"
echo " 31 - VS Codium 🗒️"
echo " 32 - VirtualBox 💾"
echo " 00 - Install ALL tools"
echo ""
read -p "Enter the number corresponding to your choice: " tool_choice

# Function to install Docker
install_docker() {
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # Start and enable Docker
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    DIR="${DIR:-"$HOME/.local/bin"}"
    ARCH=$(uname -m)

    # LazyDocker Variables
    GITHUB_LATEST_VERSION=$(curl -L -s -H 'Accept: application/json' https://github.com/jesseduffield/lazydocker/releases/latest | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
    GITHUB_FILE="lazydocker_${GITHUB_LATEST_VERSION//v/}_$(uname -s)_${ARCH}.tar.gz"
    GITHUB_URL="https://github.com/jesseduffield/lazydocker/releases/download/${GITHUB_LATEST_VERSION}/${GITHUB_FILE}"

    # LazyDocker Install
    sudo curl -L -o lazydocker.tar.gz $GITHUB_URL
    sudo tar xzvf lazydocker.tar.gz lazydocker
    sudo install -Dm 755 lazydocker -t "$DIR"
    sudo rm lazydocker lazydocker.tar.gz

    echo -e "${GREEN}Docker + LazyDocker instalado com sucesso!${NC}"
}

# Function to install kubectl
install_kubectl() {
    sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    echo -e "${GREEN}kubectl instalado com sucesso!${NC}"
}

# Function to install Ansible
install_ansible() {
    sudo apt update
    sudo apt install -y ansible
    echo -e "${GREEN}Ansible instalado com sucesso!${NC}"
}

install_terraform() {
    # Verifica se o Terraform já está instalado
    if command -v terraform &> /dev/null; then
        CURRENT_VERSION=$(terraform version | head -n1 | cut -d' ' -f2 | sed 's/v//')
        echo "Terraform versão ${CURRENT_VERSION} já está instalado."
        echo ""
        echo "O que você deseja fazer?"
        echo "1 - Manter a versão atual (${CURRENT_VERSION})"
        echo "2 - Atualizar para a última versão estável"
        echo "3 - Instalar uma versão específica"
        echo "    Exemplo de formato: 1.5.7, 1.6.0, 1.7.2"
        echo ""
        read -p "Escolha uma opção (1-3): " tf_option

        case $tf_option in
            1)
                echo "Mantendo versão atual ${CURRENT_VERSION}"
                return
                ;;
            2)
                LATEST_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
                VERSION=$LATEST_VERSION
                ;;
            3)
                read -p "Digite a versão desejada (exemplo: 1.5.7): " VERSION
                if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                    echo "Formato de versão inválido. Use o formato: X.Y.Z (exemplo: 1.5.7)"
                    return 1
                fi
                ;;
            *)
                echo "Opção inválida"
                return 1
                ;;
        esac
    else
        # Se não estiver instalado, instala a última versão
        VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
    fi

    echo -e "${YELLOW}Instalando Terraform versão ${VERSION}...${NC}"
    
    # Faz o download e instalação
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt update
    sudo apt install -y terraform-ls
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

    sudo curl -LO "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip"
    unzip "terraform_${VERSION}_linux_amd64.zip"
    sudo mv terraform /usr/local/bin/
    sudo rm -f "terraform_${VERSION}_linux_amd64.zip LICENSE.txt"
    
    # Configura o auto-complete
    terraform -install-autocomplete
    
    # Verifica a instalação
    INSTALLED_VERSION=$(terraform version | head -n1)
    echo -e "${GREEN}✅ Terraform ${INSTALLED_VERSION} instalado com sucesso!${NC}"
}

install_terraform_tools() {
    echo -e "${YELLOW}Instalando Checkov...${NC}"
    pipx install checkov
    echo -e "${YELLOW}Instalando Terraform-docs...${NC}"
    install_terraform_docs
    echo -e "${GREEN}Terraform Tools instalados com sucesso!${NC}"
}


install_terraform_docs() {
    curl -sSLo /tmp/terraform-docs.tar.gz https://terraform-docs.io/dl/v0.19.0/terraform-docs-v0.19.0-$(uname)-amd64.tar.gz
    if [ $? -ne 0 ]; then
        echo -e "${RED}Erro ao baixar terraform-docs. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    tar -xzf /tmp/terraform-docs.tar.gz -C /tmp
    if [ $? -ne 0 ]; then
        echo -e "${RED}Erro ao descompactar terraform-docs.${NC}"
        return 1
    fi
    chmod +x /tmp/terraform-docs
    sudo mv /tmp/terraform-docs /usr/local/bin/terraform-docs
    echo -e "${GREEN}Terraform-docs instalado com sucesso!${NC}"
}

# Function to install AWS CLI
install_awscli() {
    sudo apt install zip -y
    sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo unzip awscliv2.zip
    sudo ./aws/install
    sudo rm -rf awscliv2.zip aws
    echo -e "${GREEN}AWS CLI instalado com sucesso!${NC}"
}

# Function to install Azure CLI
install_azurecli() {
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    echo -e "${GREEN}Azure CLI instalado com sucesso!${NC}"
}

# Function to install Azure Developer CLI
install_azdevcli() {
    sudo curl -fsSL https://aka.ms/install-azd.sh | bash
    echo -e "${GREEN}Azure Developer CLI instalado com sucesso!${NC}"
}

install_azqr() {
    latest_azqr=$(curl -sL https://api.github.com/repos/Azure/azqr/releases/latest | jq -r ".tag_name" | cut -c1-)
    wget https://github.com/Azure/azqr/releases/download/$latest_azqr/azqr-ubuntu-latest-amd64 -O azqr
    chmod +x azqr
    sudo mv azqr /usr/local/bin/azqr
    echo -e "${GREEN}Azure Quick Review instalado com sucesso!${NC}"
    echo -e "${YELLOW}Usage: https://azure.github.io/azqr/docs/usage/${NC}"
}

# Function to install AzCopy
install_azcopy() {
    curl -L https://aka.ms/downloadazcopy-v10-linux -o azcopy.tar.gz && tar -xvf azcopy.tar.gz && sudo cp ./azcopy_linux_amd64_*/azcopy /usr/local/bin/ && sudo chmod 755 /usr/local/bin/azcopy && rm -rf azcopy.tar.gz azcopy_linux_amd64_*
    echo -e "${GREEN}AzCopy instalado com sucesso!${NC}"
}

# Function to install Google Cloud SDK
install_gcloud() {
    sudo apt install apt-transport-https ca-certificates gnupg curl -y
    sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt update && sudo apt install google-cloud-cli -y
    echo -e "${GREEN}Google Cloud SDK instalado com sucesso!${NC}"
}

# Function to install Helm
install_helm() {
    sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    sudo chmod 700 get_helm.sh
    sudo ./get_helm.sh
    sudo rm -f get_helm.sh
    echo -e "${GREEN}Helm instalado com sucesso!${NC}"
}

# Function to install GitLab Runner
install_gitlab_runner() {
    sudo curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
    echo -e "${GREEN}GitLab Runner instalado com sucesso!${NC}"
}

# Function to install HashiCorp Vault
install_vault() {
    sudo wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
    sudo apt update && sudo apt install vault -y
    echo -e "${GREEN}HashiCorp Vault instalado com sucesso!${NC}"
}

# Function to install HashiCorp Consul
install_consul() {
    sudo wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
    sudo apt update && sudo apt install consul -y
    echo -e "${GREEN}HashiCorp Consul instalado com sucesso!${NC}"
}

# Function to install HashiCorp Packer
install_packer() {
    sudo wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
    sudo apt update && sudo apt install packer -y
    echo -e "${GREEN}HashiCorp Packer instalado com sucesso!${NC}"
}

# Function to install Infracost
install_infracost() {
    echo "Installing Infracost..."
    curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
    echo -e "${GREEN}Infracost instalado com sucesso!${NC}"
}

# Function to install k9s
install_k9s() {
    sudo curl -sS https://webinstall.dev/k9s | bash
    echo -e "${GREEN}k9s instalado com sucesso!${NC}"
}

# Function to install minikube
install_minikube() {
    sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    sudo rm -f minikube-linux-amd64
    echo -e "${GREEN}minikube instalado com sucesso!${NC}"
}

# Function to install k3s
install_k3s() {
    # Verifica se está rodando no WSL
    if grep -qi microsoft /proc/version; then
        echo -e "${YELLOW}Atenção: Você está rodando no WSL!${NC}"
        echo -e "${YELLOW}O K3s pode ter problemas no WSL devido a limitações do systemd.${NC}"
        echo -e "${YELLOW}Alternativas recomendadas para WSL:${NC}"
        echo "1 - KIND (Kubernetes in Docker)"
        echo "2 - Minikube"
        echo "3 - Docker Desktop com Kubernetes"
        echo -e "${YELLOW}Deseja continuar com a instalação do K3s mesmo assim? (s/n)${NC}"
        read -p "Resposta: " continue_install
        
        if [ "$continue_install" != "s" ] && [ "$continue_install" != "S" ]; then
            echo -e "${YELLOW}Instalação do K3s cancelada.${NC}"
            return 1
        fi
    fi

    echo -e "${YELLOW}Instalando K3s...${NC}"
    # Instala K3s com permissões adequadas para o kubeconfig
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644" sh -
    
    # Verifica se a instalação foi bem sucedida
    if [ $? -eq 0 ]; then
        # Configura o ambiente para o usuário atual
        mkdir -p $HOME/.kube
        sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
        
        # Adiciona o KUBECONFIG ao perfil do usuário
        if [ -f "$HOME/.bashrc" ]; then
            echo 'export KUBECONFIG=$HOME/.kube/config' >> $HOME/.bashrc
        fi
        if [ -f "$HOME/.zshrc" ]; then
            echo 'export KUBECONFIG=$HOME/.kube/config' >> $HOME/.zshrc
        fi
        
        echo -e "${GREEN}K3s instalado com sucesso!${NC}"
        echo -e "${YELLOW}Configuração do ambiente:${NC}"
        echo "1. O arquivo kubeconfig foi copiado para $HOME/.kube/config"
        echo "2. As permissões foram ajustadas para seu usuário"
        echo "3. A variável KUBECONFIG foi adicionada ao seu perfil"
        echo ""
        echo -e "${YELLOW}Comandos úteis:${NC}"
        echo "  sudo systemctl status k3s    # Verificar status do serviço"
        echo "  kubectl get nodes            # Listar nodes"
        echo "  kubectl get pods -A          # Listar pods em todos os namespaces"
        echo ""
        echo -e "${YELLOW}Para desinstalar:${NC}"
        echo "  /usr/local/bin/k3s-uninstall.sh"
        echo ""
        echo -e "${YELLOW}Para aplicar as alterações no ambiente atual, execute:${NC}"
        echo "  source ~/.bashrc  # se estiver usando bash"
        echo "  source ~/.zshrc   # se estiver usando zsh"
    else
        echo -e "${RED}Erro na instalação do K3s${NC}"
        echo -e "${YELLOW}Verifique os logs do sistema:${NC}"
        echo "  sudo journalctl -xeu k3s"
    fi
}

# Function to VSCodium
install_vscodium() {
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
    echo 'deb [signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
    sudo apt update && sudo apt install -y codium
    echo -e "${GREEN}VSCodium instalado com sucesso!${NC}"
}

# Function to install Postman
install_postman() {
    sudo snap install postman
    curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | sh
    echo -e "${GREEN}Postman e Postman CLI instalado com sucesso!${NC}"
}

# Function to install Kustomize
install_kustomize() {
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
    sudo mv ./kustomize /usr/local/bin/kustomize
    echo -e "${GREEN}Kustomize instalado com sucesso!${NC}"
}

# Function to install Insomnia
install_insomnia() {
    # Add to sources
    curl -1sLf 'https://packages.konghq.com/public/insomnia/setup.deb.sh' | sudo -E distro=ubuntu codename=focal bash
    # Refresh repository sources and install Insomnia
    sudo apt-get update
    sudo apt-get install insomnia
    echo -e "${GREEN}Insomnia instalado com sucesso!${NC}"
}

# Function to install Vagrant
install_vagrant() {
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install vagrant
    echo -e "${GREEN}Vagrant instalado com sucesso!${NC}"
}

# Function to install Krew
install_krew() {
    sudo apt-get install git -y
    (
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.4.4/krew-linux_amd64.tar.gz" && tar zxvf krew-linux_amd64.tar.gz && ./krew-linux_amd64 install krew
        rm -f krew-linux_amd64.tar.gz
        # Verifica qual shell está sendo usado
        if [ -n "$ZSH_VERSION" ]; then
            echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >>~/.zshrc
        elif [ -n "$BASH_VERSION" ]; then
            echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >>~/.bashrc
        fi
        
        echo -e "${GREEN}Krew instalado com sucesso!${NC}"

        # Pergunta se deseja instalar plugins do krew
        read -p "Deseja instalar plugins do krew em algum cluster Kubernetes? (s/n): " install_plugins
        
        if [ "$install_plugins" = "s" ] || [ "$install_plugins" = "S" ]; then
            echo "Instalando plugins do krew..."
            kubectl krew index add kvaps https://github.com/kvaps/krew-index
            kubectl krew install kvaps/node-shell
            echo -e "${GREEN}Plugins do krew instalados com sucesso!${NC}"
            echo -e "${YELLOW}Para usar o node-shell, execute: kubectl node-shell <node-name>${NC}"
        else
            echo "Instalação de plugins do krew ignorada."
            echo -e "${YELLOW}Para usar o node-shell, execute: kubectl node-shell <node-name>${NC}"
        fi
    )
}

install_virtualbox() {
    # Add VirtualBox repository key
    #wget -q -O - http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc | sudo apt-key add -
    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg


    # Add VirtualBox repository to sources list
    sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian raring non-free contrib" >> /etc/apt/sources.list.d/virtualbox.org.list'

    # Update package list and install specified VirtualBox version
    sudo apt-get update
    sudo apt-get install -y virtualbox

    # Add current user to vboxusers group
    sudo usermod -a -G vboxusers $(whoami)

    # Get the installed VirtualBox version
    INSTALLED_VER=$(vboxmanage --version)
    INSTALLED_VER=${INSTALLED_VER%%r*}

    # Download and install the extension pack for the installed version
    wget -O ~/Downloads/Oracle_VM_VirtualBox_Extension_Pack-$INSTALLED_VER.vbox-extpack http://download.virtualbox.org/virtualbox/$INSTALLED_VER/Oracle_VM_VirtualBox_Extension_Pack-$INSTALLED_VER.vbox-extpack
    echo "virtualbox extpack"
    sudo vboxmanage extpack install ~/Downloads/Oracle_VM_VirtualBox_Extension_Pack-$INSTALLED_VER.vbox-extpack

    echo "You must log out and log back in for user group changes to take effect."
}
# Function to install ArgoCD
install_argocd() {
    echo -e "${YELLOW}Baixando ArgoCD...${NC}"
    sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 2>&1 | while read -n 1 data; do
        echo -n "."
    done
    echo ""
    echo -e "${YELLOW}Download do ArgoCD concluído!${NC}"
    sudo chmod +x /usr/local/bin/argocd
    echo -e "${GREEN}ArgoCD instalado com sucesso!${NC}"
}
# FUNÇÃO TERRAGRUNT
install_terragrunt() {
    echo -e "${YELLOW}Instalando Terragrunt...${NC}"
    
    # Verifica se o Terragrunt já está instalado
    if command -v terragrunt &> /dev/null; then
        CURRENT_VERSION=$(terragrunt --version | cut -d' ' -f3)
        echo "Terragrunt versão ${CURRENT_VERSION} já está instalado."
        echo ""
        echo "O que você deseja fazer?"
        echo "1 - Manter a versão atual (${CURRENT_VERSION})"
        echo "2 - Atualizar para a última versão estável"
        read -p "Escolha uma opção (1-2): " tg_option

        case $tg_option in
            1)
                echo "Mantendo versão atual ${CURRENT_VERSION}"
                return
                ;;
            2)
                echo "Atualizando para a última versão..."
                ;;
            *)
                echo "Opção inválida"
                return 1
                ;;
        esac
    fi

    # Obtém a última versão do Terragrunt
    LATEST_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-)
    
    echo -e "${YELLOW}Baixando Terragrunt versão ${LATEST_VERSION}...${NC}"
    
    # Download do binário
    sudo curl -L -o /usr/local/bin/terragrunt \
        "https://github.com/gruntwork-io/terragrunt/releases/download/v${LATEST_VERSION}/terragrunt_linux_amd64"
    
    # Adiciona permissão de execução
    sudo chmod +x /usr/local/bin/terragrunt
    
    # Configura o auto-complete
    terragrunt --install-autocomplete
    
    # Verifica a instalação
    INSTALLED_VERSION=$(terragrunt --version)
    echo -e "${GREEN}✅ Terragrunt ${INSTALLED_VERSION} instalado com sucesso!${NC}"
}

# Função para instalar o KIND
install_kind() {
    echo "Verificando se o KIND está instalado..."
    if ! command -v kind &> /dev/null; then
        echo "Instalando KIND..."
        
        # Detecta a arquitetura do sistema
        ARCH=$(uname -m)
        case $ARCH in
            x86_64)
                ARCH_TAG="amd64"
                ;;
            aarch64)
                ARCH_TAG="arm64"
                ;;
            *)
                echo "Arquitetura não suportada: $ARCH"
                return 1
                ;;
        esac
        
        # Baixa a última versão do KIND
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.25.0/kind-linux-$ARCH_TAG
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind
        
        # Verifica se a instalação foi bem sucedida
        if ! command -v kind &> /dev/null; then
            echo -e "${RED}Erro ao instalar KIND${NC}"
            return 1
        fi
    else
        echo "KIND já está instalado."
        kind version
    fi

    # Pergunta se deseja criar um cluster
    echo -e "\n${YELLOW}Deseja criar um cluster Kubernetes?${NC}"
    echo "1 - Criar cluster simples (1 nó)"
    echo "2 - Criar cluster multi-nós (1 control-plane + 3 workers)"
    echo "3 - Não criar cluster agora"
    read -p "Escolha uma opção (1-3): " cluster_option

    case $cluster_option in
        1)
            echo -e "${YELLOW}Criando cluster simples...${NC}"
            kind create cluster --name kind-single
            echo -e "${GREEN}Cluster simples criado com sucesso!${NC}"
            ;;
        2)
            echo -e "${YELLOW}Criando cluster multi-nós...${NC}"
            # Cria arquivo de configuração
            cat << EOF > $HOME/kind-4nodes.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    listenAddress: "0.0.0.0"
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    listenAddress: "0.0.0.0"
    protocol: TCP
  - containerPort: 8080
    hostPort: 8080
    listenAddress: "0.0.0.0"
    protocol: TCP
- role: worker
- role: worker
- role: worker
EOF
            kind create cluster --name kind-multinodes --config $HOME/kind-4nodes.yaml
            echo -e "${GREEN}Cluster multi-nós criado com sucesso!${NC}"
            ;;
        3)
            echo -e "${YELLOW}Instalação concluída sem criar cluster.${NC}"
            ;;
        *)
            echo -e "${RED}Opção inválida${NC}"
            ;;
    esac

    if [ "$cluster_option" != "3" ]; then
        echo -e "\n${YELLOW}Clusters disponíveis:${NC}"
        kind get clusters
        echo -e "\n${YELLOW}Para interagir com o cluster, use: kubectl get nodes${NC}"
    fi
}

########################################### Function to install all tools ###################################################
install_all() {
    install_ansible
    install_awscli
    install_azurecli
    install_azdevcli
    install_azqr
    install_azcopy
    install_docker
    install_gitlab_runner
    install_gcloud
    install_consul
    install_packer
    install_vault
    install_vagrant
    install_helm
    install_infracost
    install_k3s
    install_k9s
    install_krew
    install_kubectl
    install_kustomize
    install_minikube
    install_kind
    install_terraform
    install_terraform_tools
    install_terraform_docs
    install_argocd
    install_jenkins
    install_insomnia
    install_postman
    install_vscodium
    install_virtualbox
    echo -e "${GREEN}Todas as ferramentas instaladas com sucesso!${NC}"
}



case $tool_choice in
    1) install_ansible ;;
    2) install_awscli ;;
    3) install_azurecli ;;
    4) install_azdevcli ;;
    5) install_azqr ;;
    6) install_azcopy ;;
    7) install_docker ;;
    8) install_gitlab_runner ;;
    9) install_gcloud ;;
    10) install_consul ;;
    11) install_packer ;;
    12) install_vault ;;
    13) install_vagrant ;;
    14) install_helm ;;
    15) install_infracost ;;
    16) install_k3s ;;
    17) install_k9s ;;
    18) install_krew ;;
    19) install_kubectl ;;
    20) install_kustomize ;;
    21) install_minikube ;;
    22) install_kind ;;
    23) install_terraform ;;
    24) install_terraform_docs ;;
    25) install_terraform_tools ;;
    26) install_argocd ;;
    27) install_terragrunt ;;
    28) install_jenkins ;;
    29) install_insomnia ;;
    30) install_postman ;;
    31) install_vscodium ;;
    32) install_virtualbox ;;
    00) install_all ;;
    *) echo -e "${RED}Opção inválida, saindo...${NC}" ;;
esac

