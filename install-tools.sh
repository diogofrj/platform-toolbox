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
echo -e "${YELLOW}Pre-requisitos:${NC}"
echo " 1 - jq"
echo " 2 - curl"
echo " 3 - git"
echo " 4 - unzip"
echo ""
echo -e "${YELLOW}HashiCorp Tools:${NC}"
echo " 10 - HashiCorp Consul 🌐"
echo " 11 - HashiCorp Packer 💿"
echo " 12 - HashiCorp Vault 🔐"
echo " 13 - HashiCorp Vagrant 🛠️"
echo " 14 - HashiCorp Terraform 🌍"
echo " 15 - HashiCorp Nomad 🌐"
echo " 16 - HashiCorp Boundary 🔐"
echo " 17 - HashiCorp Boundary Desktop 🌐"
echo ""
echo -e "${YELLOW}Terraform Tools:${NC}"
echo " 20 - Checkov (Terraform Security Scanner) 🔍"
echo " 21 - Terraform-docs (Terraform Documentation Generator) 📜"
echo " 22 - Terragrunt (Terraform CLI) 📜"
echo " 23 - Terramaid (Terraform Diagrammer) 📜"
echo " 24 - Tfswitch (Terraform Version Manager) 📜"
echo " 25 - Infracost (Terraform Cost Estimation) 💰"
echo " 26 - tflint (Terraform Linter) 📜"
echo " 27 - Diagrams (Terraform Diagrammer) 📜"
echo " 28 - Trivy (Terraform Security Scanner) 🔍"
echo ""
echo -e "${YELLOW}Cloud Tools:${NC}"
echo " 30 - Azure CLI (Azure Command Line Interface) ☁️"
echo " 31 - Azure Developer CLI (Azure Developer CLI) 🔧"
echo " 32 - Azure Quick Review (Azure Quick Review) 🔍"
echo " 33 - AzCopy (Azure Storage CLI) 📡"
echo " 34 - AWS CLI (Amazon Web Services Command Line Interface) ☁️" 
echo " 35 - Google Cloud SDK (Google Cloud SDK) ☁️"
echo ""
echo -e "${YELLOW}Kubernetes Tools:${NC}"
echo " 40 - kubectl + Krew (Kubectl Plugin Manager) ☸️"
echo " 41 - Kustomize (Kubernetes Customization) 🔧"
echo " 42 - k3s (Kubernetes in Docker) 🐍"
echo " 43 - k9s (Kubernetes CLI) 👀"
echo " 44 - Helm (Kubernetes Package Manager) ⛵"
echo " 45 - Minikube (Kubernetes in Docker) 🐶"
echo " 46 - KIND (Kubernetes in Docker) 🐶"
echo ""
echo -e "${YELLOW}Other Tools:${NC}"
echo " 50 - Ansible (Automation Tool) 📜"
echo " 51 - Docker + LazyDocker (Docker Container Manager) 🐳"
echo " 52 - GitLab Runner (CI/CD) 🏃‍♂️"
echo " 53 - ArgoCD (GitOps) 📜"
echo " 54 - Github CLI (Github Command Line Interface) 📜"
echo " 55 - Pre-commit-hooks (Git Hooks) 📜"
echo ""
echo -e "${YELLOW}Web Tools:${NC}"
echo " 60 - Jenkins (CI/CD) 🏗️"
echo ""
echo -e "${YELLOW}UI Desktop Tools:${NC}"
echo " 70 - Insomnia (API Client) 📡"
echo " 71 - Postman (API Client) 📮"
echo " 72 - VS Codium (Code Editor) 🗒️"
echo " 73 - VirtualBox (Virtual Machine Manager) 💾"
echo ""
echo -e "${YELLOW}Opções de Instalação em Grupo:${NC}"
echo " 90 - Instalar TODOS os pré-requisitos"
echo " 91 - Instalar TODAS as ferramentas HashiCorp 🏢"
echo " 92 - Instalar TODAS as ferramentas Terraform 🌍"
echo " 93 - Instalar TODAS as ferramentas Cloud ☁️"
echo " 94 - Instalar TODAS as ferramentas Kubernetes ⛵"
echo " 95 - Instalar TODAS as Other Tools 🛠️"
echo " 96 - Instalar TODAS as Web Tools 🌐"
echo " 97 - Instalar TODAS as UI Desktop Tools 🖥️"
echo " 99 - Instalar TODAS as ferramentas"
echo ""

