# 🚀 Platform Engineer Toolbox for Ubuntu / Mint

Bem-vindo ao **Platform Engineer Toolbox for Ubuntu/Mint**, um script que automatiza a instalação de ferramentas essenciais para qualquer profissional em um sistema Ubuntu/Mint. Este projeto foi projetado para simplificar o processo de configuração para aqueles que precisam instalar e configurar rapidamente ferramentas Cloud Platform Engineer/DevOps/SRE em suas máquinas.

## 📖 Índice

- [Introdução](#-introdução)
- [Ferramentas Instaladas](#-ferramentas-instaladas) 
- [Pré-requisitos](#-pré-requisitos)
- [Instalação](#-instalação)
- [Uso](#-uso)
- [Configuração do Vagrant](#-configuração-do-vagrant)
- [Contribuindo](#-contribuindo)
- [Licença](#-licença)

## 🛠️ Introdução

Este repositório contém:
- Um script Bash (`install_tools.sh`) que instala ferramentas populares de Plataformas DevOps/SRE em uma máquina Ubuntu.
- Um arquivo de configuração do Vagrant (`Vagrantfile`) para provisionar uma máquina virtual Ubuntu com um clone deste repositório para testes.
Seja configurando um ambiente de desenvolvimento novo ou configurando um pipeline de CI/CD, este script ajuda você a começar rapidamente.

## 🧰 Ferramentas Instaladas

Os scripts instalam as seguintes ferramentas e outras aplicações:

### HashiCorp Tools (10-14):
- 🌐 **HashiCorp Consul**: Service mesh e descoberta de serviços
- 💿 **HashiCorp Packer**: Criação automatizada de imagens
- 🔐 **HashiCorp Vault**: Gerenciador de segredos
- 🛠️ **HashiCorp Vagrant**: Gerenciador de máquinas virtuais
- 🌍 **HashiCorp Terraform**: Software de infraestrutura como código
- 🌍 **HashiCorp Nomad**: Orquestrador de contêineres e aplicativos
- 🔐 **HashiCorp Boundary**: Gerenciador de acesso e segredos
- 🌐 **HashiCorp Boundary Desktop**: Interface gráfica para o Boundary


### Terraform Tools (20-26):
- 🔍 **Checkov**: Scanner de segurança para Terraform
- 📜 **Terraform-docs**: Gerador de documentação para Terraform
- 📜 **Terragrunt**: CLI do Terraform
- 📜 **Terramaid**: Gerador de diagramas para Terraform
- 📜 **Tfswitch**: Gerenciador de versões do Terraform
- 💰 **Infracost**: Estimativa de custos de infraestrutura
- 📜 **TFLint**: Linter para Terraform

### Cloud Tools (30-35):
- ☁️ **Azure CLI**: Interface de linha de comando da Azure
- 🔧 **Azure Developer CLI**: CLI para desenvolvedores Azure
- 🔍 **Azure Quick Review**: Ferramenta de revisão rápida Azure
- 📡 **AzCopy**: Ferramenta de transferência de dados do Azure
- ☁️ **AWS CLI**: Interface de linha de comando da AWS
- ☁️ **Google Cloud SDK**: SDK do Google Cloud Platform

### Kubernetes Tools (40-46):
- ☸️ **kubectl + Krew**: Ferramenta de linha de comando para Kubernetes
- 🔧 **Kustomize**: Gerenciador de configuração Kubernetes
- 🐍 **k3s**: Distribuição leve do Kubernetes
- 👀 **k9s**: Interface TUI para Kubernetes
- ⛵ **Helm**: Gerenciador de pacotes para Kubernetes
- 🐶 **Minikube**: Cluster Kubernetes local
- 🐶 **KIND**: Kubernetes em Docker

### Other Tools (50-54):
- 📜 **Ansible**: Ferramenta de gerenciamento de configuração
- 🐳 **Docker + LazyDocker**: Plataforma de containerização
- 🏃‍♂️ **GitLab Runner**: Executor de CI/CD do GitLab
- 📜 **ArgoCD**: Ferramenta GitOps
- 📜 **GitHub CLI**: Interface de linha de comando do GitHub

### Web Tools (60):
- ⚙️ **Jenkins**: Servidor de automação para CI/CD

### UI Desktop Tools (70-73):
- 📡 **Insomnia**: Cliente de API REST
- 📮 **Postman**: Plataforma de API
- 🗒️ **VS Codium**: Editor de código
- 💾 **VirtualBox**: Gerenciador de máquinas virtuais

### Opções de Instalação em Grupo (90-99):
- 90: Instalar TODOS os pré-requisitos
- 91: Instalar TODAS as ferramentas HashiCorp
- 92: Instalar TODAS as ferramentas Terraform
- 93: Instalar TODAS as ferramentas Cloud
- 94: Instalar TODAS as ferramentas Kubernetes
- 95: Instalar TODAS as Other Tools
- 96: Instalar TODAS as Web Tools
- 97: Instalar TODAS as UI Desktop Tools
- 99: Instalar TODAS as ferramentas

## 🧑‍💻 Pré-requisitos

- Uma máquina rodando **Ubuntu 24.04** ou superior e Mint 22 ou superior
- Privilégios sudo para instalar pacotes de software

## ⚙️ Instalação

1. Clone este repositório em sua máquina local:

   ```bash
   git clone https://github.com/diogofrj/platform-toolbox.git
   ```

2. Navegue até o diretório do projeto:

   ```bash
   cd platform-toolbox
   ```

3. Torne o script executável:

   ```bash
   chmod +x install-tools.sh
   ```

4. Execute o script para instalar as ferramentas:

   ```bash
   sudo ./install-tools.sh
   ```

O script cuidará da instalação dos pacotes e dependências necessários.

## 🏃 Uso

Depois que o script terminar de executar, as ferramentas estarão instaladas e prontas para uso. Você pode começar a usá-las de acordo com os requisitos do seu projeto.

Por exemplo:

- Para verificar a instalação do Docker: `docker --version`
- Para verificar o Ansible: `ansible --version`
- Para confirmar o Terraform: `terraform --version`

Sinta-se à vontade para modificar o script se quiser adicionar mais ferramentas ou ajustar o processo de instalação para sua configuração específica.

## 🏗️ Configuração do Vagrant

Se você quiser usar o Vagrant para configurar uma máquina virtual Ubuntu e clonar este repositório, siga estas etapas:

1. **Clone este repositório em sua máquina local:**

   ```bash
   git clone https://github.com/your-username/platform-toolbox.git
   ```
2. Navegue até o diretório do projeto:

   ```bash
   cd platform-toolbox
   ```

3. Execute o Vagrant para configurar a máquina virtual:

   ```bash
   vagrant up
   ```
Este comando configurará a VM Ubuntu, instalará o Git e clonará o repositório.

4. Acesse a VM via SSH:

   ```bash
   vagrant ssh
   ```

5. Uma vez dentro da VM, navegue até o diretório onde o repositório foi clonado:

   ```bash
   cd /home/vagrant/platform-toolbox
   ```

Execute o script de instalação manualmente:

   ```bash
   chmod +x install-tools.sh
   sudo ./install-tools.sh
   ```
6. Destruir o Vagrant

    ```bash
    vagrant destroy
    ```
    
## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma issue ou enviar um pull request com melhorias, novos recursos ou correções de bugs.

## 🤝 **Vamos nos Conectar!**

Se você achou este repositório útil e quer ver mais conteúdo como este, me siga no LinkedIn para ficar atualizado sobre mais projetos e recursos!

<p align="left">
<a href="https://linkedin.com/in/diogofernandesrj" target="blank"><img align="center" src="https://raw.githubusercontent.com/diogofrj/misc/main/images/Social/linked-in-alt.svg" alt="diogofernandesrj" height="30" width="40" /></a>
<a href="https://twitter.com/diogofrj" target="blank"><img align="center" src="https://raw.githubusercontent.com/diogofrj/misc/main/images/Social/twitter.svg" alt="diogofrj" height="30" width="40" /></a>
</p>

Se você gostaria de apoiar meu trabalho, você pode me pagar um café. Obrigado pelo seu apoio!

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/diogofrj)

## 🫵🏻 **Agradecimentos**

Este código foi inspirado no projeto [DevOps Tools on Ubuntu](https://github.com/francotel/devops-tools-on-ubuntu)
