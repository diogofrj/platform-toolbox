# 🌍 Terragrunt Cheat Sheet

## 🔧 Comandos Básicos

```bash
# Inicializar diretório Terragrunt
terragrunt init

# Planejar mudanças
terragrunt plan

# Aplicar mudanças
terragrunt apply

# Destruir recursos
terragrunt destroy

# Executar em todos os subdiretórios
terragrunt run-all plan
terragrunt run-all apply
```

## 📁 Estrutura de Arquivos

```hcl
terragrunt.hcl
include {
path = find_in_parent_folders()
}
terraform {
source = "git::git@github.com:org/modules.git//module?ref=v1.0.0"
}
inputs = {
environment = "prod"
region = "us-east-1"
}
```

## 📚 Referências
```

## 🔄 Remote State
```hcl
# terragrunt.hcl
remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "terraformstate"
    container_name      = "tfstate"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
  }
}
```

## 🎯 Dependências
```hcl
# Dependência explícita
dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
}

# Dependências mock
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "mock-vpc-id"
  }
}
```

## 🔍 Variáveis e Locals
```hcl
locals {
  environment = get_env("TF_VAR_environment", "dev")
  aws_region  = "us-east-1"
  common_tags = {
    Environment = local.environment
    ManagedBy   = "Terragrunt"
  }
}

inputs = {
  tags = local.common_tags
}
```

## 📝 Generate Blocks
```hcl
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "azurerm" {}
}
EOF
}
```

## 🔐 Hooks
```hcl
terraform {
  before_hook "before_hook" {
    commands = ["apply", "plan"]
    execute  = ["echo", "Running before hook"]
  }

  after_hook "after_hook" {
    commands     = ["apply", "plan"]
    execute      = ["echo", "Running after hook"]
    run_on_error = true
  }
}
```

## 🎨 Funções Úteis
```hcl
# Encontrar arquivos
find_in_parent_folders()
get_parent_terragrunt_dir()
path_relative_to_include()

# Variáveis de ambiente
get_env("ENV_VAR", "default_value")

# Leitura de arquivos
file("path/to/file")
read_terragrunt_config("../config/common.hcl")
```

## 📝 Boas Práticas

1. **Estrutura de Diretórios**
   - Use estrutura modular
   - Separe por ambiente
   - Mantenha configurações comuns em arquivos compartilhados
   - Use paths relativos

2. **Gerenciamento de Estado**
   - Configure remote state adequadamente
   - Use workspaces quando apropriado
   - Implemente state locking
   - Mantenha backup do state

3. **Código**
   - Use DRY (Don't Repeat Yourself)
   - Implemente versionamento de módulos
   - Documente inputs e outputs
   - Use formatação consistente

4. **Segurança**
   - Nunca commite secrets
   - Use variáveis de ambiente
   - Implemente RBAC
   - Audite mudanças

## 🔍 Debug
```bash
# Habilitar debug
export TERRAGRUNT_DEBUG=true

# Log verbose
terragrunt plan --terragrunt-log-level debug

# Limpar cache
terragrunt clean

# Verificar source download
terragrunt terragrunt-info
```

## 🚀 Exemplos de Uso Comum

### Estrutura Multi-ambiente
```
.
├── terragrunt.hcl
├── prod
│   ├── terragrunt.hcl
│   ├── vpc
│   │   └── terragrunt.hcl
│   └── app
│       └── terragrunt.hcl
└── dev
    ├── terragrunt.hcl
    ├── vpc
    │   └── terragrunt.hcl
    └── app
        └── terragrunt.hcl
```

### Configuração Comum
```hcl
# common.hcl
locals {
  common_tags = {
    Project     = "MyProject"
    ManagedBy   = "Terragrunt"
  }
}
```

Este cheat sheet fornece uma referência completa para operações comuns do Terragrunt, incluindo exemplos práticos e boas práticas para gerenciamento de infraestrutura como código.
```

O arquivo foi criado com informações abrangentes sobre Terragrunt, incluindo comandos básicos, exemplos de configuração, boas práticas e dicas de debug. Você pode encontrá-lo em `grc-iac-az-hml-cfg/docs/cheatsheets/terragrunt-cheatsheet.md`.