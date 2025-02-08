#!/bin/bash
set -e  # Encerra o script imediatamente em caso de erro

# gh config set -h github.com git_protocol ssh

# Verifica argumentos
if [ $# -ne 2 ]; then
    echo "Uso: $0 <nome-repositorio> <descricao>"
    echo "Exemplo: $0 meunovorepo 'Meu novo repositório de projeto'"
    exit 1
fi

# Configurações
REPO_NAME="$1"
DESCRIPTION="$2"
GIT_USER="Diogo Fernandes"
GIT_EMAIL="diogo.frj@gmail.com"
GITHUB_USER="diogofrj"

# Configurar usuário do Git
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"

# Criar repositório local
echo "Criando repositório local: $REPO_NAME"
mkdir -p "$REPO_NAME"
cd "$REPO_NAME" || exit 1
git init
echo "# $REPO_NAME" > README.md
echo "$DESCRIPTION" >> README.md
echo -e "\n## Estrutura do Projeto\n\n\`\`\`" >> README.md
echo "coming soon..." >> README.md
echo -e "\`\`\`" >> README.md
git add .
git commit -m "Commit inicial: estrutura básica do projeto"

# Verificar se repositório remoto já existe
if git ls-remote "git@github.com:$GITHUB_USER/$REPO_NAME.git" &> /dev/null; then
    echo "Erro: Repositório remoto já existe!"
    exit 1
fi

Criar repositório no GitHub
echo "Criando repositório remoto no GitHub..."
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Erro: Variável GITHUB_TOKEN não definida!"
    exit 1
fi

API_URL="https://api.github.com/user/repos"
JSON_DATA="{\"name\":\"$REPO_NAME\", \"description\":\"$DESCRIPTION\", \"private\":false, \"auto_init\":false}"

RESPONSE=$(curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" -d "$JSON_DATA" "$API_URL")

if echo "$RESPONSE" | grep -q "errors"; then
    echo "Erro ao criar repositório:"
    echo "$RESPONSE" | jq '.errors[].message'
    exit 1
fi

# Configurar remote e push
echo "Configurando remote e enviando código..."
git remote add origin "git@github.com:$GITHUB_USER/$REPO_NAME.git"
git push -u origin main

echo "✅ Repositório criado com sucesso!"
echo "URL: https://github.com/$GITHUB_USER/$REPO_NAME"
