Para configurar um ambiente Linux para trabalhar com duas contas do GitHub (uma pessoal e uma corporativa), você precisará configurar chaves SSH separadas e ajustar o arquivo de configuração do SSH. Aqui estão os passos:
Gerar chaves SSH para cada conta:

```bash	
# Para a conta pessoal
ssh-keygen -t rsa -b 4096 -C "seu_email_pessoal@exemplo.com" -f ~/.ssh/id_rsa_pessoal

# Para a conta corporativa
ssh-keygen -t rsa -b 4096 -C "seu_email_corporativo@exemplo.com" -f ~/.ssh/id_rsa_corporativo
```


Adicionar as chaves ao ssh-agent:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_personal
ssh-add ~/.ssh/id_rsa_corp
```


Configurar o arquivo ~/.ssh/config:

```bash
# Conta pessoal
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_personal

# Conta corporativa
Host github-corp
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_corp
```

# Adicione as chaves públicas ao GitHub:

- Copie o conteúdo de cada chave pública:

```bash
cat ~/.ssh/id_rsa_personal.pub
cat ~/.ssh/id_rsa_corp.pub
```
- Adicione as chaves nas configurações de SSH das respectivas contas do GitHub.



# Clonar repositórios:

- Para repositórios pessoais:

```bash
git clone git@github-personal:username/repo.git
```

- Para repositórios corporativos:

```bash
git clone git@github-corp:username/repo.git
```

# Configurar o Git localmente:    

Dentro de cada repositório, configure o usuário e email corretos:

```bash
     # Para repositórios pessoais
     git config user.name "Seu Nome Pessoal"
     git config user.email "seu_email_pessoal@exemplo.com"

     # Para repositórios corporativos
     git config user.name "Seu Nome Corporativo"
     git config user.email "seu_email_corporativo@exemplo.com"
```

Seguindo esses passos, você poderá trabalhar com ambas as contas do GitHub no mesmo ambiente Linux sem conflitos.


# Remover configurações globais anteriores do Git:

Para remover as configurações globais anteriores do Git, você pode usar os seguintes comandos:

Remover o nome global:

```bash
git config --global --unset user.name
```

Remover o email global:

```bash
git config --global --unset user.email
```


