# Configuração de recursos para o control plane
CONTROL_PLANE_MEMORY=4096 # 4GB RAM
CONTROL_PLANE_CPUS=4

# Configuração de recursos para os workers
WORKER_MEMORY=2048 # 2GB RAM por worker
WORKER_CPUS=2

# Configuração de rede
NETWORK_PREFIX="192.168.56"
CONTROL_PLANE_IP="${NETWORK_PREFIX}.10"
WORKER_IP_START=11 # Workers começarão do IP .11
