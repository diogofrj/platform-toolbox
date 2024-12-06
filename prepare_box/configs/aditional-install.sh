systemctl disable --now ufw
echo ''
echo '*****************************************************'
echo '*                                                   *'
echo '*   Instalando e configurando pacotes adicionais    *'
echo '*                                                   *'
echo '*****************************************************'
echo ''
apt update && apt upgrade -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt install -y chrony nmap zsh ca-certificates curl git vim
git clone https://github.com/robbyrussell/oh-my-zsh.git /etc/oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /etc/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
timedatectl set-timezone America/Sao_Paulo
localectl set-keymap br-abnt2
sed -i "s/en_US.UTF-8 UTF-8/#en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i "s/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/" /etc/locale.gen
locale-gen
cat << EOF > /etc/chrony/chrony.conf
server a.st1.ntp.br iburst
server b.st1.ntp.br iburst
server c.st1.ntp.br iburst
server d.st1.ntp.br iburst
server a.ntp.br iburst
server b.ntp.br iburst
server c.ntp.br iburst
server gps.ntp.br iburst
keyfile /etc/chrony/chrony.keys
driftfile /var/lib/chrony/drift
maxupdateskew 100.0
dumponexit
dumpdir /var/lib/chrony
makestep 1.0 3
rtcsync
leapsectz right/UTC
logdir /var/log/chrony
EOF

cat << EOF > /home/vagrant/.vimrc
set number              " Mostra números das linhas
set autoindent         " Auto-indentação
set expandtab          " Converte tabs em espaços
set tabstop=2          " Tab com 2 espaços
set shiftwidth=2       " Indentação com 2 espaços
set softtabstop=2      " Backspace remove 2 espaços
set wrap               " Quebra de linha
set linebreak          " Quebra linhas em palavras
set showmatch          " Mostra pares de parênteses
set hlsearch           " Destaca resultados da busca
set incsearch          " Busca incremental
set ignorecase         " Ignora maiúsculas/minúsculas na busca
set smartcase          " Busca case sensitive quando usar maiúsculas
set encoding=utf-8     " Codificação UTF-8
set fileencoding=utf-8 " Salva arquivos em UTF-8
syntax on              " Habilita syntax highlighting
colorscheme desert     " Tema de cores
set background=dark    " Fundo escuro
set cursorline        " Destaca linha atual
set ruler             " Mostra posição do cursor
set showcmd           " Mostra comandos parciais
set wildmenu          " Menu de autocompletar melhorado
EOF

sudo update-alternatives --set editor /usr/bin/vim

usermod --shell /bin/zsh vagrant
systemctl restart chronyd

# Cria um .zshrc básico para o usuário vagrant
cat << 'EOF' > /home/vagrant/.zshrc
# Configuração básica do ZSH
export ZSH="/etc/oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting docker)
source $ZSH/oh-my-zsh.sh

# Aliases básicos
alias ll='ls -la'
alias l='ls -l'
alias k='kubectl'

# Configuração do histórico
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Autocompletion
autoload -Uz compinit
compinit
EOF

# Ajusta as permissões do arquivo
chown vagrant:vagrant /home/vagrant/.zshrc
chmod 644 /home/vagrant/.zshrc