read -p "Digite o número correspondente à sua escolha: " tool_choice
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Funções de instalação dos pré-requisitos
install_jq() {
    echo -e "${GREEN}Instalando jq...${NC}"
    sudo apt-get install jq -y
    echo -e "${GREEN}jq instalado com sucesso!${NC}"
}
install_curl() {
    echo -e "${GREEN}Instalando curl...${NC}"
    sudo apt-get install curl -y
    echo -e "${GREEN}curl instalado com sucesso!${NC}"
}
install_git() {
    echo -e "${GREEN}Instalando git...${NC}"
    sudo apt-get install git -y
    echo -e "${GREEN}git instalado com sucesso!${NC}"
}
install_unzip() {
    echo -e "${GREEN}Instalando unzip...${NC}"
    sudo apt-get install unzip -y
    echo -e "${GREEN}unzip instalado com sucesso!${NC}"
}
install_all_prerequisites() {
    echo -e "${GREEN}Instalando todos os pré-requisitos...${NC}"
    install_jq
    install_curl
    install_git
    install_unzip
    echo -e "${GREEN}Todos os pré-requisitos foram instalados com sucesso!${NC}"
}
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Funções de instalação das ferramentas HashiCorp
install_consul() {
    echo -e "${GREEN}Instalando HashiCorp Consul...${NC}"
    
    # Obtém a última versão do Consul através da API do GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/hashicorp/consul/releases/latest | jq -r .tag_name | sed 's/v//')
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do Consul${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando Consul versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://releases.hashicorp.com/consul/${LATEST_VERSION}/consul_${LATEST_VERSION}_linux_amd64.zip"; then
        echo -e "${RED}Erro ao baixar o Consul. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    
    # Verifica se o arquivo existe e tem tamanho maior que zero
    if [ -f "consul_${LATEST_VERSION}_linux_amd64.zip" ] && [ -s "consul_${LATEST_VERSION}_linux_amd64.zip" ]; then
        unzip "consul_${LATEST_VERSION}_linux_amd64.zip"
        sudo mv consul /usr/local/bin/
        rm -f "consul_${LATEST_VERSION}_linux_amd64.zip" LICENSE.txt
        echo -e "${GREEN}HashiCorp Consul ${LATEST_VERSION} instalado com sucesso!${NC}"
    else
        echo -e "${RED}Arquivo zip do Consul não foi baixado corretamente${NC}"
        return 1
    fi
}

install_packer() {
    echo -e "${GREEN}Instalando HashiCorp Packer...${NC}"
    
    # Obtém a última versão do Packer através da API do GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/hashicorp/packer/releases/latest | jq -r .tag_name | sed 's/v//')
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do Consul${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando Packer versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://releases.hashicorp.com/packer/${LATEST_VERSION}/packer_${LATEST_VERSION}_linux_amd64.zip"; then
        echo -e "${RED}Erro ao baixar o Packer. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    
    # Verifica se o arquivo existe e tem tamanho maior que zero
    if [ -f "packer_${LATEST_VERSION}_linux_amd64.zip" ] && [ -s "packer_${LATEST_VERSION}_linux_amd64.zip" ]; then
        unzip "packer_${LATEST_VERSION}_linux_amd64.zip"
        sudo mv packer /usr/local/bin/
        rm -f "packer_${LATEST_VERSION}_linux_amd64.zip" LICENSE.txt
        echo -e "${GREEN}HashiCorp Packer ${LATEST_VERSION} instalado com sucesso!${NC}"
    else
        echo -e "${RED}Arquivo zip do Packer não foi baixado corretamente${NC}"
        return 1
    fi
}

install_vault() {
    echo -e "${GREEN}Instalando HashiCorp Vault...${NC}"
    
    # Obtém a última versão do Vault através da API do GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/hashicorp/vault/releases/latest | jq -r .tag_name | sed 's/v//')
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do Consul${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando Vault versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://releases.hashicorp.com/vault/${LATEST_VERSION}/vault_${LATEST_VERSION}_linux_amd64.zip"; then
        echo -e "${RED}Erro ao baixar o Vault. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    
    # Verifica se o arquivo existe e tem tamanho maior que zero
    if [ -f "vault_${LATEST_VERSION}_linux_amd64.zip" ] && [ -s "vault_${LATEST_VERSION}_linux_amd64.zip" ]; then
        unzip "vault_${LATEST_VERSION}_linux_amd64.zip"
        sudo mv vault /usr/local/bin/
        rm -f "vault_${LATEST_VERSION}_linux_amd64.zip" LICENSE.txt
        echo -e "${GREEN}HashiCorp Vault ${LATEST_VERSION} instalado com sucesso!${NC}"
    else
        echo -e "${RED}Arquivo zip do Vault não foi baixado corretamente${NC}"
        return 1
    fi
}

install_vagrant() {
    echo -e "${GREEN}Instalando HashiCorp Vagrant...${NC}"
    
    # Obtém a última versão do Vagrant através da API do GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/hashicorp/vagrant/releases/latest | jq -r .tag_name | sed 's/v//')
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do Consul${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando Vagrant versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://releases.hashicorp.com/vagrant/${LATEST_VERSION}/vagrant_${LATEST_VERSION}_linux_amd64.zip"; then
        echo -e "${RED}Erro ao baixar o Vagrant. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    
    # Verifica se o arquivo existe e tem tamanho maior que zero
    if [ -f "vagrant_${LATEST_VERSION}_linux_amd64.zip" ] && [ -s "vagrant_${LATEST_VERSION}_linux_amd64.zip" ]; then
        unzip "vagrant_${LATEST_VERSION}_linux_amd64.zip"
        sudo mv vagrant /usr/local/bin/
        rm -f "vagrant_${LATEST_VERSION}_linux_amd64.zip" LICENSE.txt
        echo -e "${GREEN}HashiCorp Vagrant ${LATEST_VERSION} instalado com sucesso!${NC}"
    else
        echo -e "${RED}Arquivo zip do Vagrant não foi baixado corretamente${NC}"
        return 1
    fi
}
install_terraform() {
    echo -e "${GREEN}Instalando HashiCorp Terraform...${NC}"
    
    # Obtém a última versão do Terraform através da API do GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r .tag_name | sed 's/v//')
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do Consul${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando Terraform versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://releases.hashicorp.com/terraform/${LATEST_VERSION}/terraform_${LATEST_VERSION}_linux_amd64.zip"; then
        echo -e "${RED}Erro ao baixar o Terraform. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    
    # Verifica se o arquivo existe e tem tamanho maior que zero
    if [ -f "terraform_${LATEST_VERSION}_linux_amd64.zip" ] && [ -s "terraform_${LATEST_VERSION}_linux_amd64.zip" ]; then
        unzip "terraform_${LATEST_VERSION}_linux_amd64.zip"
        sudo mv terraform /usr/local/bin/
        rm -f "terraform_${LATEST_VERSION}_linux_amd64.zip" LICENSE.txt
        echo -e "${GREEN}HashiCorp Terraform ${LATEST_VERSION} instalado com sucesso!${NC}"
    else
        echo -e "${RED}Arquivo zip do Terraform não foi baixado corretamente${NC}"
        return 1
    fi
}
install_nomad() {
    echo -e "${GREEN}Instalando HashiCorp Nomad...${NC}"
    
    # Obtém a última versão do Nomad através da API do GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/hashicorp/nomad/releases/latest | jq -r .tag_name | sed 's/v//')
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do Nomad${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando Nomad versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://releases.hashicorp.com/nomad/${LATEST_VERSION}/nomad_${LATEST_VERSION}_linux_amd64.zip"; then
        echo -e "${RED}Erro ao baixar o Nomad. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    
    # Verifica se o arquivo existe e tem tamanho maior que zero
    if [ -f "nomad_${LATEST_VERSION}_linux_amd64.zip" ] && [ -s "nomad_${LATEST_VERSION}_linux_amd64.zip" ]; then
        unzip "nomad_${LATEST_VERSION}_linux_amd64.zip"
        sudo mv nomad /usr/local/bin/
        rm -f "nomad_${LATEST_VERSION}_linux_amd64.zip" LICENSE.txt
        echo -e "${GREEN}HashiCorp Nomad ${LATEST_VERSION} instalado com sucesso!${NC}"
    else
        echo -e "${RED}Arquivo zip do Nomad não foi baixado corretamente${NC}"
        return 1
    fi
}

install_boundary() {
    echo -e "${GREEN}Instalando HashiCorp Boundary...${NC}"
    
    # Obtém a última versão do Boundary através da API do GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/hashicorp/boundary/releases/latest | jq -r .tag_name | sed 's/v//')
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do Boundary${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando Boundary versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://releases.hashicorp.com/boundary/${LATEST_VERSION}/boundary_${LATEST_VERSION}_linux_amd64.zip"; then
        echo -e "${RED}Erro ao baixar o Boundary. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    
    # Verifica se o arquivo existe e tem tamanho maior que zero
    if [ -f "boundary_${LATEST_VERSION}_linux_amd64.zip" ] && [ -s "boundary_${LATEST_VERSION}_linux_amd64.zip" ]; then
        unzip "boundary_${LATEST_VERSION}_linux_amd64.zip"
        sudo mv boundary /usr/local/bin/
        rm -f "boundary_${LATEST_VERSION}_linux_amd64.zip" LICENSE.txt
        echo -e "${GREEN}HashiCorp Boundary ${LATEST_VERSION} instalado com sucesso!${NC}"
    else
        echo -e "${RED}Arquivo zip do Boundary não foi baixado corretamente${NC}"
        return 1
    fi
}

install_boundary_desktop() {
    echo -e "${GREEN}Instalando HashiCorp Boundary Desktop...${NC}"
    
    # Versão fixa do Boundary Desktop
    BOUNDARY_VERSION="2.2.0"

    echo -e "${YELLOW}Baixando Boundary Desktop versão ${BOUNDARY_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://releases.hashicorp.com/boundary-desktop/${BOUNDARY_VERSION}/boundary-desktop_${BOUNDARY_VERSION}_amd64.deb"; then
        echo -e "${RED}Erro ao baixar o Boundary Desktop. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    
    # Verifica se o arquivo existe e tem tamanho maior que zero
    if [ -f "boundary-desktop_${BOUNDARY_VERSION}_amd64.deb" ] && [ -s "boundary-desktop_${BOUNDARY_VERSION}_amd64.deb" ]; then
        sudo dpkg -i "boundary-desktop_${BOUNDARY_VERSION}_amd64.deb"
        rm -f "boundary-desktop_${BOUNDARY_VERSION}_amd64.deb"
        echo -e "${GREEN}HashiCorp Boundary Desktop ${BOUNDARY_VERSION} instalado com sucesso!${NC}"
    else
        echo -e "${RED}Arquivo deb do Boundary Desktop não foi baixado corretamente${NC}"
        return 1
    fi
}




install_all_hashicorp() {
    echo -e "${GREEN}Instalando todas as ferramentas HashiCorp...${NC}"
    install_consul
    install_packer
    install_vault
    install_vagrant
    install_terraform
    install_nomad
    install_boundary
    install_boundary_desktop
    echo -e "${GREEN}Todas as ferramentas HashiCorp foram instaladas!${NC}"
}
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Funções de instalação das ferramentas Terraform Tools
install_checkov() {
    echo -e "${GREEN}Instalando Checkov...${NC}"
    
    # Obtém a última versão do Checkov através da API do GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/bridgecrewio/checkov/releases/latest | jq -r .tag_name)
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do Checkov${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando Checkov versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://github.com/bridgecrewio/checkov/releases/download/${LATEST_VERSION}/checkov_linux_X86_64.zip"; then
        echo -e "${RED}Erro ao baixar o Checkov. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    
    # Torna o binário executável e move para /usr/local/bin
    unzip "checkov_linux_X86_64.zip"
    sudo mv dist/checkov /usr/local/bin/
    rm -rf dist "checkov_linux_X86_64.zip" LICENSE.txt
    
    echo -e "${GREEN}Checkov ${LATEST_VERSION} instalado com sucesso!${NC}"
}

install_terraform_docs() {
    echo -e "${GREEN}Instalando Terraform Docs...${NC}"
    
    # Obtém a última versão do Terraform Docs através da API do GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | jq -r .tag_name)
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do Terraform Docs${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando Terraform Docs versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://github.com/terraform-docs/terraform-docs/releases/download/${LATEST_VERSION}/terraform-docs-${LATEST_VERSION}-linux-amd64.tar.gz"; then
        echo -e "${RED}Erro ao baixar o Terraform Docs. Verifique sua conexão com a internet.${NC}"
        return 1
    fi

    # Torna o binário executável e move para /usr/local/bin
    tar -xzf "terraform-docs-${LATEST_VERSION}-linux-amd64.tar.gz"
    sudo mv terraform-docs /usr/local/bin/
    rm -rf "terraform-docs-${LATEST_VERSION}-linux-amd64.tar.gz" LICENSE*
    
    echo -e "${GREEN}Terraform Docs ${LATEST_VERSION} instalado com sucesso!${NC}"
}

install_terragrunt() {
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

install_terramaid () {
  curl -1sLf \\n  'https://dl.cloudsmith.io/public/rosesecurity/terramaid/setup.deb.sh' \\n  | sudo -E bash
  sudo apt-get install terramaid
  #sudo mv /usr/bin/Terramaid /usr/local/bin/terramaid || true
  INSTALLED_VERSION=$(terramaid version)
    echo -e "${GREEN}✅ Terramaid ${INSTALLED_VERSION} instalado com sucesso!${NC}"
}

install_tfswitch() {
    echo -e "${GREEN}Instalando Terraform Switcher...${NC}"
    
    # Remove o link simbólico existente do Terraform, se houver
    if [ -L "/usr/local/bin/terraform" ]; then
        sudo unlink /usr/local/bin/terraform
        sudo rm -f /usr/local/bin/terraform
        sudo rm -rf /home/$USER/.terraform.versions
    fi

    # Obtém a última versão do Terraform através da API do GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/warrensbox/terraform-switcher/releases/latest | jq -r .tag_name)
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do Terraform Switcher${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando Terraform Switcher versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://github.com/warrensbox/terraform-switcher/releases/download/${LATEST_VERSION}/terraform-switcher_${LATEST_VERSION}_linux_amd64.tar.gz"; then
        echo -e "${RED}Erro ao baixar o Terraform Switcher. Verifique sua conexão com a internet.${NC}"
        return 1
    fi
    
    # Verifica se o arquivo existe e tem tamanho maior que zero
    if [ -f "terraform-switcher_${LATEST_VERSION}_linux_amd64.tar.gz" ] && [ -s "terraform-switcher_${LATEST_VERSION}_linux_amd64.tar.gz" ]; then
        tar -xzf "terraform-switcher_${LATEST_VERSION}_linux_amd64.tar.gz"
        sudo mv tfswitch /usr/local/bin/
        rm -rf "terraform-switcher_${LATEST_VERSION}_linux_amd64.tar.gz" LICENSE* CHANGELOG* README.md
        # sudo unlink /usr/local/bin/terraform
        echo -e "${GREEN}Terraform Switcher ${LATEST_VERSION} instalado com sucesso!${NC}"
    else
        echo -e "${RED}Arquivo zip do Terraform Switcher não foi baixado corretamente${NC}"
        return 1
    fi




    # git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
    # # Verifica qual shell está sendo usado
    # if [ -n "$BASH_VERSION" ]; then
    #     echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc
    #     echo -e "${GREEN}Configuração adicionada ao .bashrc${NC}"
    # elif [ -n "$ZSH_VERSION" ]; then
    #     echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.zshrc
    #     echo -e "${GREEN}Configuração adicionada ao .zshrc${NC}"
    # else
    #     echo -e "${YELLOW}Shell não identificado. Adicione manualmente ao seu arquivo de configuração:${NC}"
    #     echo 'export PATH="$HOME/.tfenv/bin:$PATH"'
    # fi
    
}

install_infracost() {
    echo "Installing Infracost..."
    curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
    echo -e "${GREEN}Infracost instalado com sucesso!${NC}"
}

install_tflint () {
    echo "Installing TFLint..."
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
    echo -e "${GREEN}TFLint instalado com sucesso!${NC}"
}

install_trivy() {
    echo "Installing Trivy..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh
    
    mv -iv ./bin/trivy ~/.local/bin/
    rm -rf ./bin
    echo -e "${GREEN}Trivy instalado com sucesso!${NC}"
}

install_all_terraform_tools() {
    echo -e "${GREEN}Instalando todas as ferramentas Terraform...${NC}"
    install_checkov
    install_terraform_docs
    install_terragrunt
    install_terramaid
    install_tfswitch
    install_infracost
    install_tflint
    install_trivy
    echo -e "${GREEN}Todas as ferramentas Terraform foram instaladas!${NC}"
}
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Funções de instalação das ferramentas Cloud Tools
install_azurecli() {
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    echo -e "${GREEN}Azure CLI instalado com sucesso!${NC}"
}
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
install_azcopy() {
    curl -L https://aka.ms/downloadazcopy-v10-linux -o azcopy.tar.gz && tar -xvf azcopy.tar.gz && sudo cp ./azcopy_linux_amd64_*/azcopy /usr/local/bin/ && sudo chmod 755 /usr/local/bin/azcopy && rm -rf azcopy.tar.gz azcopy_linux_amd64_*
    echo -e "${GREEN}AzCopy instalado com sucesso!${NC}"
}
install_awscli() {
    sudo apt install zip -y
    sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo unzip awscliv2.zip
    sudo ./aws/install --update
    sudo rm -rf awscliv2.zip aws
    echo -e "${GREEN}AWS CLI instalado com sucesso!${NC}"
}
install_gcloud() {
    sudo apt install apt-transport-https ca-certificates gnupg curl -y
    sudo curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt update && sudo apt install google-cloud-cli -y
    echo -e "${GREEN}Google Cloud SDK instalado com sucesso!${NC}"
}
install_all_cloud_tools() {
    echo -e "${GREEN}Instalando todas as ferramentas Cloud...${NC}"
    install_azurecli
    install_azdevcli
    install_azqr
    install_azcopy
    install_awscli
    install_gcloud
    echo -e "${GREEN}Todas as ferramentas Cloud foram instaladas!${NC}"
}
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Funções de instalação das ferramentas Kubernetes Tools
install_kubectl() {
    sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    echo -e "${GREEN}kubectl instalado com sucesso!${NC}"
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.4.4/krew-linux_amd64.tar.gz" && tar zxvf krew-linux_amd64.tar.gz && ./krew-linux_amd64 install krew
    rm -f krew-linux_amd64.tar.gz krew-linux_amd64 LICENSE
    # Verifica qual shell está sendo usado
        if [ -n "$ZSH_VERSION" ]; then
            echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >>~/.zshrc
        elif [ -n "$BASH_VERSION" ]; then
            echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >>~/.bashrc
        fi
        
        echo -e "${GREEN}Krew instalado com sucesso!${NC}"

        # Pergunta se deseja instalar plugins do krew
        read -p "Deseja instalar plugins node-shell e neat no kubectl? (s/n): " install_plugins
        
        if [ "$install_plugins" = "s" ] || [ "$install_plugins" = "S" ]; then
            echo "Instalando plugins do krew..."
            kubectl krew index add kvaps https://github.com/kvaps/krew-index
            kubectl krew install kvaps/node-shell neat 
            echo -e "${GREEN}Plugins do krew instalados com sucesso!${NC}"
            echo -e "${YELLOW}Para usar o node-shell, execute: kubectl node-shell <node-name>${NC}"
        else
            echo "Instalação de plugins do krew ignorada."
            echo -e "${YELLOW}Para usar o node-shell, execute: kubectl node-shell <node-name>${NC}"
        fi
    

}
# Function to install Kustomize
install_kustomize() {
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
    sudo mv ./kustomize /usr/local/bin/kustomize
    echo -e "${GREEN}Kustomize instalado com sucesso!${NC}"
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
# Function to install k9s
install_k9s() {
    sudo curl -sS https://webinstall.dev/k9s | bash
    echo -e "${GREEN}k9s instalado com sucesso!${NC}"
}
# Function to install Helm
install_helm() {
    sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    sudo chmod 700 get_helm.sh
    sudo ./get_helm.sh
    sudo rm -f get_helm.sh
    echo -e "${GREEN}Helm instalado com sucesso!${NC}"
}
# Function to install minikube
install_minikube() {
    sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    sudo rm -f minikube-linux-amd64 LICENSE
    echo -e "${GREEN}minikube instalado com sucesso!${NC}"
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


install_all_kubernetes() {
    echo -e "${GREEN}Instalando todas as ferramentas Kubernetes...${NC}"
    install_kubectl
    install_krew
    install_kustomize
    install_k3s
    install_k9s
    install_helm
    install_minikube
    install_kind
    echo -e "${GREEN}Todas as ferramentas Kubernetes foram instaladas!${NC}"
}
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Funções de instalação das ferramentas Other Tools
install_ansible() {
    sudo apt install python3-pip -y
    sudo apt install pipx
    pipx install --include-deps ansible --force
    echo -e "${GREEN}Ansible instalado com sucesso!${NC}"
}
install_docker() {
    echo -e "${GREEN}Instalando Docker...${NC}"
    
    # Remove instalações antigas
    sudo apt autoremove -y
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
        sudo apt-get remove -y $pkg
    done

    # Remove pacotes antigos do Docker se existirem
    for pkg in docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras; do
        if dpkg -l | grep -q "^ii  $pkg "; then
            sudo apt-get purge -y $pkg
        fi
    done

    # Remove diretórios do Docker se existirem
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
    sudo rm -f /etc/apt/sources.list.d/docker.list
    sudo rm -f /etc/apt/keyrings/docker.asc

    # Instalando Docker
    sudo apt install -y apt-transport-https ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Adicionando o repositório Docker
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Adiciona o usuário atual ao grupo docker
    sudo usermod -aG docker $USER
    
    # Cria o grupo docker se não existir
    if ! getent group docker > /dev/null; then
        sudo groupadd docker
    fi

    # Configura as permissões do socket do Docker
    sudo chown root:docker /var/run/docker.sock
    sudo chmod 666 /var/run/docker.sock

    # Habilita e inicia o serviço Docker
    sudo systemctl enable docker
    sudo systemctl start docker

    # Verifica a instalação
    echo -e "${YELLOW}Verificando a instalação do Docker...${NC}"
    if docker --version > /dev/null 2>&1; then
        echo -e "${GREEN}Docker instalado com sucesso!${NC}"
        echo -e "${YELLOW}Versão do Docker:${NC}"
        docker --version
    else
        echo -e "${RED}Erro na instalação do Docker${NC}"
        return 1
    fi

    # Mensagem importante para o usuário
    echo -e "${YELLOW}IMPORTANTE: Para que as alterações de permissão tenham efeito, você precisa:${NC}"
    echo -e "1. Fazer logout e login novamente, ou"
    echo -e "2. Executar o comando: ${GREEN}newgrp docker${NC}"
    echo -e "${YELLOW}Deseja executar 'newgrp docker' agora? (s/n)${NC}"
    read -r response
    if [[ "$response" =~ ^([sS])$ ]]; then
        newgrp docker
    fi

    #-----------------------------------------------------
    echo -e "${YELLOW}Instalando LazyDocker...${NC}"
    # LazyDocker Variables
    LATEST_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | jq -r .tag_name)
    
    if [ -z "$LATEST_VERSION" ]; then
        echo -e "${RED}Erro ao obter a versão mais recente do LazyDocker${NC}"
        return 1
    fi

    echo -e "${YELLOW}Baixando LazyDocker versão ${LATEST_VERSION}...${NC}"
    
    # Download direto da fonte oficial
    if ! curl -LO "https://github.com/jesseduffield/lazydocker/releases/download/${LATEST_VERSION}/lazydocker_${LATEST_VERSION//v/}_Linux_x86_64.tar.gz"; then
        echo -e "${RED}Erro ao baixar o LazyDocker. Verifique sua conexão com a internet.${NC}"
        return 1
    fi

    # LazyDocker Install
    tar xzvf "lazydocker_${LATEST_VERSION//v/}_Linux_x86_64.tar.gz" lazydocker
    sudo mv lazydocker /usr/local/bin/
    sudo chmod 755 /usr/local/bin/lazydocker
    sudo rm -rf "lazydocker_${LATEST_VERSION//v/}_Linux_x86_64.tar.gz" LICENSE
}
# Function to install GitLab Runner
install_gitlab_runner() {
    sudo curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
    sudo apt install gitlab-runner -y
    echo -e "${GREEN}GitLab Runner instalado com sucesso!${NC}"
}
# Function to install ArgoCD CLI
install_argocd() {
    # kubectl create namespace argocd
    # kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    # echo -e "${GREEN}ArgoCD instalado com sucesso!${NC}"
    echo -e "${YELLOW}Baixando ArgoCD...${NC}"
    sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 2>&1 | while read -n 1 data; do
        echo -n "."
    done
    echo ""
    echo -e "${YELLOW}Download do ArgoCD concluído!${NC}"
    sudo chmod +x /usr/local/bin/argocd
    echo -e "${GREEN}ArgoCD instalado com sucesso!${NC}"
}
install_gh() {
    # Verifica se wget está instalado, caso contrário instala
    if ! command -v wget &> /dev/null; then
        sudo apt update
        sudo apt install wget -y
    fi

    # Cria diretório para chaves e configura repositório
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

    # Atualiza e instala o GitHub CLI
    sudo apt update
    sudo apt install gh -y
    echo -e "${GREEN}Github CLI instalado com sucesso!${NC}"
}

install_pre_commit_hooks() {
    # Instala python3-pip e python3-venv como pré-requisitos
    sudo apt install python3-pip python3-venv pipx -y
   
    # Instala pre-commit usando pipx
    pipx install pre-commit --force
    
    echo -e "${GREEN}Pre-commit instalado com sucesso!${NC}"
}

install_all_other_tools() {
    echo -e "${GREEN}Instalando todas as Other Tools...${NC}"
    install_ansible
    install_docker
    install_gitlab_runner
    install_argocd
    install_gh
    install_pre_commit_hooks
    echo -e "${GREEN}Todas as Other Tools foram instaladas!${NC}"
}
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Funções de instalação das ferramentas Web Tools
install_jenkins() {
    echo -e "${YELLOW}Instalando Java JDK...${NC}"
    sudo apt update
    sudo apt install fontconfig openjdk-17-jre -y
    
    echo -e "${YELLOW}Instalando Jenkins...${NC}"
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins -y
    
    # Aguarda alguns segundos para o serviço inicializar
    sleep 5
    
    # Inicia e habilita o serviço
    sudo systemctl start jenkins.service
    sudo systemctl enable jenkins.service
    
    # Verifica o status do serviço
    if sudo systemctl is-active --quiet jenkins; then
        echo -e "${GREEN}Jenkins instalado e iniciado com sucesso!${NC}"
        echo -e "${YELLOW}Para acessar o Jenkins, abra o navegador e acesse: http://localhost:8080${NC}"
        echo -e "${YELLOW}A senha inicial de administrador pode ser encontrada em: sudo cat /var/lib/jenkins/secrets/initialAdminPassword${NC}"
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    else
        echo -e "${RED}Erro ao iniciar o Jenkins. Verifique os logs com: sudo journalctl -xeu jenkins.service${NC}"
        return 1
    fi
}
install_all_web_tools() {
    echo -e "${GREEN}Instalando todas as Web Tools...${NC}"
    install_jenkins
    echo -e "${GREEN}Todas as Web Tools foram instaladas!${NC}"
}
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Funções de instalação das ferramentas UI Desktop Tools
# Function to install Insomnia
install_insomnia() {
    # Add to sources
    curl -1sLf 'https://packages.konghq.com/public/insomnia/setup.deb.sh' | sudo -E distro=ubuntu codename=focal bash
    # Refresh repository sources and install Insomnia
    sudo apt-get update
    sudo apt-get install insomnia
    echo -e "${GREEN}Insomnia instalado com sucesso!${NC}"
}
# Function to install Postman
install_postman() {
    echo -e "${YELLOW}Instalando Postman...${NC}"
    wget -O postman-linux-x64.tar.gz https://dl.pstmn.io/download/latest/linux_64
    sudo mkdir -p /opt/apps
    sudo tar -xzf postman-linux-x64.tar.gz -C /opt/apps/
    sudo ln -sf /opt/apps/Postman/Postman /usr/local/bin/postman
    curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | sh
    
    # Criar atalho no desktop
    cat > ~/Desktop/postman.desktop << EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/apps/Postman/Postman
Icon=/opt/apps/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL
    
    # Tornar o arquivo executável
    chmod +x ~/Desktop/postman.desktop
    
    echo -e "${GREEN}Postman e Postman CLI instalado com sucesso!${NC}"
    echo -e "${GREEN}Atalho criado no Desktop${NC}"
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

install_virtualbox() {
    # Baixa o instalador do VirtualBox
    wget https://download.virtualbox.org/virtualbox/7.1.4/VirtualBox-7.1.4-165100-Linux_amd64.run
    
    # Torna o arquivo executável
    chmod +x VirtualBox-7.1.4-165100-Linux_amd64.run
    
    # Executa o instalador
    sudo ./VirtualBox-7.1.4-165100-Linux_amd64.run
    
    # Remove o instalador após a instalação
    rm VirtualBox-7.1.4-165100-Linux_amd64.run
    
    # Adiciona o usuário atual ao grupo vboxusers
    sudo usermod -aG vboxusers $USER
    
    echo -e "${GREEN}VirtualBox instalado com sucesso!${NC}"
    echo -e "${YELLOW}Você precisa fazer logout e login novamente para que as alterações de grupo tenham efeito.${NC}"
}


install_all_ui_tools() {
    echo -e "${GREEN}Instalando todas as UI Desktop Tools...${NC}"
    install_insomnia
    install_postman
    install_vscodium
    install_virtualbox
    echo -e "${GREEN}Todas as UI Desktop Tools foram instaladas!${NC}"
}
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Função para instalar todas as ferramentas
install_all() {
    echo -e "${GREEN}Instalando TODAS as ferramentas...${NC}"
    install_all_prerequisites
    install_all_hashicorp
    install_all_terraform_tools
    install_all_cloud_tools
    install_all_kubernetes
    install_all_other_tools
    install_all_web_tools
    install_all_ui_tools
    echo -e "${GREEN}Todas as ferramentas foram instaladas com sucesso!${NC}"
}

#----------------------------------------------------------------------------------------------------------------------------------------------------
# Modificar o case statement para incluir as novas opções
case $tool_choice in
    # Pré-requisitos
    1) install_jq ;;
    2) install_curl ;;
    3) install_git ;;
    4) install_unzip ;;
    5) install_all_prerequisites ;;

    # HashiCorp Tools
    10) install_consul ;;
    11) install_packer ;;
    12) install_vault ;;
    13) install_vagrant ;;
    14) install_terraform ;;
    15) install_nomad ;;
    16) install_boundary ;;
    17) install_boundary_desktop ;;

    # Terraform Tools
    20) install_checkov ;;
    21) install_terraform_docs ;;
    22) install_terragrunt ;;
    23) install_terramaid ;;
    24) install_tfswitch ;;
    25) install_infracost ;;
    26) install_tflint ;;
    27) install_trivy ;;

    # Cloud Tools
    30) install_azurecli ;;
    31) install_azdevcli ;;
    32) install_azqr ;;
    33) install_azcopy ;;
    34) install_awscli ;;
    35) install_gcloud ;;
    
    # Kubernetes Tools
    40) install_kubectl ;;
    41) install_kustomize ;;
    42) install_k3s ;;
    43) install_k9s ;;
    44) install_helm ;;
    45) install_minikube ;;
    46) install_kind ;;
    
    # Other Tools
    50) install_ansible ;;
    51) install_docker ;;
    52) install_gitlab_runner ;;
    53) install_argocd ;;
    54) install_gh ;;
    55) install_pre_commit_hooks ;;
    # Web Tools
    60) install_jenkins ;;
    
    # UI Desktop Tools
    70) install_insomnia ;;
    71) install_postman ;;
    72) install_vscodium ;;
    73) install_virtualbox ;;
    
    # Instalação em Grupo
    90) install_all_prerequisites ;;
    91) install_all_hashicorp ;;
    92) install_all_terraform_tools ;;
    93) install_all_cloud_tools ;;
    94) install_all_kubernetes ;;
    95) install_all_other_tools ;;
    96) install_all_web_tools ;;
    97) install_all_ui_tools ;;
    99) install_all ;;
    *) echo -e "${RED}Opcão inválida, saindo...${NC}" ;;
esac

