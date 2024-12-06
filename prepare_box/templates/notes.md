
# Configuração do MetalLB
Para expor os serviços do Kubernetes para a rede host-only, precisamos configurar o MetalLB.

# Primeiro, vamos instalar o MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

# Aguarde todos os pods do MetalLB estarem rodando
kubectl wait --namespace metallb-system \
                --for=condition=ready pod \
                --selector=app=metallb \
                --timeout=90s

# Agora, vamos configurar o pool de IPs que o MetalLB pode usar
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.56.200-192.168.56.250  # Range de IPs da sua rede host-only
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2-advert
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
EOF
```



# Você pode acessar através de qualquer IP dos nodes na porta 31207
curl http://192.168.56.10:31207  # via control-plane
curl http://192.168.56.11:31207  # via worker-1





########################################  
## Preparar imagem para o Vagrant


<!-- Crie e prepare a VM: -->

```shell
mkdir prepare_box
cd prepare_box
vagrant up
```

<!-- Empacote a VM em uma nova box: -->
```shell
vagrant package --output ubuntu-24.04-updated.box
```

<!-- Adicione a box ao seu repositório local: -->
```shell
vagrant box add ubuntu-24.04-updated ubuntu-24.04-updated.box
```
