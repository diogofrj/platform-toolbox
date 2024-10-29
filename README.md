# 🚀 SRE Starter Kit for Ubuntu

Bem-vindo ao **SRE Starter Kit for Ubuntu**, um script que automatiza a instalação de ferramentas essenciais de DevOps/SRE em um sistema Ubuntu. Este projeto foi projetado para simplificar o processo de configuração para aqueles que precisam instalar e configurar rapidamente ferramentas DevOps/SRE em suas máquinas.

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
- Um script Bash (`install_tools.sh`) que instala ferramentas populares de DevOps/SRE em uma máquina Ubuntu.
- Um script Bash (`install-apps.sh`) que instala aplicações populares e de desenvolvimento em uma máquina Ubuntu.
- Um arquivo de configuração do Vagrant (`Vagrantfile`) para provisionar uma máquina virtual Ubuntu com um clone deste repositório para testes.
Seja configurando um ambiente de desenvolvimento novo ou configurando um pipeline de CI/CD, este script ajuda você a começar rapidamente.

## 🧰 Ferramentas Instaladas

Os scripts instalam as seguintes ferramentas e outras aplicações:

- 🐳 **Docker + LazyDocker**: Plataforma de containerização
- ☸️ **Kubernetes (kubectl)**: Ferramenta de linha de comando para controlar clusters Kubernetes
- 📜 **Ansible**: Ferramenta de gerenciamento de configuração
- 🌍 **Terraform**: Software de infraestrutura como código
- ⚙️ **Jenkins**: Servidor de automação para CI/CD
- 🔧 **Git**: Sistema de controle de versão
- 🟢 **Node.js**: Runtime JavaScript (opcional para alguns fluxos de trabalho DevOps)
- ☁️ **AWS CLI**: Interface de linha de comando da AWS
- ☁️ **Azure CLI**: Interface de linha de comando do Azure
- ☁️ **Google Cloud SDK**: SDK do Google Cloud Platform
- ⛵ **Helm**: Gerenciador de pacotes para Kubernetes
- 🏃‍♂️ **GitLab Runner**: Executor de CI/CD do GitLab
- 🔐 **HashiCorp Vault**: Gerenciador de segredos
- 🌐 **HashiCorp Consul**: Service mesh e descoberta de serviços
- 💿 **HashiCorp Packer**: Criação automatizada de imagens
- 💰 **Infracost**: Estimativa de custos de infraestrutura
- 👀 **k9s**: Interface TUI para Kubernetes
- 🏗️ **minikube**: Cluster Kubernetes local
- 🐍 **k3s**: Distribuição leve do Kubernetes
- 🗒️ **VS Codium**: Editor de código
- 📮 **Postman**: Plataforma de API
- 🔧 **Kustomize**: Gerenciador de configuração Kubernetes
- 📡 **Insomnia**: Cliente de API REST
- 🛠️ **Vagrant**: Gerenciador de máquinas virtuais

Você pode personalizar os scripts para incluir ou excluir ferramentas específicas conforme suas necessidades.

## 🧑‍💻 Pré-requisitos

- Uma máquina rodando **Ubuntu 22.04** ou posterior
- Privilégios sudo para instalar pacotes de software

## ⚙️ Instalação

1. Clone este repositório em sua máquina local:

   ```bash
   git clone https://github.com/your-username/sre-starter-kit.git
   ```

2. Navegue até o diretório do projeto:

   ```bash
   cd sre-starter-kit
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

Depois que o script terminar de executar, as ferramentas DevOps estarão instaladas e prontas para uso. Você pode começar a usá-las de acordo com os requisitos do seu projeto.

Por exemplo:

   ```bash
Para verificar a instalação do Docker: docker --version
Para verificar o Ansible: ansible --version
Para confirmar o Terraform: terraform --version
   ```

Sinta-se à vontade para modificar o script se quiser adicionar mais ferramentas ou ajustar o processo de instalação para sua configuração específica.

## 🏗️ Configuração do Vagrant

Se você quiser usar o Vagrant para configurar uma máquina virtual Ubuntu e clonar este repositório, siga estas etapas:

1. **Clone este repositório em sua máquina local:**

   ```bash
   git clone https://github.com/your-username/sre-starter-kit.git
   ```
2. Navegue até o diretório do projeto:

   ```bash
   cd sre-starter-kit
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
   cd /home/vagrant/sre-starter-kit
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