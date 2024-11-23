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
echo " 4 - AzCopy 📡"
echo " 5 - Docker + LazyDocker 🐳"
echo " 6 - GitLab Runner 🏃‍♂️"
echo " 7 - Google Cloud SDK ☁️"
echo " 8 - HashiCorp Consul 🌐"
echo " 9 - HashiCorp Packer 💿"
echo " 10 - HashiCorp Vault 🔐"
echo " 11 - HashiCorp Vagrant 🛠️"
echo " 12 - Helm ⛵"
echo " 13 - Infracost 💰"
echo " 14 - k3s 🐍"
echo " 15 - k9s 👀"
echo " 16 - Krew 🐶"
echo " 17 - Kubernetes (kubectl) ☸️"
echo " 18 - Kustomize 🔧"
echo " 19 - minikube 🏗️"
echo " 20 - Terraform 🌍"
echo " 21 - Terraform-docs 📜"
echo -e "${YELLOW}Web Tools:${NC}"
echo " 22 - Jenkins 🏗️"
echo -e "${YELLOW}UI Desktop Tools:${NC}"
echo " 23 - Insomnia 📡"
echo " 24 - Postman 📮"
echo " 25 - VS Codium 🗒️"
echo " 26 - VirtualBox 💾"
echo " 27 - Install ALL tools"
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
    sudo curl -sfL https://get.k3s.io | sh -
    echo -e "${GREEN}k3s instalado com sucesso!${NC}"
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
        set -x; cd "$(mktemp -d)" && OS="$(uname | tr '[:upper:]' '[:lower:]')" && ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && KREW="krew-${OS}_${ARCH}" && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && tar zxvf "${KREW}.tar.gz" && ./"${KREW}" install krew
        echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >>~/.bashrc
        echo -e "${GREEN}Krew instalado com sucesso!${NC}"
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

# Function to install all tools
install_all() {
    install_vscodium
    install_docker
    install_kubectl
    install_ansible
    install_terraform
    install_jenkins
    install_awscli
    install_azurecli
    install_gcloud
    install_helm
    install_gitlab_runner
    install_vault
    install_consul
    install_infracost
    install_k9s
    install_minikube
    install_k3s
    install_postman
    install_kustomize
    install_insomnia
    install_vagrant
    install_krew
    install_terraform_docs
    install_virtualbox
    echo -e "${GREEN}Todas as ferramentas instaladas com sucesso!${NC}"
}

case $tool_choice in
    1) install_docker ;;
    2) install_kubectl ;;
    3) install_ansible ;;
    4) install_terraform ;;
    5) install_terraform_docs ;;
    6) install_jenkins ;;
    7) install_awscli ;;
    8) install_azurecli ;;
    9) install_azcopy ;;
    10) install_gcloud ;;
    11) install_helm ;;
    12) install_gitlab_runner ;;
    13) install_vault ;;
    14) install_consul ;;
    15) install_packer ;;
    16) install_infracost ;;
    17) install_k9s ;;
    18) install_minikube ;;
    19) install_k3s ;;
    20) install_vscodium ;;
    21) install_postman ;;
    22) install_kustomize ;;
    23) install_insomnia ;;
    24) install_vagrant ;;
    25) install_krew ;;
    26) install_virtualbox ;;
    27) install_all ;;
    *) echo -e "${RED}Opção inválida, saindo...${NC}" ;;
esac
